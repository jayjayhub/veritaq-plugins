---
name: client-deadline-calendar
description: Use this skill whenever the tax accountant wants client tax deadlines reflected in their calendar, or wants to know who is at risk of missing one. Trigger on requests like "update my deadline calendar", "who is due in the next month", "who is not ready", "add [client] to the calendar", "what is coming up", "sync my deadlines", "am I going to miss anything", "when do I need [client]'s documents by", or whenever a new client is added and the engagement dates need to exist somewhere they will actually be seen. Also trigger when they ask what their next few weeks look like in workload terms, or when a client's year end or engagement type changes and the dates need to move.
---

# Client Deadline Calendar

Tax deadlines cluster hard, they are computable from a few facts per client, and missing one has real consequences. This skill keeps a dedicated calendar converged with the deadlines implied by the client folders, and answers questions about what is coming.

## The governing principle

**The calendar is derived, never authored.** The source of truth is each client's `CLAUDE.md`. Every date on the calendar is computed from it. You do not invent events, and you do not treat the calendar as a place where information lives. If a date is wrong on the calendar, the fix is in `CLAUDE.md`, then re-run.

This means the operation is a **reconciliation**, not a creation. Compute the desired set of events, read the actual set, and converge. Running this skill five times in a row must produce the same calendar as running it once.

## Before starting

1. **Read the practice config** for the calendar system, deadline calendar ID, cut-off lead time, chase cadence, event title convention and filing method.
2. **Read the jurisdiction pack** named in the config for the deadline rules.

Then confirm all three:

- A **separate calendar** for tax deadlines exists. Look it up by the ID in the config, or list the available calendars to find it. If it does not exist, ask for it to be created and stop. Do not fall back to the primary calendar.
- Its ID is recorded in the practice config. If not, ask, then have it added.
- The practice root contains client folders, each with a `CLAUDE.md`.

**Never write to the primary calendar.** A separate calendar means the whole thing can be hidden with one checkbox if it becomes noise, which is the difference between this being adopted and abandoned.

## What each client needs

Read every client `CLAUDE.md` and extract:

- **Entity type**
- **Engagement type**, which forms apply
- **Financial year end**, where the entity has one
- **Status**, skip anything marked filed or closed for the current year
- **Document cut-off lead time**, if overridden for that client, otherwise the practice default

If a client is missing entity type, engagement type, or year end, **do not guess**. List those clients as "cannot compute, missing data" and carry on with the rest. A missing field is a five-minute fix; a guessed deadline is a filing risk.

## Deadline rules

Compute from the deadline table in the jurisdiction pack. **Any date in the client's `CLAUDE.md` overrides the computed one**, always, without argument. The tax accountant knows the client's actual circumstances; the pack does not.

Use the column matching the filing method in the practice config, electronic or manual, and note the other date in the event description.

**Every computed date is a proposal until confirmed.** On first creation, mark the description `Computed, not yet confirmed`. Drop the marker once confirmed or once the date is written into `CLAUDE.md`. Deadlines shift, grace periods get extended, and entity circumstances vary. Never present a computed date as settled.

## What goes on the calendar

Three kinds of event per client, and nothing else. Resist adding more.

### 1. Statutory deadline

The immovable external date.

- **Title:** `[Client] · [Form] due`, using the title convention from the practice config
- All-day, marked free so it does not block working hours
- Reminders: 14 days and 3 days before

### 2. Document cut-off

The internal date after which an on-time filing stops being realistic. **This is the event that actually changes behaviour**, because the statutory deadline only announces itself on the day it is already too late to start.

- **Title:** `[Client] · Documents needed by`
- Default lead time from the practice config, unless the client's `CLAUDE.md` overrides it
- All-day, marked free
- Reminder: 7 days before

### 3. Chase reminder

A recurring nudge while documents are outstanding.

- **Title:** `[Client] · Chase documents`
- Recurring at the practice chase cadence, starting when the request was sent, ending at the document cut-off
- All-day, marked free
- **Stop condition:** when the client's status is no longer awaiting documents, delete the remaining recurrence. A chase reminder for a client who already delivered is exactly the noise that gets a calendar muted.

Use distinct colours for the three kinds so urgency reads at a glance.

## The reconciliation marker

Every event this skill creates carries a marker on the **last line of its description**:

```
tab-deadline:<client-slug>:<form>:<year>:<kind>
```

For example: `tab-deadline:lim-trading:form-c:2026:statutory`

This is how the skill recognises its own work. Rules, without exception:

- **Read** using the deadline calendar ID and a full-text search for `tab-deadline:`.
- **Only ever modify or delete an event carrying this marker.** An event without one belongs to the tax accountant. Leave it alone, even if it looks like a duplicate.
- Never write the marker to the primary calendar.

## The reconciliation itself

1. Read all client `CLAUDE.md` files. Build the **desired** event set.
2. Read existing marked events from the deadline calendar. That is the **actual** set.
3. Diff into four buckets:
   - **Create:** in desired, not in actual
   - **Update:** in both, but date or title differs
   - **Delete:** in actual, not in desired, meaning filed, closed, or a corrected year end
   - **Unchanged:** leave completely alone, do not touch or re-write
4. **Show the plan before executing.** A table of what will be created, updated and deleted, with a reason for each. Wait for approval.
5. Execute only what was approved.
6. Report what changed, then separately list any clients skipped for missing data.

Step 4 is not optional. This skill writes to a system the practice depends on. Every batch is approved.

## Answering "who is at risk"

This gets asked more often than a sync, and it requires writing nothing.

Produce a table ordered by urgency:

| Client | Next deadline | Date | Days left | Documents | Risk |
|---|---|---|---|---|---|

- **Documents:** complete, partial, or nothing received, from the client folder
- **Risk:** `On track`, `Tight`, `At risk`, or `Cut-off passed`
- Mark `At risk` when the document cut-off has passed and documents are still incomplete
- Mark `Cut-off passed` when there is no longer time to do the work properly, and say so plainly rather than softening it

Close with the one client to deal with today, and why. A ranked list without a recommendation makes them do the prioritising again.

## Workload warning

Tax deadlines cluster by season, and the jurisdiction pack shows where. When more than four clients share a document cut-off inside the same fortnight, say so, and suggest pulling the earliest cut-offs forward rather than letting the pile-up arrive.

## Confidentiality

Event titles follow the naming convention set in the practice config, which lists the available options.

Client names on a calendar are client-identifying information. They appear on phone lock screens, in screen shares, and anywhere the calendar is shared. Keeping this on a separate private calendar limits the exposure but does not remove it.

If a change is ever wanted, it is a config edit: switch the convention to short codes and keep full names in `CLAUDE.md` only. Mention this **once**, if confidentiality is raised. Do not repeat it every run.

**Never put figures, tax positions, or document contents in an event.** A deadline event contains a client identifier, a form, and a date. Nothing else.

## Judgement calls to raise rather than make

- A computed deadline looks wrong for a client's circumstances. Say so, do not silently correct it.
- A client has no year end recorded, so nothing can be computed.
- A cut-off has already passed and the realistic options are an estimate, an extension, or an accepted late filing. Flag it; that call belongs to the tax accountant.
- Deleting more than five events in one run. Stop and confirm separately; that usually means a `CLAUDE.md` was edited wrongly, not that eight engagements closed at once.
