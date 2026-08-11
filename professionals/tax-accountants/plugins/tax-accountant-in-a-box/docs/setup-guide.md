# Tax Accountant in a Box — Setup Guide

Written for a tax accountant, not an IT person. About twenty minutes from nothing to a working practice with one client onboarded.

You will not need to edit a settings file, write anything technical, or migrate your existing clients. You answer questions; Claude does the file work.

---

## Before you start

| You need | Notes |
|---|---|
| A Claude account | The one you already use in the browser is fine |
| A computer you keep your client work on | Windows or Mac. Your files stay on it |
| About 20 minutes | Uninterrupted is better than split up |
| One client to try it on | A real one. Pick a straightforward engagement, not your most complicated |

**Do not try to onboard your whole client list today.** One client, then decide whether this is worth repeating. Onboarding twenty clients before you know if you like it is the most common way this gets abandoned.

---

## Step 1 · Install Claude Desktop

Download from **claude.ai** and sign in with the account you already use. Your chats and subscription carry over. It looks nearly identical to the web version, so there is nothing to relearn.

**Why the desktop app and not the browser:** it can see files on your computer. That is what makes everything else possible.

---

## Step 2 · Install the plugin

You will be sent either a link to a marketplace or a file.

**If you were given a marketplace:** open Claude Desktop and run these two commands, replacing the names with the ones you were sent.

```
/plugin marketplace add <the marketplace you were given>
/plugin install tax-accountant-in-a-box
```

**If you were given a file:** follow the instructions that came with it.

If you see a message saying `Run /reload-plugins to activate`, run that too.

**To check it worked:** ask Claude *"what skills do you have for my tax practice?"* You should see six.

---

## Step 3 · Create your deadline calendar

Do this before the next step, it takes a minute.

In Google Calendar (or Outlook), create a **new, separate calendar** called `Tax Deadlines`.

**Why separate:** your client deadlines will go there and nowhere else. If it ever becomes noisy, you hide the whole thing with one checkbox instead of deleting things one by one. It also means your personal calendar stays untouched.

---

## Step 4 · Connect your email and calendar

In Claude Desktop: **Settings**, then **Connectors**.

Connect **Calendar** first, then your **email** (Gmail or Microsoft 365). Sign in and approve when asked.

These are your own accounts. Nobody else gets access, and you can disconnect either one at any time.

**One thing to know now rather than later:** Claude can see that a client emailed you an attachment, and what the file is called, but it cannot open it. You save attachments into the client's folder yourself. This is a limitation of how email connectors work, not a setting, and it will not change in a later version.

Neither connector sends email. Every message is a draft waiting for you.

---

## Step 5 · Set up your practice

In Claude Desktop, say:

> **set up my practice**

Claude will ask you where you want your practice folder, then walk you through a short interview: your practice name, your calendar, how far ahead you need documents from clients, how you prefer to chase them, and how you file.

It then creates everything and tells you what, if anything, is still missing.

**You will not be asked to edit any file.** If you are ever handed a file to fill in by hand, something has gone wrong; say so and it will be fixed.

At the end you will have:

```
Tax Practice/
├── CLAUDE.md          ← your settings, written for you
└── jurisdiction/
    └── malaysia-tax.md ← the tax rules and document checklists
```

That second file is **yours to correct**. The document checklists in it are a starting point built from research, not from your practice. When you find something missing or wrong, say so and it gets fixed. It improves as you use it.

---

## Step 6 · Add your first client

Make a folder inside your practice folder, named after the client. For example `Lim-Trading-YA2026`.

Then say:

> **run client intake**

Claude asks a few questions: what kind of entity, which forms you handle for them, their financial year end, who your contact is, and anything worth knowing about them.

Then it shows you the deadlines it worked out, so you can check them before anything is saved:

> *Form C due 31 August 2027 electronically. CP204 thirty days before the basis period starts. MITRS within 30 days of filing. Documents needed from them by mid-July. Does that look right?*

Once you confirm, it builds the folder structure and writes everything down.

**If you do not know an answer, say so.** It records it as "to be confirmed" and tells you what that blocks. It never guesses.

---

## Step 7 · Plan the engagement

> **plan this engagement**

Claude proposes the document checklist for this client, grouped by who provides each item: the client, their bookkeeper, their auditor, or things you already have on file.

**Your job is to correct it, not to build it.** Strike out what does not apply, add what is missing. Then it works out the schedule backwards from the filing deadline and drafts the first document request for you to send.

---

## Step 8 · Use it

Three things to try in your first fortnight.

> **who hasn't sent me their documents?**

> **draft a follow-up for Lim Trading**

> **update my deadline calendar**

Then, once documents start arriving and you have saved them into the client's `02-Source-Documents` folder:

> **extract the bank statements into a spreadsheet**

---

## What each skill does

You do not need to remember these names. Say what you want in your own words and the right one runs.

| Skill | Say something like |
|---|---|
| `practice-setup` | "set up my practice", "check my setup", "what's missing" |
| `client-intake` | "new client", "run client intake", "set up Lim Trading" |
| `client-engagement-plan` | "plan this engagement", "what do I need from this client" |
| `client-document-chase` | "who hasn't sent their documents", "draft a reminder" |
| `source-to-workpaper` | "extract these statements", "get this into a spreadsheet" |
| `client-deadline-calendar` | "who's due next month", "update my deadline calendar" |

---

## Your folders

Every client gets the same five, which is what lets Claude find things reliably.

| Folder | What goes in it |
|---|---|
| `01-Client-Communications` | Emails, exported chats, call notes, requests you sent |
| `02-Source-Documents` | What the client sent you. Raw, untouched |
| `03-Workpapers` | Your schedules and computations, work in progress |
| `04-Deliverables` | Finished only: the computation, the return, acknowledgements |
| `05-Engagement-Admin` | Engagement letter, fee notes, the engagement plan |

---

## If something is not working

Ask Claude **"check my setup"** first. It diagnoses in the right order and usually tells you exactly what is wrong.

| Symptom | Usually |
|---|---|
| Nothing seems to know about my practice | Claude Desktop is not pointed at your practice folder |
| A client is missing from my deadline calendar | That client's financial year end is not filled in |
| It asks me things it should already know | Its `CLAUDE.md` is incomplete. Re-run `client intake` for that client |
| The calendar is empty | The `Tax Deadlines` calendar is not connected, or its ID is not saved |
| It won't chase a client | No engagement plan exists yet. Run "plan this engagement" |
| It says a document is unreadable | It is. A clearer scan usually fixes it. It will not guess a figure |

---

## What it will not do

Worth knowing now rather than discovering in week two.

- **It cannot open email attachments.** It sees that a file arrived and what it is called. You save it into the client folder.
- **It cannot file for you.** There is no connection to MyTax or MITRS, and there will not be one. You submit.
- **It cannot read bad handwriting.** Clear scans and digital files work well. Photographs of crumpled receipts get flagged for you to check, not guessed at.
- **It cannot decide a tax treatment.** It drafts the computation and raises the questions. Every judgement stays yours. This is deliberate, not a limitation waiting to be fixed in a later version.

---

## Where your data lives

**On your computer.** Client folders sit on your machine. Nothing is uploaded anywhere as a matter of course.

**Connections are yours.** Email and calendar are connected by you, one at a time, and switched off whenever you like.

**Nothing sends itself.** Every email, filing and calendar entry waits for your approval.

**Figures never leave the folder.** Chasing messages ask for documents. They never mention what is in them.

Your confidentiality obligations under the MIA By-Laws and the PDPA remain yours. This is built so that staying inside them is the default rather than something you have to remember, but it is not a substitute for your own judgement or advice from your professional body.

---

## If you stop using it

Your files are exactly where you left them, in ordinary folders, readable without any of this. Nothing is locked in a format you cannot open.
