#!/usr/bin/env bash
# Builds a client-deliverable Veritaq plugin bundle. WSL / macOS / Linux.
# PowerShell equivalent: tools/build-client-bundle.ps1
#
# A plugin directory on its own cannot be installed. /plugin install works
# against a marketplace, so the bundle pairs a generated marketplace.json with
# the plugin. Versions come from each plugin.json, so they cannot drift.
#
# Usage:
#   tools/build-client-bundle.sh professionals/tax-accountants/plugins/tax-accountant-in-a-box
#   tools/build-client-bundle.sh <plugin-dir> [<plugin-dir> ...]

set -euo pipefail

BUNDLE_NAME="veritaq"          # stable; a re-delivery replaces this folder in place
OUT_DIR="${OUT_DIR:-dist}"
STAGE="$OUT_DIR/$BUNDLE_NAME"

[ $# -ge 1 ] || { echo "usage: $0 <plugin-dir> [<plugin-dir> ...]" >&2; exit 1; }

rm -rf "$STAGE"
mkdir -p "$STAGE/.claude-plugin"

ENTRIES_JSON="[]"

for SRC in "$@"; do
  SRC="${SRC%/}"
  MANIFEST="$SRC/.claude-plugin/plugin.json"
  [ -f "$MANIFEST" ] || { echo "Not a plugin directory (no .claude-plugin/plugin.json): $SRC" >&2; exit 1; }

  # Refuse to ship a vertical folder by mistake
  for forbidden in testbed tools marketing; do
    if [ -d "$SRC/$forbidden" ]; then
      echo "$SRC contains '$forbidden'. That is a vertical folder, not a plugin directory." >&2
      exit 1
    fi
  done

  NAME=$(python3 -c "import json,sys;print(json.load(open(sys.argv[1]))['name'])" "$MANIFEST")
  VER=$(python3 -c "import json,sys;print(json.load(open(sys.argv[1])).get('version',''))" "$MANIFEST")
  [ -n "$VER" ] || { echo "$NAME has no version in plugin.json. Clients never receive updates without one." >&2; exit 1; }

  cp -r "$SRC" "$STAGE/$NAME"
  find "$STAGE/$NAME" \( -name '*~' -o -name '*.bak' -o -name '*.swp' \) -type f -delete

  ENTRIES_JSON=$(python3 - "$ENTRIES_JSON" "$MANIFEST" <<'PY'
import json, sys
entries = json.loads(sys.argv[1])
m = json.load(open(sys.argv[2]))
entry = {
    "name": m["name"],
    "source": "./" + m["name"],
    "description": m.get("description", ""),
    "version": m["version"],
}
# Only carry optional keys that actually have a value. A null in marketplace.json
# is not the same as an absent key and some readers reject it.
for k in ("category", "keywords"):
    if m.get(k):
        entry[k] = m[k]
entries.append(entry)
print(json.dumps(entries))
PY
)
  printf "  packaged %-32s v%s\n" "$NAME" "$VER"
done

python3 - "$STAGE" "$BUNDLE_NAME" "$ENTRIES_JSON" <<'PY'
import json, sys, os
stage, bundle, entries = sys.argv[1], sys.argv[2], json.loads(sys.argv[3])

with open(os.path.join(stage, ".claude-plugin", "marketplace.json"), "w") as f:
    json.dump({
        "name": bundle,
        "owner": {"name": "Veritaq", "email": "dev@veritaq.net"},
        "plugins": entries,
    }, f, indent=2)

installs = "\n".join(f"       /plugin install {e['name']}@{bundle}" for e in entries)
table = "\n".join(f"| {e['name']} | {e['version']} |" for e in entries)

open(os.path.join(stage, "INSTALL.md"), "w").write(f"""# Veritaq plugins

## Install

1. Put this folder somewhere permanent, for example:

       %USERPROFILE%\\{bundle}

   **Do not move or delete it afterwards.** Claude references this folder by
   path rather than copying it, so moving it breaks the plugins.

2. Open Claude Desktop and run:

       /plugin marketplace add %USERPROFILE%\\{bundle}

3. Install what you have been given:

{installs}

4. Choose **user scope** so it works in every folder, not just one project.

5. If you see `Run /reload-plugins to activate`, run that too.

## Included

| Plugin | Version |
|---|---|
{table}

## Updating

Replace this whole folder with the newer one, keeping the same path, then run:

    /plugin marketplace update {bundle}

## Getting started

See `docs/setup-guide.md` inside the plugin folder.
""")
PY

STAMP=$(date +%Y%m%d)
ZIP="$OUT_DIR/$BUNDLE_NAME-plugins-$STAMP.zip"
rm -f "$ZIP"
( cd "$OUT_DIR" && zip -qr "$(basename "$ZIP")" "$BUNDLE_NAME" )

echo
echo "Bundle: $ZIP"
echo "Client unzips it, then: /plugin marketplace add <path>/$BUNDLE_NAME"
