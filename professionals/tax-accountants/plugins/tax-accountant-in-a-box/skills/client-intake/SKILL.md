---
name: client-intake
description: Use this skill whenever the tax accountant is setting up a new client engagement and needs the client's CLAUDE.md created. Trigger on requests like "new client", "set up [client name]", "client intake", "onboard this client", "start a new engagement", "run intake for [client]", or whenever a new client folder has just been made and needs filling in. Also trigger when an existing client's details need re-confirming for a new tax year, or when the tax accountant says a client's CLAUDE.md is incomplete or out of date. This skill runs the intake interview, validates the answers, then creates the folder structure and writes CLAUDE.md.
---

# Client Intake

The tax accountant creates a folder named after the client. This skill does everything else: interviews them, checks the answers make sense, builds the `01-05` subfolders, and writes a fully populated `CLAUDE.md`.

They should never have to open a markdown file or copy a template. If they finish having typed only answers to questions, it worked.

## Before starting

1. **Read the practice config** (`CLAUDE.md` at the practice root) for the jurisdiction pack, defaults and preferences. Everything jurisdiction-specific in this skill comes from the pack it names.
2. **Read the jurisdiction pack** at the path named in the practice config, normally the accountant's own copy at `jurisdiction/` in the practice folder, for entity types, forms, deadline rules and document checklists. If no pack is configured, run `practice-setup` first.
3. **Confirm you are inside a client folder**, not the practice root. The folder name is the client name; use it, do not ask them to retype it.

If a `CLAUDE.md` already exists, do not overwrite it. Say what is already there, ask whether to update or start fresh, and if updating, **preserve the Standing notes verbatim**. Those are hand-written observations nobody wants to retype.

## How to run the interview

**Conversational, not a form.** Ask in rounds of two or three related questions, not everything at once and not one at a time. Use the vocabulary listed in the jurisdiction pack. Accept partial answers.

**Branch on entity type immediately.** Most questions below do not apply to most clients. An individual filing a simple employment-income return should never be asked about audit exemption, tax estimates or e-invoicing. Asking irrelevant questions is the fastest way to make this feel like the form it replaced.

**Let them stop early.** Round 1 alone produces a working client with correct deadlines. If they say "that's all I know for now" or start giving short answers, take the hint, record the rest as `TBC`, and generate. More can be added later by re-running this skill.

**Never guess a value.** `TBC` is a fine answer and an honest file. An invented year end is a filing risk.

---

### Round 1 · The three that matter

These drive every deadline. Get them first so that if the interview stops here, the calendar still works.

1. **Entity type.** Offer the options listed in the jurisdiction pack's entity table.
2. **What are you handling for them?** Suggest the likely forms from the entity type rather than asking cold. The pack maps entity types to typical forms.
3. **Financial year end.** Entities with a chosen year end only. Where the pack says a type always uses the calendar year, do not ask.

### Round 2 · Working with them

4. **Who is your contact, and what is their role?**
5. **Which channel, and who actually replies?** Ask it that way. The formal contact and the person who responds are often different, and the second one is the useful one. Offer the channels named in the practice config.
6. **How are they at sending things in?** Prompt with the shape of an answer: reliably on time, needs a couple of reminders, or chase them from day one. This sets the chase cadence and the document cut-off.

### Round 3 · Anything specific

7. **Anything I should know about this client?** Open question, asked plainly. This is where the genuinely useful things surface: sends bank statements as phone photos, the director's fee is not voted until the AGM, the stock listing was three weeks late last year.
8. **Anything confidential beyond the usual?** An NDA, a person who must not be copied, an active query or dispute with the tax authority. `None beyond standard` is a normal answer.

### Round 4 · Businesses and companies only

Skip this round entirely for an individual with employment income only.

9. **Audit, or exempt?** Where the jurisdiction has an audit exemption regime, use its tests as a prompt. Record `TBC` if they need to check rather than pressing for an answer.
10. **Turnover band, roughly?** A band is enough; do not ask for a figure. Used for e-invoicing phase and audit thresholds.
11. **E-invoicing status**, where the jurisdiction has a mandate. Not started, testing, or live.
12. **Do they use accounting software you can get exports from?** Affects how source documents arrive later.

### Round 5 · Dates, only if they want to override

13. **Document cut-off.** State the practice default from the config and ask whether it should differ for this client. A chronically late client might need considerably longer.

---

## Validation, before writing anything

Do not skip this. It is the step that catches errors while they are still cheap.

### 1. Echo the derived deadlines

Compute the deadline set from the answers using the jurisdiction pack, and show it back. This turns the whole interview from form-filling into verification, which is a much easier task and catches mistakes immediately.

Shape of the echo, using the Malaysia pack as the example. Use whatever forms and dates the loaded pack actually gives:

> Lim Trading Sdn Bhd, year end 31 December.
> Form C due 31 August 2027 electronically, 31 July manual.
> CP204 due 30 days before the basis period starts.
> MITRS pack due within 30 days of the filing deadline.
> Documents needed from them by mid-July.
> Does that look right?

State plainly that these are **computed and need confirmation**. Deadlines shift, grace periods change, and entity circumstances vary. The tax accountant's answer overrides the computation every time.

### 2. Check for contradictions

Raise anything inconsistent rather than writing it down and moving on:

- An entity type paired with a form that does not apply to it
- An employer return with no employees, or employees with no employer return
- Audit exemption claimed for an entity type it does not cover
- Turnover band inconsistent with the stated e-invoicing phase
- A year end that makes the filing deadline already past
- A tax year inconsistent with the year end

### 3. Report completeness

List anything recorded as `TBC` and say what it blocks. Be specific about consequences:

> Missing: financial year end. Until that is filled in, no filing, estimate or post-filing date can be calculated for this client, and they will not appear in your deadline calendar.

A missing field is a two-minute fix if they know it blocks something. Say what it blocks.

---

## Generating

Only after the validation summary has been confirmed:

1. **Create the subfolders**: `01-Client-Communications`, `02-Source-Documents`, `03-Workpapers`, `04-Deliverables`, `05-Engagement-Admin`. Put a one-line `.keep.md` in each saying what belongs there.
2. **Write `CLAUDE.md`** from the client folder template. Fill in every answer. Write `TBC` where unanswered, never a bracketed placeholder and never a guess.
3. **Say what was created**, in one short paragraph. Not a file listing.
4. **Offer the handoff**, one line, no pressure: the deadlines can go into the deadline calendar now, and the first document request can be drafted. Do not do either without being asked.

## Rules

- **Never write a bracketed placeholder into a generated file.** The whole point of this skill is that nobody edits placeholder text. Every field is either a real answer or `TBC`.
- **Never overwrite an existing `CLAUDE.md`** without asking, and always preserve Standing notes when updating.
- **Never invent a date, a turnover figure, or an entity detail.**
- **Do not ask questions the entity type has already ruled out.**
- **Keep the whole thing under about five minutes.** If it runs long, there are more clients to onboard than time to do it, and a long intake is one nobody repeats.

## Re-running for a new tax year

For an existing client at a new tax year, most answers carry forward. Read the existing `CLAUDE.md`, show what is on file, and ask only what plausibly changed: year end (rarely), engagement type (sometimes), audit position (often), turnover band and e-invoicing phase (annually). Confirm the rest in one pass rather than re-asking it.
