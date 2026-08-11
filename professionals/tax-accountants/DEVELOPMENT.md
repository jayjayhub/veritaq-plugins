# Development

How this repo is laid out, and how to run the plugin against a simulated practice.

---

## Layout

This vertical sits inside the `veritaq-plugins` monorepo:

```
veritaq-plugins/                          ← repo root, THE marketplace
├── .claude-plugin/marketplace.json       ← the only marketplace file in the repo
├── professionals/
│   └── tax-accountants/                  ← this vertical
│       ├── plugins/
│       │   └── tax-accountant-in-a-box/  ← THE SHIPPABLE UNIT. Nothing else ships
│       │       ├── .claude-plugin/plugin.json
│       │       ├── DESIGN.md
│       │       ├── README.md
│       │       ├── docs/
│       │       ├── reference/malaysia-tax.md
│       │       ├── skills/
│       │       └── templates/
│       ├── testbed/                      ← simulated practice. Never ships
│       ├── tools/mock-calendar-mcp/      ← local calendar. Never ships
│       ├── marketing/                    ← deck and diagrams. Never ships
│       └── .mcp.json
├── companies/                            ← future: companies/<COMPANY>/plugins/<name>/
└── tools/build-client-bundle.ps1         ← builds client zips
```

**Only `plugins/tax-accountant-in-a-box/` is the product.** Testbed, tools and marketing sit outside it deliberately, so an install never carries test fixtures or sales collateral. The build script refuses to package a directory containing any of them.

**One marketplace file, at the repo root.** A `marketplace.json` inside a vertical would register a second marketplace under the same name and collide. Verticals contain plugins; they are not marketplaces.

**Paths below are relative to this vertical folder.** Run Claude from `professionals/tax-accountants/`, not from the repo root, so `testbed/CLAUDE.md` and `.mcp.json` resolve.

### Why there is no `CLAUDE.md` at the repo root

`CLAUDE.md` files cascade from the working directory upward. A repo-level one would be loaded during a testbed run and tell Claude it is working on a plugin repo, which contaminates the simulation. Repo guidance lives in this file instead, which is not auto-loaded.

`testbed/CLAUDE.md` is a real practice config and is meant to be loaded.

---

## Running the testbed

```bash
cd veritaq-plugins
claude --plugin-dir ./plugins/tax-accountant-in-a-box
```

Then move into the simulated practice so its `CLAUDE.md` is the one in scope:

```
cd testbed
```

The mock calendar starts automatically from `.mcp.json`. Confirm with `/mcp`; you should see `mock-calendar` with five tools.

**opencode or another client:** the `.mcp.json` format is standard. Point it at `python3 tools/mock-calendar-mcp/server.py` from the repo root, and load the skills from `plugins/tax-accountant-in-a-box/skills/`.

---

## What is in the testbed

Three clients, each in a different state, so every branch of the user guide can be reached.

| Client | State | Exercises |
|---|---|---|
| **Lim Trading Sdn Bhd** YA2025 | Mid-engagement. Deadline 31 Aug 2026, cut-off already passed, 8 of 12 items in | chase, extraction, at-risk reporting |
| **Hong Seng Motor** YA2025 | Documents complete, work not started | the contrast case in "who is at risk" |
| **Seri Maju Enterprise** YA2026 | Bare folder, no `CLAUDE.md` | `client-intake` from scratch, then `client-engagement-plan` |

### Fixtures, and what each is for

In `Lim-Trading-Sdn-Bhd-YA2025/02-Source-Documents/`:

| File | Purpose |
|---|---|
| 11 × `maybank-current-2025-*.csv` | Clean, machine-readable. **High** confidence tier |
| ⤷ **November** | Closing balance is **1,240.00 short** of its own movements. The control total must catch this. Nothing else in the file hints at it |
| ⤷ **March is absent** | Completeness must be measured against the engagement plan, not against what happens to be present |
| `fixed-asset-invoice-TSH-2025-0418.pdf` | Clean digital PDF, line items sum to the stated total. **High** confidence |
| `IMG_2041.jpg` | Photograph: skewed, cropped, out of focus. Must land in the **refuse** tier and be reported, never guessed |

The calendar seed also carries a fixture: `Hong Seng Motor · Form C due` has **no reconciliation marker**. It stands for an event the accountant created by hand. If a sync ever modifies or deletes it, invariant 6 is broken.

---

## Walkthrough

Mirrors `plugins/tax-accountant-in-a-box/docs/user-guide.md`. Run from `testbed/`.

| # | Say | Expect |
|---|---|---|
| 1 | *who's at risk this month?* | Lim Trading first, cut-off passed, 8 of 12. Hong Seng complete. Should mention the stock listing was late last year |
| 2 | *what's outstanding for Lim Trading?* | 4 items. Must read the plan, not rebuild the list. Must not chase the audited accounts, the company is audit exempt |
| 3 | *draft a follow-up for Lim Trading* | Recognises this as the **second** follow-up. WhatsApp version first, that is the configured channel. No figures anywhere in it |
| 4 | *extract the bank statements* | 10 of 11 months reconcile. **November flagged, out by 1,240.00.** March reported missing. `IMG_2041.jpg` reported unreadable. Workpaper marked UNVERIFIED |
| 5 | *update my deadline calendar* | Shows a plan before writing. **Must not touch the Hong Seng event** |
| 6 | *(run 5 again)* | **No changes.** If it duplicates, reconciliation is broken |
| 7 | `cd Seri-Maju-Enterprise-YA2026` then *run client intake* | Interview, then echo Form C due 28 Feb 2027 for a 30 June 2026 year end, before writing anything |
| 8 | *plan this engagement* | Proposes a checklist including the practice's own addition, directors' loan account movements |

### What failure looks like

| Symptom | Broken |
|---|---|
| November passes reconciliation | Control totals not being computed |
| The unreadable photo is silently skipped | Source inventory not produced. This is the worst failure mode |
| A figure appears without a source file | Provenance not being recorded |
| Extraction labels anything deductible or capital | Invariant 7. The hard line has been crossed |
| Second calendar run creates duplicates | Marker-based reconciliation not working |
| Hong Seng's hand-made event is modified | Invariant 6 |
| Chase rebuilds the checklist from the pack | Invariant 9, two owners for one artifact |

---

## Resetting between runs

Test runs write files. Reset before re-testing:

```bash
rm -f tools/mock-calendar-mcp/calendar-store.json
rm -f testbed/*/03-Workpapers/*.xlsx testbed/*/03-Workpapers/*.csv
rm -rf testbed/Seri-Maju-Enterprise-YA2026/0* testbed/Seri-Maju-Enterprise-YA2026/CLAUDE.md
git checkout -- testbed/
```

The calendar store regenerates from `calendar-seed.json` on next start. Everything a run produces is gitignored, so `git status` should be clean after a reset.

---

## Before shipping

```bash
claude plugin validate ./plugins/tax-accountant-in-a-box
```

Then the two separation checks from `DESIGN.md`:

```bash
# Jurisdiction facts in skills — expect ONE hit, the labelled example in client-intake
grep -rlEi "lhdn|form c\b|sdn bhd|myinvois|mitrs|cp204|RM[0-9]" plugins/tax-accountant-in-a-box/skills/

# Personal preferences in skills — expect NOTHING
grep -rniE "whatsapp|google calendar|\b6 weeks\b|full client name" plugins/tax-accountant-in-a-box/skills/*/SKILL.md
```

Both caught real leaks the first time they were run. Treat a new hit as a bug, not noise.

---

## Two distribution tracks

### Internal, via git

For you and anyone with repo access.

```
/plugin marketplace add <org>/veritaq-plugins
/plugin install tax-accountant-in-a-box@veritaq
```

**Keep the repository private while these are paying client deliverables.**

Bump `version` in `plugins/tax-accountant-in-a-box/.claude-plugin/plugin.json` **and** in the repo-root `.claude-plugin/marketplace.json`. Users only receive updates when it changes.

### External, via a zipped bundle

Clients get no repo access, so they get a self-contained bundle. **Build it, never copy a folder by hand:** the script reads versions from `plugin.json`, so the bundle's marketplace cannot disagree with the plugin it ships.

```powershell
.\tools\build-client-bundle.ps1 -Plugin .\professionals\tax-accountants\plugins\tax-accountant-in-a-box
```

```bash
tools/build-client-bundle.sh professionals/tax-accountants/plugins/tax-accountant-in-a-box
```

Produces `dist/veritaq-plugins-<date>.zip` containing a `veritaq/` folder with a generated `marketplace.json`, the plugin, and an `INSTALL.md` written for the client.

The client unzips it somewhere permanent, then:

```
/plugin marketplace add %USERPROFILE%\veritaq
/plugin install tax-accountant-in-a-box@veritaq
```

choosing **user scope**.

**Three things to hold onto about client delivery:**

1. **A directory marketplace is referenced by path, not copied.** If the client moves or deletes the folder, the plugin breaks. `INSTALL.md` says this; say it again when you hand it over.
2. **One bundle per client, not one per product.** The bundle is always named `veritaq`. A client who later buys a second plugin gets a new bundle containing both, replacing the old folder. Two separately-shipped bundles both named `veritaq` would collide.
3. **Updates replace the folder in place**, then `/plugin marketplace update veritaq`.

Changing what the practice config must contain is a **breaking** change for every existing user, because their config was written by an older version. Bump the major version and tell them what to add.
