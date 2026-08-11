---
name: practice-setup
description: Use this skill the first time the tax accountant uses this plugin, or whenever setup needs checking or repairing. Trigger on requests like "set up my practice", "get me started", "first time setup", "check my setup", "is everything connected", "what am I missing", "why isn't the calendar working", or whenever another skill in this plugin stops because the practice config or a connector is missing. Also trigger when they want to move to a different jurisdiction pack, or when nothing seems to be reading their practice settings.
---

# Practice Setup

Gets a tax practice from nothing to working. Copies the templates the accountant needs into their own folder, checks what is connected, and tells them plainly what is still missing.

Run this before any other skill in the plugin. Every other skill depends on a practice config existing.

## What setup produces

```
Tax Practice/                  ← the accountant's folder, they choose where
├── CLAUDE.md                  ← practice config, from templates/practice-CLAUDE.md
├── jurisdiction/
│   └── malaysia-tax.md        ← their editable copy of the jurisdiction pack
└── [client folders appear here as they onboard]
```

**The jurisdiction pack is copied, not referenced.** This is deliberate. The checklists in it are a best-knowledge starting point, and the accountant is expected to correct them as they use the plugin. A copy they own can be edited; a file inside the plugin cannot, and would be overwritten on the next plugin update. Their copy is the one that counts.

Say this when copying it, in one line, so they know the file is theirs to change.

## Step 1 · Find or create the practice folder

Ask where their practice folder is, or where they want it. Somewhere durable and local, for example `Documents\Tax Practice`.

If a `CLAUDE.md` already exists there, this is a re-run. Do not overwrite it. Read it, report what is set and what is still a placeholder, and go to Step 4.

## Step 2 · Copy the templates

1. Copy `templates/practice-CLAUDE.md` from the plugin to `CLAUDE.md` in the practice folder.
2. Copy the jurisdiction pack to `jurisdiction/` in the practice folder.
3. Set `Jurisdiction pack` in their config to point at their copy.

Do not copy the client folder template. `client-intake` creates client folders directly, so a template sitting in their practice root would only be clutter.

## Step 3 · Fill in the config by interview

Do not hand them a file to edit. Ask, then write it for them. Same principle as `client-intake`: they answer questions, you do the file work.

**Ask these:**

1. **Practice or firm name, and your name.**
2. **Which jurisdiction?** If the plugin ships only one pack and it matches, say so and move on rather than asking.
3. **Calendar.** Which system, and is there a separate calendar for tax deadlines yet? If not, tell them to create one now, called `Tax Deadlines`, and wait. This is quicker to do than to explain later.
4. **How far ahead do you need documents?** Offer the default already written in the config template and let them adjust it. Explain what the date is for in one line: it is when they need the papers in order to file on time, not when the return is due.
5. **How do you chase clients?** Which channel, and how often.
6. **Client names or codes in calendar titles?** Mention the tradeoff once: names are more readable, codes keep client identity off lock screens and out of screen shares.
7. **Do you file electronically or on paper?** This picks which deadline column applies.
8. **Do you use tax software?** If yes, name it, and note that capital allowance schedules and submission happen there.
9. **Preferred spreadsheet format.**

Write every answer into the config. Anything unanswered goes in as `TBC`, never as a bracketed placeholder.

## Step 4 · Connector preflight

**Connectors cannot be shipped inside a plugin.** They are an authorisation between the accountant's own account and a service, so each one is connected once by them, in Claude's settings. What this skill can do is check what is live and say exactly what is missing.

Check each and report as a table: connected, not connected, or not needed.

| Connector | Why it matters here | Check |
|---|---|---|
| Calendar | `client-deadline-calendar` cannot write anything without it | List the calendars and look for the deadline calendar named in the config |
| Email | Lets `client-document-chase` see whether a client ever replied | Attempt a trivial search |

For anything not connected, give the actual click path: Settings, then Connectors, find it, Connect, sign in. Not a general description.

**State the attachment limitation here, once, plainly.** Email connectors can see that an attachment arrived and what it is called. They cannot open it. Attachments are saved into the client's `02-Source-Documents` folder by the accountant. This is a connector limitation, not a setting, and it will not change. Better they hear it now than discover it in week two and assume the plugin is broken.

## Step 5 · Report and hand off

A short status, not a wall of text:

- Practice folder location
- Config: complete, or which fields are still `TBC` and what each one blocks
- Connectors: connected, and what is missing
- Jurisdiction pack: which one, and where their editable copy lives

Then one next step, not five: onboard the first client with `client-intake`. Suggest they do one, not their whole book, and check it looks right before repeating.

## Repairing a broken setup

When another skill fails because something is missing, this skill is how it gets fixed. Diagnose in this order, because each depends on the one before:

1. **Practice config missing or unreadable** — nothing works. Go to Step 1.
2. **Jurisdiction pack missing or not pointed at** — no checklists, no deadline rules.
3. **Calendar ID missing or wrong** — the calendar skill cannot write.
4. **Connector not authorised** — that skill's features are unavailable, but the rest still work.
5. **Client `CLAUDE.md` incomplete** — that is a `client-intake` problem, not a setup problem. Say so and point there.

Fix only what is broken. Do not re-run the whole interview to repair one field.

## Rules

- **Never write a bracketed placeholder into their config.** Real answer or `TBC`.
- **Never overwrite an existing practice config.** Read it, report, repair.
- **Never claim a connector is connected without checking.**
- **Do not ask about jurisdictions the plugin has no pack for.**
- **Keep it under ten minutes.** Setup that feels like work gets abandoned before any value is seen.
