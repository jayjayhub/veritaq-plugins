<#
.SYNOPSIS
    Builds a client-deliverable Veritaq plugin bundle.

.DESCRIPTION
    A plugin directory on its own cannot be installed. `/plugin install` works
    against a marketplace, so a client bundle needs a marketplace.json alongside
    the plugin. This script generates that, copies in only the shippable plugin
    directories, and zips the result.

    Versions are read from each plugin's own plugin.json, so the bundle's
    marketplace can never disagree with the plugin it ships. That is the whole
    point of building rather than copying by hand.

    Never run against a vertical folder directly: those contain testbed/, tools/
    and marketing/, none of which should reach a client.

.PARAMETER Plugin
    One or more plugin directories. Each must contain .claude-plugin/plugin.json.

.PARAMETER OutDir
    Where to write the bundle. Defaults to ./dist.

.EXAMPLE
    .\tools\build-client-bundle.ps1 -Plugin .\professionals\tax-accountants\plugins\tax-accountant-in-a-box

.EXAMPLE
    # A client who has bought two products gets one bundle containing both
    .\tools\build-client-bundle.ps1 -Plugin .\professionals\tax-accountants\plugins\tax-accountant-in-a-box, .\companies\acme\plugins\acme-in-a-box
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string[]] $Plugin,

    [string] $OutDir = "dist"
)

$ErrorActionPreference = "Stop"

$BundleName = "veritaq"   # stable. A re-delivery replaces this folder in place.
$stage = Join-Path $OutDir $BundleName

if (Test-Path $stage) { Remove-Item $stage -Recurse -Force }
New-Item -ItemType Directory -Path (Join-Path $stage ".claude-plugin") -Force | Out-Null

$entries = @()

foreach ($src in $Plugin) {
    $src = (Resolve-Path $src).Path
    $manifestPath = Join-Path $src ".claude-plugin\plugin.json"

    if (-not (Test-Path $manifestPath)) {
        throw "Not a plugin directory (no .claude-plugin\plugin.json): $src"
    }

    $m = Get-Content $manifestPath -Raw | ConvertFrom-Json
    $name = $m.name
    $version = $m.version

    if ([string]::IsNullOrWhiteSpace($version)) {
        throw "$name has no version in plugin.json. Set one before shipping, or clients never receive updates."
    }

    # Guard: refuse to ship anything that is not a plugin directory
    foreach ($forbidden in @("testbed", "tools", "marketing")) {
        if (Test-Path (Join-Path $src $forbidden)) {
            throw "$src contains '$forbidden'. You have pointed at a vertical folder, not a plugin directory."
        }
    }

    Copy-Item $src -Destination (Join-Path $stage $name) -Recurse
    # strip editor backups that may have been copied in
    Get-ChildItem (Join-Path $stage $name) -Recurse -Include "*~", "*.bak", "*.swp" -File |
        Remove-Item -Force -ErrorAction SilentlyContinue

    $entry = [ordered]@{
        name        = $name
        source      = "./$name"
        description = $m.description
        version     = $version
    }
    # Only carry optional keys that actually have a value. A null in
    # marketplace.json is not the same as an absent key, and some readers
    # reject it.
    if ($m.category) { $entry.category = $m.category }
    if ($m.keywords) { $entry.keywords = $m.keywords }
    $entries += $entry

    Write-Host ("  packaged {0,-30} v{1}" -f $name, $version)
}

$marketplace = [ordered]@{
    name    = $BundleName
    owner   = [ordered]@{ name = "Veritaq"; email = "dev@veritaq.net" }
    plugins = $entries
}

$marketplace | ConvertTo-Json -Depth 10 |
    Set-Content (Join-Path $stage ".claude-plugin\marketplace.json") -Encoding UTF8

# Install instructions travel with the bundle. Clients will not read a separate email.
$readme = @"
# Veritaq plugins

## Install

1. Put this folder somewhere permanent, for example:

       %USERPROFILE%\veritaq

   **Do not move or delete it afterwards.** Claude references this folder by
   path rather than copying it, so moving it breaks the plugins.

2. Open Claude Desktop and run:

       /plugin marketplace add %USERPROFILE%\veritaq

3. Install what you have been given:

$($entries | ForEach-Object { "       /plugin install $($_.name)@$BundleName" } | Out-String)
4. Choose **user scope** so it works in every folder, not just one project.

5. If you see ``Run /reload-plugins to activate``, run that too.

## Included

| Plugin | Version |
|---|---|
$($entries | ForEach-Object { "| $($_.name) | $($_.version) |" } | Out-String)

## Updating

Replace this whole folder with the newer one, keeping the same path, then run:

    /plugin marketplace update $BundleName

## Getting started

See ``docs/setup-guide.md`` inside the plugin folder.
"@

Set-Content (Join-Path $stage "INSTALL.md") $readme -Encoding UTF8

$stamp = Get-Date -Format "yyyyMMdd"
$zip = Join-Path $OutDir "$BundleName-plugins-$stamp.zip"
if (Test-Path $zip) { Remove-Item $zip -Force }
Compress-Archive -Path $stage -DestinationPath $zip

Write-Host ""
Write-Host "Bundle: $zip"
Write-Host "Client unzips it, then: /plugin marketplace add <path>\$BundleName"
