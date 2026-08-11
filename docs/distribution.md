# Distribution

Two tracks. Internal work goes through git; clients get a built zip.

---

## Internal, via git

For anyone with repo access.

```
/plugin marketplace add <org>/veritaq-plugins
/plugin install <plugin-name>@veritaq
```

If the install summary says `Run /reload-plugins to activate`, run it.

**Keep the repository private.** These are paying client deliverables.

### During development

```bash
claude --plugin-dir ./professionals/<profession>/plugins/<plugin-name>
```

Loads for that session only, and takes precedence over an installed copy of the same name, so you can test changes without uninstalling. `/reload-plugins` picks up edits without restarting.

---

## External, via a client bundle

Clients get no repo access, and a plugin directory on its own **cannot be installed**: `/plugin install` works against a marketplace. So a client bundle pairs a generated marketplace with the plugin.

### Build it, never assemble by hand

```powershell
.\tools\build-client-bundle.ps1 -Plugin .\professionals\tax-accountants\plugins\tax-accountant-in-a-box
```

```bash
tools/build-client-bundle.sh professionals/tax-accountants/plugins/tax-accountant-in-a-box
```

The script reads each version from `plugin.json`, so the bundle's marketplace cannot disagree with the plugin inside it. Hand-assembly has already produced three files claiming three different versions once.

It also refuses to package a directory containing `testbed/`, `tools/`, `marketing/` or `dist/`, which is the guard against pointing it at a vertical folder by mistake.

Output:

```
dist/veritaq-plugins-<date>.zip
└── veritaq/
    ├── .claude-plugin/marketplace.json   generated
    ├── INSTALL.md                        written for the client
    └── <plugin-name>/
```

### A client with several products

Pass more than one plugin. They arrive in one bundle sharing one marketplace:

```bash
tools/build-client-bundle.sh \
  professionals/tax-accountants/plugins/tax-accountant-in-a-box \
  companies/acme/plugins/acme-in-a-box
```

**One bundle per client, never one per product.** The bundle is always named `veritaq`. Two separately shipped bundles both named `veritaq` collide, and the client cannot register both.

### What the client does

1. Unzip somewhere **permanent**, for example `%USERPROFILE%\veritaq`.
2. `/plugin marketplace add %USERPROFILE%\veritaq`
3. `/plugin install <plugin-name>@veritaq`
4. Choose **user scope**, so it works in every folder rather than one project.

`INSTALL.md` in the bundle says all of this, and lists exactly which plugins they have.

### The trap worth repeating to them

**A directory marketplace is referenced by path, not copied.** If they move or delete the folder, the plugin breaks. Tell them where to put it and that it stays there. This is the single most likely support call.

---

## Versioning

| Change | Bump |
|---|---|
| Wording, clarifications | patch |
| A new skill, a new domain pack, a new optional config field | minor |
| Anything requiring the user to change their own files | **major** |

That last row is the one that matters. Skills read the user's config and their own context files, so changing what those must contain breaks every existing install. Bump major and tell them what to add.

Update the version in **two** places for internal distribution: the plugin's `plugin.json` and the repo-root `marketplace.json`. `tools/check-plugin.sh` fails if they disagree. Client bundles derive from `plugin.json` alone, so there is nothing to keep in sync there.

### Shipping an update to a client

Rebuild the bundle, send it, and have them replace the folder in place, keeping the same path. Then:

```
/plugin marketplace update veritaq
```

---

## Before shipping anything

```bash
tools/check-plugin.sh
claude plugin validate ./professionals/<profession>/plugins/<plugin-name>
```

Then run that plugin's own release tests. For anything that writes to a user's system, the important one is running it twice and confirming the second run changes nothing.
