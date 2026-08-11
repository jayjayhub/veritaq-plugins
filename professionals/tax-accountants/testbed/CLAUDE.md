# Tax Practice — Practice Context

> **TESTBED.** This is a simulated practice used to exercise the plugin. The clients are invented and the documents are generated. Nothing here is real client data.
>
> It stands in for what `practice-setup` would have produced, so the later skills can be tested without running setup first. To test `practice-setup` itself, point it at an empty folder instead.

## What this folder is

The working root of a tax practice. Each subfolder is one client engagement and carries its own `CLAUDE.md` with that client's specifics.

When working here you are assisting a licensed professional, not replacing one. You draft, organise, extract, check and summarise. The tax accountant decides. The tax treatment of any item, the filing position, whether a figure is correct, what is submitted to the tax authority, and what goes to a client are always theirs.

## Structure

```
testbed/
├── CLAUDE.md                        ← this file
├── jurisdiction/malaysia-tax.md     ← the accountant's editable copy
├── Lim-Trading-Sdn-Bhd-YA2025/      ← mid-engagement, documents short, deadline close
├── Hong-Seng-Motor-YA2025/          ← documents complete, work not started
└── Seri-Maju-Enterprise-YA2026/     ← bare folder, not yet onboarded
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

**Practice name:** `JQ Tax Advisory`
**Tax accountant:** `Test User`
**Jurisdiction pack:** `jurisdiction/malaysia-tax.md`

### Calendar

**Calendar system:** `mock-calendar (testbed only)`
**Deadline calendar ID:** `tax-deadlines@group.calendar.mock`

Resolve it with `list_calendars` if the ID ever changes. Never write to `primary`.

**Event titles use:** `full client names`

### Chasing and deadlines

**Default document cut-off lead time:** `6 weeks` before the filing deadline
**Chase cadence while documents are outstanding:** `weekly`
**Primary chasing channel:** `WhatsApp`
**Secondary channel:** `email`

### Filing

**Filing method:** `electronic`
**Tax software in use:** `none, spreadsheets only`

### Defaults

**Preferred spreadsheet format:** `.xlsx`
**Correspondence tone:** `warm and direct, no corporate padding`
**Working language:** `English`

### Checklist additions

Items this practice asks for that are not in the standard jurisdiction checklists.

| Item | Engagement type | Why |
|---|---|---|
| Directors' loan account movements | Form C | Recurring adjustment, easier to ask for up front than to reconstruct |

### Standing notes

March to April is Form E and Form BE season. Expect no capacity for new engagements then.
