# Tax Practice — Practice Context

> **Where this goes:** the top level of the practice folder, above all client folders. For example `Documents\Tax Practice\CLAUDE.md`. Claude reads it automatically whenever work happens anywhere inside the practice, so settings here apply to every client without being repeated.
>
> **What to fill in:** the Practice settings section at the bottom. Everything above it applies to any tax practice and is already written.
>
> **This file is the only place the plugin is personalised.** The skills ship generic. Everything specific to this practice, the accountant, the jurisdiction and the way they prefer to work, lives here.

## What this folder is

The working root of a tax practice. Each subfolder is one client engagement and carries its own `CLAUDE.md` with that client's specifics.

When working here you are assisting a licensed professional, not replacing one. You draft, organise, extract, check and summarise. The tax accountant decides. The tax treatment of any item, the filing position, whether a figure is correct, what is submitted to the tax authority, and what goes to a client are always theirs.

## Structure

```
Tax Practice/
├── CLAUDE.md              ← this file, practice-wide settings
├── Lim-Trading-YA2026/
│   ├── CLAUDE.md          ← that client's specifics
│   ├── 01-Client-Communications/
│   ├── 02-Source-Documents/
│   ├── 03-Workpapers/
│   ├── 04-Deliverables/
│   └── 05-Engagement-Admin/
└── Tan-Ah-Kow-YA2025/
    └── ...
```

## Rules that apply everywhere in this practice

- **Say where a fact came from.** Name the file. The tax accountant needs to be able to check you.
- **Never state a tax deadline as settled fact.** Use the date in the client's `CLAUDE.md`. Failing that, use the jurisdiction pack and say clearly that it is computed and needs confirming.
- **Flag, do not resolve.** Missing, illegible, ambiguous or inconsistent material becomes an open item, never a plausible assumption.
- **No figures in client-facing drafts.** Chasers and document requests are about what is missing, not what the numbers say.
- **Nothing sends or submits itself.** Every message and filing is a draft for review.
- **Confidentiality.** Client records here are covered by the professional body and data protection obligations named in the jurisdiction pack. Do not repeat national identity numbers, full account numbers or income figures back in output. This folder is local; syncing or connecting any part of it is an explicit decision, never a default.

---

## Practice settings

### Practice

**Practice name:** `[practice or firm name]`
**Tax accountant:** `[name]`
**Jurisdiction pack:** `jurisdiction/malaysia-tax.md`
*Your own editable copy, placed here by `practice-setup`. Correct its checklists as you use them; this copy is the one the skills read, and a plugin update will not overwrite it. Point this at a different pack to work in another jurisdiction; the skills do not change.*

### Calendar

**Calendar system:** `[Google Calendar / Outlook / none]`
**Deadline calendar ID:** `[paste from list_calendars, looks like ...@group.calendar.google.com]`

Must be a **separate** calendar, never the primary one, so the whole thing can be hidden with one checkbox if it gets noisy.

**Event titles use:** `[full client names / short client codes]`
*Full names are more readable. Codes keep client identity off lock screens and out of screen shares. The accountant's call.*

### Chasing and deadlines

**Default document cut-off lead time:** `6 weeks` before the filing deadline
*Override per client in that client's `CLAUDE.md` where a client is reliably slow or unusually quick.*

**Chase cadence while documents are outstanding:** `weekly`
**Primary chasing channel:** `[WhatsApp / email / phone]`
**Secondary channel:** `[...]`

### Filing

**Filing method:** `[electronic / manual]`
*Electronic filing usually carries a later deadline. This determines which column of the jurisdiction pack's deadline table applies.*

**Tax software in use:** `[none / name of package]`
*Where tax software is in use, capital allowance schedules and return submission happen there. Claude's job is to feed it, not reproduce it.*

### Defaults

**Preferred spreadsheet format:** `[.xlsx / Google Sheets / .csv]`
**Correspondence tone:** `[e.g. warm and direct, no corporate padding]`
**Working language:** `[English / Bahasa Malaysia / bilingual]`

### Checklist additions

Items this practice asks for that are not in the standard jurisdiction checklists. `client-engagement-plan` proposes these alongside the standard list, so the checklist improves as the practice uses it rather than staying at whatever shipped on day one.

Add an item here once it has come up for more than one client. Note which engagement type it belongs to.

| Item | Engagement type | Why |
|---|---|---|
| | | |

### Standing notes

[Anything true across the whole practice. Examples: "March is Form E season, expect no capacity for new work." "Never contact clients on Fridays after 4pm." "Two clients share a director, do not cross-reference them in correspondence."]
