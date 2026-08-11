# Design

Why this is built the way it is. For whoever maintains, extends or ports it.

`README.md` describes what the plugin does. This describes the reasoning, including what was tried and rejected, so settled questions do not get quietly re-litigated.

---

## Design goals, in priority order

1. **The accountant's licence is never at risk.** No skill decides anything a professional signs their name to.
2. **Verification must be cheaper than doing it by hand.** A skill whose output takes as long to check as to produce is worse than useless, because it also carries risk.
3. **First-run friction near zero.** The target user is busy and sceptical. Anything resembling homework before value is delivered kills adoption.
4. **Honest about limits.** Naming a constraint up front costs one slide. Discovering it in week two costs the relationship.
5. **Portable to another jurisdiction without touching skills.**

Where these conflict, the higher number yields.

---

## Architecture: three layers

The central idea. Everything else follows from it.

| Layer | Holds | Lives | Changes when |
|---|---|---|---|
| **Skills** | Workflow logic only. Interview structure, escalation levels, reconciliation, output formats | Plugin, `skills/` | The workflow itself changes |
| **Jurisdiction pack** | Every country fact. Entities, forms, deadlines, checklists, thresholds, regulators, vocabulary | Copied into the practice folder | Tax law changes, or a new country |
| **Practice config** | Everything personal. Practice name, calendar, cut-off, cadence, naming, filing method, tone | The accountant's practice root `CLAUDE.md` | The accountant changes how they work |

**Consequence:** personalising the plugin is filling in one file. Porting it is writing one reference pack. A skill file should contain no country name and no person's preference.

### Enforcing the separation

Run before shipping. Both checks earned their place immediately: the first run of them caught two real leaks.

```bash
# 1 · Skills must contain no jurisdiction facts
grep -rlEi "lhdn|form c\b|sdn bhd|myinvois|mitrs|cp204|RM[0-9]" skills/

# 2 · Skills must contain no personal preference
grep -rniE "whatsapp|google calendar|\b6 weeks\b|full client name" skills/*/SKILL.md
```

**Check 2 must return nothing.** A preference belongs in the practice config. Even a default value belongs in the config *template*, not in the skill that reads it, so there is one place to change it.

**Check 1 has exactly one accepted hit:** `client-intake`, in the block showing the shape of the deadline echo. It is prefixed *"using the Malaysia pack as the example"* and the surrounding instruction says to use whatever the loaded pack provides. A concrete example is worth more than an abstract one here. **Any other hit is a leak.**

---

## Data model

Who owns what. **Every artifact has exactly one owner**; everything else reads it.

| Artifact | Owner | Readers | Contains |
|---|---|---|---|
| Practice `CLAUDE.md` | `practice-setup` | all | Config, checklist additions |
| Jurisdiction pack | shipped, then the accountant | all | Country facts |
| Client `CLAUDE.md` | `client-intake` | all | Stable client facts |
| `engagement-plan.md` | `client-engagement-plan` | chase, extract | Checklist, schedule, dependencies |
| Deadline calendar | `client-deadline-calendar` | none | Derived dates only |
| Workpaper `.xlsx` | `source-to-workpaper` | the accountant | Extracted figures, provenance |

**Stable facts live in `CLAUDE.md`. Working state lives in the plan.** A client's year end belongs in `CLAUDE.md`; whether the bank statements have arrived does not. Conflating them makes `CLAUDE.md` a status tracker, and it will rot.

### Dependency order

```
practice-setup
    └── client-intake
            └── client-engagement-plan
                    ├── client-document-chase
                    └── source-to-workpaper
            └── client-deadline-calendar
```

Each skill checks its precondition and stops with a pointer rather than improvising. `client-document-chase` will not rebuild a checklist because the plan is missing; it says to run the plan skill.

---

## Invariants

Break these and the design stops holding. Every one exists because of a specific failure it prevents.

| # | Invariant | Prevents |
|---|---|---|
| 1 | Skills contain no jurisdiction facts | Porting becomes a rewrite |
| 2 | Skills contain no personal preferences | Every client needs a forked plugin |
| 3 | Generated files never contain bracketed placeholders | Claude reads `[Sdn Bhd / sole proprietor]` as content |
| 4 | `TBC` is always valid; never guess | An invented year end becomes a wrong filing date |
| 5 | Nothing writes without showing a plan first | Silent corruption of a system the practice depends on |
| 6 | The calendar only modifies events carrying its own marker | Destroying the accountant's own entries |
| 7 | Extraction never assigns tax treatment | A treatment decision in a spreadsheet column looks like a fact and stops being questioned |
| 8 | Never adjust a figure to force a reconciliation | Hides the error instead of finding it |
| 9 | One owner per artifact | Two checklists that drift apart |
| 10 | Never state a deadline as settled fact | Deadlines and grace periods change; a confident wrong date is worse than an uncertain right one |

---

## Decisions and rejected alternatives

The valuable part. Each records what was chosen, what was not, and why.

### D1 · Source documents live in a local folder, not cloud storage

**Chosen:** the accountant saves attachments into `02-Source-Documents` on their own machine.
**Rejected:** Google Drive as the document store, with Claude reading from it.

Local sidesteps the hardest confidentiality conversation entirely, and Claude Desktop reads local files natively. Drive would have required the accountant to decide whether every client document may be processed by a cloud service before getting any value. It also removes a connector from the critical path.

### D2 · Email attachments are not extracted

**Chosen:** the accountant saves attachments by hand.
**Rejected:** a skill that pulls attachments out of client emails.

**Tested empirically, not assumed.** The Gmail connector returns `attachments: [{filename, id, mimeType}]` and no file bytes; there is no attachment-download tool. A second finding shaped the design further: a single message returned 121KB, of which 99% was `htmlBody`, and `METADATA_ONLY` excludes attachment filenames. So there is no cheap way to enumerate what a client sent.

**Consequence:** anything email-driven should be *query-driven* rather than *enumeration-driven*. Ask "has the EA form arrived" using search operators, do not try to list everything.

### D3 · Connectors are not bundled

**Chosen:** `practice-setup` performs a runtime preflight and reports what is missing.
**Rejected:** declaring Gmail and Calendar in `.mcp.json`.

They are claude.ai connectors: a per-user OAuth grant. The authorisation is a credential and cannot travel in a plugin. They are also already available to any signed-in user, so bundling duplicates. `.mcp.json` is for servers we write ourselves.

### D4 · Onboarding is conversational, not a spreadsheet

**Chosen:** `client-intake` interviews and generates.
**Rejected:** a client master spreadsheet that generates all folders in bulk.

The spreadsheet is faster for an existing book and suits a spreadsheet-native user, but it is homework before any value is delivered, and that is where a sceptical prospect drops out. Conversational gets one working client in two minutes.

**Still open:** bulk onboarding has no answer. If a practice has thirty clients, the spreadsheet route becomes worth building.

### D5 · Interviews verify rather than generate

**Chosen:** propose a filtered draft, have the accountant correct it. Echo derived consequences back before writing.
**Rejected:** asking them to fill in fields or produce lists from memory.

Checking is faster and more accurate than generating, and it catches errors immediately. This is why `client-intake` echoes computed deadlines and `client-engagement-plan` proposes a checklist rather than asking for one. It is also why the full profile survived: fifteen fields as an interview is a different experience from fifteen blanks in a file.

### D6 · Standardise on `01-05` folders

**Chosen:** every client folder has the same five subfolders.
**Rejected:** adopting whatever structure the accountant already has, in place.

Consistency is what lets a skill say "check `02-Source-Documents`" and have it work for every client. **Known cost:** the accountant reorganises their existing book before seeing benefit, which is a real adoption risk. Adopt-in-place was the safer choice for adoption and the worse one for everything downstream.

### D7 · The engagement plan owns the checklist

**Chosen:** `client-engagement-plan` writes it; `client-document-chase` reads it.
**Rejected:** chase building the checklist itself from the jurisdiction pack.

Chase was originally doing three jobs. Two skills generating the same list from the same source will drift the moment the accountant amends one. The plan is also where per-client amendments belong.

### D8 · The jurisdiction pack is copied, not referenced

**Chosen:** `practice-setup` copies it into the practice folder; the config points at that copy.
**Rejected:** skills reading it from inside the plugin.

The checklists are a best-knowledge starting point and the accountant is expected to correct them. A file inside the plugin cannot be edited and would be overwritten on update.

**Known cost:** improvements to the shipped pack do not reach existing users. A diff skill would close this if it becomes a problem.

### D9 · The calendar reconciles; it does not create

**Chosen:** compute desired state, read actual state, diff, converge. Events carry a `tab-deadline:` marker.
**Rejected:** creating events when a client is onboarded.

Create-on-event duplicates whenever anything re-runs, and cannot handle a moved year end. Reconciliation is idempotent: five runs equal one. The marker is what makes it safe to delete, because an unmarked event is the accountant's.

**Rejected also:** JT's original "seven stages on the calendar". Only three event types belong there: statutory deadline, document cut-off, chase reminder. Phases 4 and 5 are work, not appointments, and putting status on a calendar creates a second source of truth that will drift from the folder.

### D10 · Extraction produces facts, never treatment

**Chosen:** extract verbatim, preserve the client's own description, stop.
**Rejected:** classifying items as deductible, capital or allowable during extraction.

This is the highest-risk boundary in the plugin. A treatment decision sitting in a spreadsheet column looks like a fact and stops being questioned. Extraction and computation are separate steps with a hard line between them.

### D11 · Control totals, not sampling

**Chosen:** reconcile every batch against a figure the document itself asserts.
**Rejected:** verifying every row; verifying a sample.

Every row is too slow and the skill gets abandoned. A sample leaves the accountant professionally exposed. A control total that reconciles means the items inside it are probably right, and one that fails has already localised the error. This converts "check 300 rows" into "check 14 flagged rows and 4 totals", which is the difference between adoption and abandonment.

### D12 · Ship Malaysia rather than jurisdiction-agnostic

**Chosen:** full Malaysian content, isolated in one file.
**Rejected:** stripping country specifics to work anywhere.

The checklists and deadline rules are where the value is. Generic tax workflow skills are obvious and worth little. Isolation gives portability without giving up depth.

---

## Skill contracts

| Skill | Reads | Writes | Must never |
|---|---|---|---|
| `practice-setup` | plugin templates | practice config, jurisdiction copy | Claim a connector is connected without checking |
| `client-intake` | practice config, pack | client `CLAUDE.md`, `01-05` folders | Guess a fact; overwrite standing notes |
| `client-engagement-plan` | config, pack, client `CLAUDE.md` | `engagement-plan.md`, first request | Compress an impossible schedule silently |
| `client-document-chase` | plan, client `CLAUDE.md` | plan status, draft messages | Rebuild the checklist; put figures in a client message |
| `source-to-workpaper` | plan, source documents | workpaper `.xlsx` | Assign treatment; guess a digit; force a total |
| `client-deadline-calendar` | all client `CLAUDE.md` | deadline calendar only | Touch the primary calendar or an unmarked event |

---

## Extending

### Add a jurisdiction

1. Copy `reference/malaysia-tax.md`, rename.
2. Replace contents. **Keep the section headings identical** — skills refer to them by name.
3. Point `Jurisdiction pack` in the practice config at it.

No skill changes. If you find yourself editing a skill, something jurisdiction-specific leaked into it; fix the leak instead.

**Untested.** Only one pack exists. Writing a second is the only way to know whether the seam is in the right place, and it will probably reveal one or two leaks.

### Add a skill

1. Decide what artifact it owns. If the answer is "one that already exists", it should extend that skill instead.
2. State its precondition and the skill to point at when unmet.
3. Read config and pack; hardcode neither country facts nor preferences.
4. If it writes anything, show a plan and get approval.
5. Add it to the README table, the setup guide's skill list, and the quick reference.

### Change what the practice config must contain

This is a **breaking change** for every existing user, because their config was written by an older version. Bump the major version and say what they need to add.

---

## Known weaknesses

Honest list. All are live.

| Weakness | Impact | Mitigation |
|---|---|---|
| **Checklists are researched, not practice-derived** | The weakest content in the plugin. Built from public sources, never validated by a working accountant | The self-improving mechanism helps over time. One review session with a real practitioner would help more |
| **Extraction quality is unvalidated** | Never run against real client documents. Value differs enormously between native PDFs and phone photographs | Test with the worst source material available before promising anything |
| **Portability claim untested** | One jurisdiction pack exists | Write a second pack |
| **No bulk onboarding** | A practice with thirty clients faces thirty interviews | The rejected spreadsheet route, if it becomes the blocker |
| **`01-05` standardisation** | Asks the accountant to reorganise before seeing value | Watch for resistance; adopt-in-place remains a fallback |
| **Pack updates do not reach existing users** | Consequence of D8 | A diff skill |
| **Docs go stale silently** | Already happened once within days | Check docs whenever a skill is added or a flow changes |

---

## Testing before release

```bash
claude plugin validate ./tax-accountant-in-a-box
```

Then, in order, because each depends on the last:

1. `practice-setup` in an empty folder — produces a config and copies the pack?
2. `client-intake` for an individual and a company — does branching differ, is the deadline echo right?
3. `client-engagement-plan` — sensible checklist, refuses an impossible schedule?
4. `client-document-chase` — reads the plan rather than rebuilding?
5. `client-deadline-calendar` — **run twice. The second run must produce no changes.** Duplicate events mean the reconciliation is broken, and that failure destroys trust in the whole plugin.
6. `source-to-workpaper` — test with the worst documents available, not the best.
