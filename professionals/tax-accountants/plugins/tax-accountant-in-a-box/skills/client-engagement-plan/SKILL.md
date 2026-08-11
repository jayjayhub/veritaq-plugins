---
name: client-engagement-plan
description: Use this skill whenever the tax accountant is starting work on a client for a tax year and needs the engagement planned out: what documents to ask for, who provides each one, when everything is due, and the first request to send. Trigger on requests like "plan this engagement", "what do I need from [client]", "build the checklist for [client]", "draft the document request", "set up the plan for [client]", "what's the timeline for [client]", "start work on [client]", or whenever a client has just been onboarded and the next question is what to actually ask them for. Also trigger when an existing plan needs revising because scope changed, a deadline moved, or the client turned out to have something unexpected.
---

# Client Engagement Plan

This is the planning step for one client, one tax year. It produces three linked things: a **tailored document checklist**, a **schedule of dates** working backwards from the filing deadline, and the **first document request** ready to send.

The checklist this produces becomes the source of truth for the whole engagement. `client-document-chase` reads it rather than rebuilding it, so what is agreed here is what gets chased later.

## Before starting

1. **Read the practice config** for the jurisdiction pack, cut-off lead time, channel, tone, and any checklist additions the practice has accumulated.
2. **Read the jurisdiction pack** for the master document checklists and deadline rules.
3. **Read the client's `CLAUDE.md`** for entity type, engagement type, year end, contact and standing notes.

**If `CLAUDE.md` does not exist**, run `client-intake` first. Say so and stop; do not try to plan an engagement for a client whose basic facts are unknown.

**If entity type, engagement type or year end are `TBC`**, say what is blocked and ask for them now. Without them there is no checklist to propose and no deadline to work back from.

**If a plan already exists** for this tax year, do not silently replace it. Show what is there, ask whether to revise or start fresh, and preserve any items the accountant added by hand.

## Step 1 · Propose, do not ask

**Never ask the accountant to produce the checklist from memory.** Present a filtered list and have them correct it. Verification is faster and more accurate than generation, and it surfaces the items they would have forgotten.

Build the proposed list from three sources, in this order:

1. **The jurisdiction pack's checklist** for this engagement type
2. **Practice checklist additions** from the practice config, items this practice has added for other clients
3. **Last year's plan**, if one exists in the client folder, including anything added then

Present it grouped by **who provides it**, not as one flat list. This matters: it stops the client being asked for things the accountant already holds or that come from someone else.

| Source | Typical items |
|---|---|
| **The client** | Statements, receipts, invoices, payroll records, anything only they have |
| **Their bookkeeper or accounting system** | Trial balance, management accounts, ledgers |
| **External auditor** | Audited financial statements, where an audit applies |
| **Already on file** | Prior year return, engagement letter, standing registration details |
| **Third parties** | Bank confirmations, statements from institutions |

Show it as a table with an **Applies?** column defaulted to yes, and ask them to work through it.

## Step 2 · Interview to refine

Keep this fast. They are correcting a draft, not filling a form.

1. **"Anything on here that doesn't apply to this client?"** Strike-outs first, they are the quickest win and shorten everything downstream.
2. **"Anything missing?"** Capture additions verbatim, in their words. These matter, see Step 6.
3. **"Anything you already have from last year or from another engagement?"** Move those to `Already on file` so the client is not asked for them.
4. **"Anything you expect to be difficult?"** Their standing notes may already say. This sets which items get an earlier internal target.
5. **"Who is actually providing the accounting records?"** Only where the client's `CLAUDE.md` does not already say. This determines whether the engagement waits on a bookkeeper.

Where a client's standing notes flag known problems, raise them rather than waiting to be told. "Last year the stock listing arrived three weeks late. Want an earlier target date on that one?"

## Step 3 · Build the schedule

Work **backwards** from the filing deadline in the jurisdiction pack, or from the date in the client's `CLAUDE.md` if one is recorded, which always wins.

| Milestone | Default | Notes |
|---|---|---|
| First request sent | Today | |
| Document cut-off | Practice default before filing deadline | The date after which an on-time filing stops being realistic |
| Audit complete | Before extraction | Only where an audit applies. Not the accountant's timeline to control |
| Working papers complete | 2 weeks before filing | |
| Review and approval | 1 week before filing | |
| **Filing deadline** | From jurisdiction pack | Immovable |
| Post-filing obligations | Per jurisdiction pack | Where the jurisdiction has one, for example a supporting-document upload with its own clock |

Adjust and confirm rather than presenting as fixed. A chronically late client needs an earlier cut-off; a simple return needs less working time.

**Say plainly if the schedule is already impossible.** If the filing deadline is eight weeks away and the cut-off would have been six weeks ago, do not quietly compress the milestones. Say the timeline is tight or gone, and let the accountant decide between an accelerated plan, an estimate, or an extension. That call is theirs.

## Step 4 · Validate

Echo the whole plan back before writing anything:

- **Scope:** which returns, which tax year
- **Checklist:** how many items, how many from the client
- **Key dates:** the schedule, with the filing deadline marked as computed-and-needs-confirming if it came from the pack rather than from `CLAUDE.md`
- **Dependencies:** audit, bookkeeper, or anything outside the accountant's control
- **Watch items:** anything flagged as historically difficult

Then ask one question: does this look right?

## Step 5 · Generate

Only after confirmation.

1. **Write `05-Engagement-Admin/engagement-plan.md`** in the client folder: scope, checklist grouped by source with a status column, the schedule, dependencies, and watch items. Date it and note the tax year.
2. **Draft the first document request**, in the practice's channel and tone. Ask only for items sourced from **the client**. Group them the way the client thinks, not the way the checklist is ordered. State the date they are needed by, which is the document cut-off, not the filing deadline.
3. **Save a copy of the request** to `01-Client-Communications` so the chase skill can see what was asked.
4. **Update the client's `CLAUDE.md`**: set status, record the key dates, and link to the plan.
5. **Offer the handoffs**, one line each, no pressure: the dates can go into the deadline calendar, and the request is ready to send.

## Step 6 · Capture what was added

This is how the master checklist improves rather than staying at whatever was written on day one.

When the accountant adds an item that is not in the jurisdiction pack:

- Record it in the plan as usual
- Note it at the end of the session, briefly: "You added *[item]*. Not in the standard checklist for this engagement type."
- **If the same item has now been added for more than one client**, say so and offer to add it to the practice checklist additions in the practice config, so it is proposed automatically next time.

Do not nag about this. One line at the end of a session, only when there is something worth promoting. The point is that the list gets better on its own, not that the accountant does list maintenance.

## Rules

- **Propose, never interrogate.** The accountant corrects a draft. They do not build a list from scratch.
- **Never ask the client for something the accountant already has.** That is what the source grouping is for.
- **Never state a deadline as settled fact.** Mark anything computed from the jurisdiction pack as needing confirmation.
- **Never quietly compress an impossible schedule.** Say it is impossible.
- **No figures in the client request.** It asks for documents, not about their contents.
- **The plan is a draft until confirmed**, and the request is a draft until sent. Nothing goes out automatically.

## Revising an existing plan

Scope changes, deadlines move, and clients turn out to have a rental property nobody mentioned. When revising:

- Show what changes and what stays
- Preserve the status of items already received; do not reset the checklist
- If the filing deadline moved, recompute the whole schedule and say which milestones have now passed
- If items were added, draft a short supplementary request for only the new items rather than resending the whole list
