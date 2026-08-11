#!/usr/bin/env bash
# Structural checks for any plugin in this repo, plus marketplace consistency.
#
#   tools/check-plugin.sh professionals/tax-accountants/plugins/tax-accountant-in-a-box
#   tools/check-plugin.sh --all
#
# Generic checks live here. Plugin-specific invariants live with the plugin, in
# an optional executable `.checks.sh` at the plugin root, which this runs last.
# That keeps this script useful for every future vertical without accumulating
# one vertical's rules.
#
# Exit 0 = pass. Exit 1 = at least one failure.

set -uo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MARKET="$REPO/.claude-plugin/marketplace.json"
FAILED=0

pass() { printf "  \033[32mPASS\033[0m  %s\n" "$1"; }
fail() { printf "  \033[31mFAIL\033[0m  %s\n" "$1"; FAILED=1; }
warn() { printf "  \033[33mWARN\033[0m  %s\n" "$1"; }

check_plugin() {
  local dir="${1%/}"
  local abs; abs="$(cd "$dir" 2>/dev/null && pwd)" || { fail "no such directory: $dir"; return; }
  local rel="${abs#$REPO/}"
  echo
  echo "── $rel"

  local manifest="$abs/.claude-plugin/plugin.json"
  if [ ! -f "$manifest" ]; then
    fail "no .claude-plugin/plugin.json. This is not a plugin directory"
    return
  fi

  if ! python3 -c "import json;json.load(open('$manifest'))" 2>/dev/null; then
    fail "plugin.json is not valid JSON"; return
  fi

  local name version dirname
  name=$(python3 -c "import json;print(json.load(open('$manifest')).get('name',''))")
  version=$(python3 -c "import json;print(json.load(open('$manifest')).get('version',''))")
  dirname=$(basename "$abs")

  [ -n "$name" ] && pass "plugin.json name: $name" || fail "plugin.json has no name"
  [ -n "$version" ] && pass "version: $version" \
    || fail "no version. Without one, clients never receive updates"
  [ "$name" = "$dirname" ] && pass "directory name matches plugin name" \
    || fail "directory is '$dirname' but plugin is named '$name'. Keep them identical"

  # Only plugin.json belongs inside .claude-plugin. Editor backups are gitignored,
  # so they are noise rather than a defect; report them separately.
  local strays backups
  strays=$(find "$abs/.claude-plugin" -mindepth 1 -not -name "plugin.json" \
             -not -name "*~" -not -name "*.bak" -not -name "*.swp" 2>/dev/null | wc -l)
  backups=$(find "$abs/.claude-plugin" -mindepth 1 \
             \( -name "*~" -o -name "*.bak" -o -name "*.swp" \) 2>/dev/null | wc -l)
  [ "$strays" -eq 0 ] && pass ".claude-plugin holds only plugin.json" \
    || fail ".claude-plugin holds $strays unexpected item(s). skills/ and the rest belong at the plugin root"
  [ "$backups" -gt 0 ] && warn "$backups editor backup(s) in .claude-plugin. Gitignored, but delete them"

  # Nothing that must never ship
  local leaked=0
  for forbidden in testbed tools marketing dist node_modules; do
    [ -e "$abs/$forbidden" ] && { fail "contains '$forbidden', which must never ship inside a plugin"; leaked=1; }
  done
  [ $leaked -eq 0 ] && pass "no test, tooling or marketing content inside the plugin"

  # Skills
  if [ -d "$abs/skills" ]; then
    local n=0 bad=0
    for d in "$abs"/skills/*/; do
      [ -d "$d" ] || continue
      n=$((n+1))
      local s="$d/SKILL.md"
      if [ ! -f "$s" ]; then
        fail "skills/$(basename "$d") has no SKILL.md"; bad=1; continue
      fi
      head -1 "$s" | grep -q '^---$' || { fail "skills/$(basename "$d")/SKILL.md has no frontmatter"; bad=1; }
      grep -q '^description:' "$s" || { fail "skills/$(basename "$d")/SKILL.md has no description, so it will never trigger"; bad=1; }
    done
    [ $bad -eq 0 ] && pass "$n skills, all with frontmatter and a description"
  else
    warn "no skills/ directory"
  fi

  # Consistency with the repo marketplace
  if [ -f "$MARKET" ]; then
    python3 - "$MARKET" "$REPO" "$abs" "$name" "$version" <<'PY'
import json, os, sys
market, repo, abs_, name, version = sys.argv[1:6]
m = json.load(open(market))
hit = None
for p in m.get("plugins", []):
    if os.path.normpath(os.path.join(repo, p.get("source", ""))) == os.path.normpath(abs_):
        hit = p; break
if hit is None:
    print("  \033[33mWARN\033[0m  not listed in the repo marketplace")
    raise SystemExit(0)
ok = True
if hit.get("name") != name:
    print(f"  \033[31mFAIL\033[0m  marketplace calls it '{hit.get('name')}', plugin.json says '{name}'"); ok = False
if hit.get("version") != version:
    print(f"  \033[31mFAIL\033[0m  marketplace version {hit.get('version')} != plugin.json {version}"); ok = False
if ok:
    print("  \033[32mPASS\033[0m  marketplace entry agrees on name and version")
raise SystemExit(0 if ok else 1)
PY
    [ $? -ne 0 ] && FAILED=1
  fi

  # Plugin-specific invariants, if the plugin defines any
  if [ -f "$abs/.checks.sh" ]; then
    echo "  ── plugin-specific checks"
    if bash "$abs/.checks.sh" "$abs"; then :; else FAILED=1; fi
  fi
}

check_marketplace() {
  echo "── marketplace"
  [ -f "$MARKET" ] || { fail "no .claude-plugin/marketplace.json at the repo root"; return; }
  python3 -c "import json;json.load(open('$MARKET'))" 2>/dev/null \
    && pass "marketplace.json is valid JSON" || { fail "marketplace.json is not valid JSON"; return; }

  local extra
  extra=$(find "$REPO" -name marketplace.json -not -path "*/.git/*" -not -path "$MARKET" -not -path "*/dist/*" | wc -l)
  [ "$extra" -eq 0 ] && pass "exactly one marketplace.json in the repo" \
    || fail "$extra extra marketplace.json found. A vertical is not a marketplace, and duplicate names collide"

  python3 - "$MARKET" "$REPO" <<'PY'
import json, os, sys
m = json.load(open(sys.argv[1])); repo = sys.argv[2]
bad = False
for p in m.get("plugins", []):
    src = os.path.normpath(os.path.join(repo, p.get("source", "")))
    if os.path.isfile(os.path.join(src, ".claude-plugin", "plugin.json")):
        print(f"  \033[32mPASS\033[0m  {p['name']} source resolves")
    else:
        print(f"  \033[31mFAIL\033[0m  {p['name']} source does not resolve: {p.get('source')}"); bad = True
raise SystemExit(1 if bad else 0)
PY
  [ $? -ne 0 ] && FAILED=1
}

echo "Checking $REPO"
check_marketplace

if [ "${1:-}" = "--all" ] || [ $# -eq 0 ]; then
  while IFS= read -r manifest; do
    check_plugin "$(dirname "$(dirname "$manifest")")"
  done < <(find "$REPO" -name plugin.json -path "*/.claude-plugin/*" -not -path "*/.git/*" -not -path "*/dist/*")
else
  for d in "$@"; do check_plugin "$d"; done
fi

echo
[ $FAILED -eq 0 ] && { echo "All checks passed."; exit 0; } || { echo "Failures above. Fix before shipping."; exit 1; }
