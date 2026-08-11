# Tax Accountant in a Box

Claude skills for a small tax practice: onboarding clients, chasing missing documents, and keeping filing deadlines in a calendar.

Ships configured for **Malaysia**. Designed so a second jurisdiction is a file swap, not a rewrite.

## What's in it

| Skill | Does |
|---|---|
| `practice-setup` | First-run setup: creates the practice config by interview, copies the jurisdiction pack into the accountant's own folder, and checks which connectors are live |
| `client-intake` | Interviews the accountant about a new client, validates the answers, then builds the folder structure and writes the client's `CLAUDE.md` |
| `client-engagement-plan` | Proposes a tailored document checklist, works the schedule backwards from the filing deadline, then writes the plan and drafts the first document request |
| `client-document-chase` | Works out what a client still owes against the agreed plan, then drafts the follow-up across four escalation levels |
| `source-to-workpaper` | Extracts figures from client source documents into a structured spreadsheet, with provenance on every row and control totals that make checking fast |
| `client-deadline-calendar` | Keeps a dedicated calendar converged with the deadlines implied by the client folders, and answers "who is at risk" |

Plus a practice config template, a client folder template, the Malaysia jurisdiction pack, and a setup guide.

They run in that order for a new client, and each one hands off to the next. The checklist is owned by `client-engagement-plan` and read by everything downstream, so it exists in exactly one place.

## How it's put together

Three layers, deliberately separated.

**Skills** hold workflow logic only. Interview structure, escalation levels, reconciliation, output formats. No country facts, no personal preferences.

**The jurisdiction pack** (`reference/malaysia-tax.md`) holds every country-specific fact: entity types, forms, deadline rules, document checklists, audit exemption tests, e-invoicing phases, filing mechanism, professional body and privacy law, vocabulary.

**The practice config** (the accountant's own `CLAUDE.md` at their practice root) holds everything personal: practice name, which jurisdiction pack, calendar ID, cut-off lead time, chase cadence, naming convention, filing method, tone.

The result is that personalising this plugin is filling in one file, and porting it to Singapore or Australia is writing one new reference pack while the skills stay untouched.

## Design rules the skills follow

- **Derived, not authored.** The client's `CLAUDE.md` is the source of truth. The calendar is computed from it and reconciled, never hand-maintained. Running a sync five times equals running it once.
- **One owner per artifact.** The checklist is written by `client-engagement-plan` and read by the rest. Nothing rebuilds a list another skill already agreed with the accountant.
- **Propose, do not interrogate.** Skills present a filtered draft for correction rather than asking the accountant to produce lists from memory. Verification is faster and more accurate than generation.
- **The checklist improves itself.** Items added during planning are noticed, and once one recurs across clients it gets promoted into the practice config so it is proposed automatically.
- **Never guess.** `TBC` is an honest answer. An invented year end is a filing risk.
- **No bracketed placeholders in generated files.** Every field is a real answer or `TBC`.
- **Show the plan before writing.** Anything that modifies a calendar or a folder presents a create/update/delete plan first.
- **Only touch your own work.** The calendar skill will not modify an event it did not create, even one that looks like a duplicate.
- **The accountant decides.** Tax treatment, filing position, whether a figure is right, and anything going to the tax authority or the client. Skills surface questions rather than answering them.
- **Extraction produces facts, never treatment.** `source-to-workpaper` pulls figures out verbatim and stops. It does not decide what is deductible, capital, or allowable. A treatment decision buried in a spreadsheet column looks like a fact and stops being questioned.
- **Verification must be cheaper than re-entry.** Every extracted figure carries its source file, location and confidence, and every batch reconciles to a control total the document itself asserts. Reviewing fourteen flagged rows and four totals beats checking three hundred.

## Adding a jurisdiction

1. Copy `reference/malaysia-tax.md`, rename for the new country.
2. Replace the contents. **Keep the section headings identical**, the skills refer to them by name.
3. Point `Jurisdiction pack` in the practice config at the new file.

No skill changes.

## Setup

Install the plugin, connect Gmail and Google Calendar yourself in Settings, then say **"set up my practice"**. About twenty minutes to a working practice with one client onboarded.

- `docs/setup-guide.md` — the accountant's installation manual, install through first client
- `docs/user-guide.md` — what using it looks like, a full engagement with worked examples
- `docs/quick-reference.md` — one page of what to say, for their first fortnight
- `docs/packaging-and-install.md` — for whoever is distributing this

**Connectors are not bundled and cannot be.** They are a per-user authorisation between the accountant's own account and a service. `practice-setup` checks what is connected and says what is missing; each grant is made by the accountant in Claude's settings.

## Honest limitations

- **Email attachments cannot be opened.** Claude can see that a file arrived and what it is called, not read it. Attachments are saved to the client folder by hand. Connector limitation, not a setting.
- **Filing is manual.** No connector exists for government tax portals and none is expected.
- **The tax computation is assisted, not automated.** Capital allowances and treatment decisions are judgement and case law. Skills draft and question; they do not conclude.
- **Extraction quality depends entirely on document quality.** Native digital PDFs and spreadsheets extract reliably. Clean scans usually do. Phone photographs of receipts are flagged for review as a matter of course, and handwriting is refused rather than guessed. This is a property of the source material, not something a better prompt fixes.
