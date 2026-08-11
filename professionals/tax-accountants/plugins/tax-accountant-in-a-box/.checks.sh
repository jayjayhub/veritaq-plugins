#!/usr/bin/env bash
# Plugin-specific invariants for tax-accountant-in-a-box.
# Run by tools/check-plugin.sh. Argument is this plugin's root.
#
# These enforce the three-layer separation described in DESIGN.md: skills hold
# workflow logic only, the jurisdiction pack holds country facts, and the
# practice config holds preferences. Both checks caught real leaks the first
# time they were run.

set -uo pipefail
P="${1:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
FAILED=0

pass() { printf "    \033[32mPASS\033[0m  %s\n" "$1"; }
fail() { printf "    \033[31mFAIL\033[0m  %s\n" "$1"; FAILED=1; }

# --- Invariant 1: no jurisdiction facts in skills -----------------------------
# Exactly one accepted hit: the labelled deadline-echo example in client-intake,
# where a concrete example is worth more than an abstract one. Anything else is
# a leak that would make porting to a second country a rewrite.
JURIS=$(grep -rlEi "lhdn|form c\b|sdn bhd|myinvois|mitrs|cp204|RM[0-9]" "$P/skills" 2>/dev/null || true)
JCOUNT=$(printf "%s" "$JURIS" | grep -c . || true)
if [ "$JCOUNT" -eq 0 ]; then
  pass "no jurisdiction facts in skills"
elif [ "$JCOUNT" -eq 1 ] && printf "%s" "$JURIS" | grep -q "client-intake"; then
  pass "jurisdiction facts confined to the documented client-intake example"
else
  fail "jurisdiction facts leaked into skills:"
  printf "%s\n" "$JURIS" | sed "s|$P/|          |"
fi

# --- Invariant 2: no personal preferences in skills ---------------------------
# A preference belongs in the practice config. Even a default belongs in the
# config template, not in the skill that reads it, so there is one place to change it.
PREF=$(grep -rniE "whatsapp|google calendar|\b6 weeks\b|full client name" "$P"/skills/*/SKILL.md 2>/dev/null || true)
if [ -z "$PREF" ]; then
  pass "no hardcoded preferences in skills"
else
  fail "preferences hardcoded in skills, move them to the practice config:"
  printf "%s\n" "$PREF" | sed "s|$P/|          |"
fi

# --- Invariant 9: one owner per artifact --------------------------------------
# The engagement plan is written by client-engagement-plan and read by the rest.
# Two writers means two checklists that drift.
WRITERS=$(grep -rl "Write \`05-Engagement-Admin/engagement-plan.md\`" "$P/skills" 2>/dev/null | wc -l)
if [ "$WRITERS" -le 1 ]; then
  pass "engagement plan has a single writer"
else
  fail "$WRITERS skills claim to write the engagement plan. Exactly one may own it"
fi

exit $FAILED
