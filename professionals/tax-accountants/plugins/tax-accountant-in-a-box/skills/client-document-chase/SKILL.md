---
name: client-document-chase
description: Use this skill whenever the tax accountant needs to work out what documents are still missing from a client and chase them for it. Trigger on requests like "what's still outstanding for [client]", "chase [client] for their documents", "draft a follow-up for the missing items", "who hasn't sent me anything yet", "prepare the document request list for [client]", "second reminder for [client]", or whenever a partial list of what a client has already submitted is pasted in and they want to know what is left. Also trigger when a filing deadline is mentioned as approaching and they ask who is not ready. This is the skill for the whole missing-documents cycle: building the checklist, comparing against what has arrived, and writing the actual follow-up message.
---

# Client Document Chase

For most small tax practices, manually requesting client documents and following up on the ones that never arrive is the single most time-consuming part of the work. This skill does the first draft of that whole cycle so the tax accountant only has to review and send.

## Before starting

1. **Read the engagement plan** at `05-Engagement-Admin/engagement-plan.md` in the client folder. **This is the checklist.** It was agreed with the tax accountant in `client-engagement-plan` and it is the source of truth for what this client owes.
2. **Read the practice config** for chase cadence, primary channel and correspondence tone.
3. **Read the client's `CLAUDE.md`** for contact, chasing history and any client-specific overrides.

**If no engagement plan exists**, say so and offer to run `client-engagement-plan` first. Do not rebuild the checklist from the jurisdiction pack; that would create a second list which will drift from the agreed one. The only exception is an explicit ad-hoc request, for example "what would I normally need for a company return", where nothing is being chased and no client is involved.

**Only chase items sourced from the client.** The plan groups items by who provides them. Do not chase a client for audited accounts that are sitting with their auditor, or for something already on file.

## What you produce

Every run produces these three sections in this order. Do not skip one; if you lack the information, say what you need instead of guessing.

### 1. Outstanding Items

A table with these columns: **Item**, **Why needed**, **Status**, **Days since first requested**.

Status is one of: `Not received`, `Received - incomplete`, `Received - complete`, `Not applicable`.

Only list `Received - complete` items if a full picture was requested; otherwise show them as a one-line count at the bottom ("7 of 12 items complete") so the table stays focused on what is actually blocking the work.

Build this by comparing the contents of `02-Source-Documents` against the plan's checklist, and check `01-Client-Communications` for what has already been requested and when.

### 2. Draft Follow-Up Message

Write the message to send, matched to the escalation level and to the channel. If no channel is named, produce a version for each channel named in the practice config. Treat the practice's primary channel as a first-class output, not an afterthought.

- **Email version**: subject line, greeting, one-sentence reason for writing, a bulleted list of only the outstanding items, a clear deadline, sign-off.
- **Messaging version**, for whichever messaging channel the practice config names: no subject, noticeably shorter, plain sentences, the item list as a short numbered list. Keep it under about 120 words.

Match the correspondence tone set in the practice config. Where none is set, default to warm and direct with no corporate padding. Do not use emoji unless asked.

### 3. Suggested Next Action

One or two lines: when to follow up again, whether to escalate, and whether the filing deadline is now at risk. Flag deadline risk explicitly if the outstanding items would take more than a few days to work through once received.

## Escalation levels

Match the tone to how many times the client has already been asked. If unclear, ask which round this is before writing.

| Round | Tone | Deadline framing |
|---|---|---|
| First request | Friendly, informative. Explain briefly why each item is needed. | Give a comfortable target date. |
| First follow-up | Warm but more direct. Drop the explanations, just list what is missing. | Name the actual filing deadline. |
| Second follow-up | Direct. State plainly what happens if documents do not arrive. | State the internal cut-off after which an on-time filing cannot be guaranteed. |
| Final notice | Formal, email only, short. Record-creating in tone. | State the consequence: late filing, penalty exposure, or work paused. Recommend copying anyone else who should know. |

The interval between rounds comes from the chase cadence in the practice config, adjusted for what the client's `CLAUDE.md` says about their history.

**Never invent a penalty amount or a specific legal consequence.** Say "may expose you to late-filing penalties" rather than quoting a figure or citing a provision.

## Keeping the plan current

The engagement plan is the shared record, so update it as you go rather than tracking status only in conversation:

- When an item arrives, mark it received in the plan.
- When the accountant says an item no longer applies, strike it in the plan and note why.
- If they add an item mid-engagement, add it to the plan and mention that it is not in the standard checklist, so `client-engagement-plan` can pick it up as a candidate for the practice list later.

## Deadlines

Use the dates in the engagement plan, which were confirmed when the plan was built. Failing that, the client's `CLAUDE.md`.

Deadlines vary and change. If neither source has a date, say which one you are assuming from the jurisdiction pack and ask for confirmation rather than stating it as fact.

The date to give a client in a chaser is normally the **document cut-off**, not the filing deadline. The filing deadline is when the return is due; the cut-off is when the accountant needs the papers in order to make it. Quoting the filing deadline invites the client to send everything the day before.

## Confidentiality guardrail

This skill handles client material under the professional body and data protection obligations named in the jurisdiction pack.

- You need only the client's **name or reference** and the **list of document types**. You do not need account numbers, national identity numbers, income figures, or the contents of any document.
- If material containing those values is pasted in, do not repeat them in your output. Note that the material contains them and carry on with the checklist.
- **Never include a client's financial figures in a draft follow-up message.** The message is about what is missing, not about what is in the documents.

## Judgement calls to raise rather than make

Ask, do not decide silently, when:

- The escalation round is unclear.
- A checklist item may not apply to this client, for example a dormant company or an individual with no rental income.
- The filing deadline is close enough that the realistic recommendation is to file an estimate or request an extension. Flag it; the call belongs to the tax accountant.
- A client has gone unresponsive across multiple rounds and the practical question is now about the engagement itself, not the documents.
