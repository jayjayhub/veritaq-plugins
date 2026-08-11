# User Guide

What using this actually looks like, with real examples.

Every example below is a realistic run, including the parts where things are flagged or refused. A demonstration where everything works perfectly is not a demonstration, it is an advertisement.

Two clients run through this guide:

- **Lim Trading Sdn Bhd** — year end 31 December 2025, Form C due 31 August 2026. Documents still incomplete, and the date is close.
- **Seri Maju Enterprise** — year end 30 June 2026, plenty of time.

---

## How to talk to it

Plain sentences. No commands, no menus, no skill names.

> *who hasn't sent me their documents?*

Not "run client-document-chase". Say what you want the way you would say it to a colleague, and the right thing runs.

**It asks when it does not know.** If something is ambiguous it will ask rather than guess. That is deliberate, and it is worth answering properly rather than shrugging it off, because a guessed year end becomes a wrong deadline.

---

## 1 · Monday morning: what needs attention

The one to start the week with.

> **You:** who's at risk this month?

> **Claude:**
>
> Three clients need attention. Ordered by urgency.
>
> | Client | Due | Days left | Documents | Risk |
> |---|---|---|---|---|
> | Lim Trading Sdn Bhd | 31 Aug 2026 | 22 | 8 of 12 | **At risk** |
> | Hong Seng Motor | 31 Aug 2026 | 22 | Complete | Tight |
> | Seri Maju Enterprise | 28 Feb 2027 | 203 | 2 of 11 | On track |
>
> **Lim Trading is the one to deal with today.** Your document cut-off for them was 20 July, three weeks ago, and four items are still outstanding including the bank statements and the stock listing. The stock listing was also three weeks late last year.
>
> Hong Seng has everything in. The work just needs doing.

Note what it did: it did not just rank by date. It read the folders to see what had actually arrived, checked the cut-off you set, and pulled a standing note from last year.

---

## 2 · A new client

Make a folder named after the client first. Then:

> **You:** run client intake

> **Claude:** Setting up Seri Maju Enterprise. First, the basics.
>
> What kind of entity is it, and what are you handling for them?

> **You:** sdn bhd, form C and their form E

> **Claude:** Right. What is their financial year end?

> **You:** 30 June

> **Claude:** Got it. Now, who is your contact there, and do they reply on WhatsApp or email?

> **You:** Puan Aminah, the finance manager. WhatsApp, always.

> **Claude:** And how are they at sending documents in? Reliably on time, needs a couple of reminders, or chase from day one?

> **You:** she's good actually. usually first ask.

> **Claude:** Anything else worth knowing about them?

> **You:** they only close their accounts properly in September, so nothing useful before then

Then, before writing anything:

> **Claude:** Here is what I have for **Seri Maju Enterprise**, year end 30 June 2026.
>
> **Deadlines, computed. Please check these.**
> - Form C: **28 February 2027** electronically, 30 January manual
> - Form E: 31 March 2027
> - CP204: 30 days before the basis period begins
> - MITRS pack: within 30 days of the filing deadline
> - Your document cut-off: **17 January 2027**
>
> Given they do not close their accounts until September, I would not start chasing before then. Want me to set the cut-off later, or leave it?
>
> Nothing is saved yet. Does this look right?

> **You:** looks right, go ahead

> **Claude:** Done. Created the five folders and written their details down.
>
> One thing outstanding: I have not recorded a turnover band, so I cannot work out their MyInvois phase. Not urgent, but worth adding when you know it.
>
> Want their deadlines in your calendar, or shall I draft the first document request?

**Why this works better than a form:** you checked four dates rather than typing fifteen fields. Checking is faster and catches more.

---

## 3 · Planning the engagement

> **You:** plan this engagement

> **Claude:** Here is the proposed checklist for a Form C engagement, grouped by who provides each item. Strike out what does not apply and tell me what is missing.
>
> **From the client**
> | Item | Applies? |
> |---|---|
> | Bank statements, all accounts, full year | Yes |
> | Fixed asset additions and disposals with invoices | Yes |
> | Loan and hire purchase statements | Yes |
> | Debtors and creditors listing | Yes |
> | Stock listing at year end | Yes |
> | Directors' fees resolution | Yes |
>
> **From their bookkeeper**
> | Management accounts or trial balance | Yes |
>
> **From the auditor**
> | Audited financial statements | Yes |
>
> **Already on file**
> | Prior year return, engagement letter | Held |

> **You:** no hire purchase. and I need their EPF and SOCSO records too since we're doing Form E

> **Claude:** Removed hire purchase. Added EPF, SOCSO and EIS contribution records, plus the payroll summary by employee, under "from the client" for the Form E work.
>
> Note: EPF and SOCSO records are not in the standard Form C checklist. That is correct here because you are also handling Form E. If this combination comes up for another client, tell me and I will add it to your standard list.
>
> **Schedule, working back from 28 February 2027:**
>
> | | |
> |---|---|
> | Request sent | today |
> | Documents needed by | 17 January 2027 |
> | Audit complete | early January |
> | Working papers done | 14 February |
> | Your review | 21 February |
> | **Filing** | **28 February 2027** |
> | MITRS pack | within 30 days after |
>
> Shall I draft the request?

Then it writes the request, asking only for what the client themselves has, and saves a copy so the chase skill knows what was asked.

---

## 4 · Chasing

> **You:** draft a follow-up for Lim Trading

> **Claude:** This would be your **second follow-up**. You first asked on 12 June, then again on 8 July. Your cut-off was 20 July.
>
> Four items still outstanding:
>
> | Item | Status | Days since first asked |
> |---|---|---|
> | Bank statements, Maybank current a/c | Not received | 58 |
> | Stock listing at 31 Dec | Not received | 58 |
> | Directors' fees resolution | Not received | 58 |
> | Fixed asset invoices | Received, incomplete | 58 |
>
> 8 of 12 items complete.
>
> **WhatsApp version**
>
> > Hi Encik Lim, hope you're well. Still waiting on four things for the YA2025 filing:
> >
> > 1. Maybank current account statements, full year
> > 2. Stock listing as at 31 Dec
> > 3. Directors' fees resolution
> > 4. The remaining fixed asset invoices
> >
> > The return is due 31 August and I need these to get it done properly. Could you send them across this week?
> >
> > Thanks.
>
> **Email version**
>
> > Subject: Outstanding documents, YA2025 filing, due 31 August
> >
> > Dear Encik Lim,
> >
> > I am still missing the following for your YA2025 corporate return:
> >
> > - Maybank current account statements for the full financial year
> > - Stock listing as at 31 December 2025
> > - Directors' fees resolution
> > - Remaining fixed asset invoices
> >
> > The filing deadline is 31 August 2026. To complete the computation and review it properly, I need these by 15 August.
> >
> > If anything is difficult to locate, let me know and we can work around it.
> >
> > Kind regards,
>
> **Next action:** if nothing arrives by 15 August, the realistic options become a late filing or an estimate. Worth flagging to him now rather than at the end of the month. Do you want a firmer version?

Note what it will not do: it does not quote a penalty figure, and it does not mention a single number from the documents it does have.

---

## 5 · Getting figures out of documents

Save what arrived into the client's `02-Source-Documents` folder first. Then:

> **You:** extract the bank statements for Lim Trading

> **Claude:** Done. Written to `03-Workpapers/Lim-Trading-bank-extract-2026-08-09.xlsx`.
>
> **Reconciliation: 11 of 12 months balance.**
>
> | Month | Opening + movements = closing |
> |---|---|
> | Jan to Oct | Reconciles |
> | **November** | **Out by RM 1,240.00** |
> | December | Reconciles |
>
> The November difference is a single transaction on page 3 that I read as `1,240.00` but could equally be `1,340.00`. The print is faint. **I have not guessed.** It is flagged in the `Exceptions` sheet, and the figure is marked unverified.
>
> **347 transactions extracted.** 14 flagged for you:
> - 1 ambiguous figure, the one above
> - 9 transactions dated outside the basis period, probably an extra month at each end
> - 3 suspected duplicates, same amount, date and payee appearing in two files
> - 1 unusually large round-figure payment worth a second look
>
> **One file I could not read:** `IMG_2041.jpg`, a photograph of a statement page taken at an angle with part of the right column cut off. I need a clearer scan of that page.
>
> **Against your engagement plan:** you now have 11 of 12 months. March is still missing entirely.
>
> The workpaper is marked **UNVERIFIED** until you have checked the flagged items. Reviewing 14 rows should take a few minutes. Start with the November figure.

That is what a good run looks like: most of the work done, the failures named rather than hidden, and a review job measured in minutes rather than hours.

**It will never adjust a figure to make a total balance.** A forced reconciliation hides the error instead of finding it.

---

## 6 · The deadline calendar

> **You:** update my deadline calendar

> **Claude:** Here is what I would change. Nothing is written until you say so.
>
> **Add, 6 events**
> | Event | Date |
> |---|---|
> | Seri Maju · Form C due | 28 Feb 2027 |
> | Seri Maju · Documents needed by | 17 Jan 2027 |
> | Seri Maju · Form E due | 31 Mar 2027 |
> | Seri Maju · MITRS pack | 30 Mar 2027 |
> | Seri Maju · CP204 | 1 Jun 2026 |
> | Seri Maju · Chase documents, weekly from Sep | recurring |
>
> **Update, 1 event**
> | Hong Seng · Documents needed by | 15 Jul → 22 Jul, you moved their cut-off |
>
> **Remove, 2 events**
> | Tan Ah Kow · chase reminders | filed on 2 Aug, no longer needed |
>
> **Unchanged:** 23 events.
>
> Two clients could not be included: **Wong Brothers** and **KL Precision** have no financial year end recorded. Five minutes each in client intake and they will appear.
>
> Go ahead?

Run it again straight afterwards and it will report no changes. It reconciles rather than re-creating, so it will never duplicate an event, and it will never touch an event you made yourself.

---

## Common situations

**A client has gone completely silent.**
Ask for a final notice. It writes a short, formal, record-creating email and suggests who else should be copied. It will also say plainly when the question has stopped being about documents and started being about the engagement.

**The deadline is not achievable any more.**
It says so rather than quietly compressing the schedule. *"Your cut-off was three weeks ago. Filing on time is no longer realistic unless the remaining items arrive this week."* Whether you accelerate, file an estimate, or accept a late filing is your call, and it will not make it for you.

**The checklist is missing something you always need.**
Tell it. It adds it for this client immediately. If the same item comes up for a second client, it offers to add it to your standard list, and after that it is proposed automatically. The checklists improve because you used them.

**A figure looks wrong to you.**
Say so. It shows you the source file and the exact page or line the figure came from, so you can check it in seconds rather than hunting.

**A client's year end changes.**
Tell it, then re-run the calendar. Every affected date is recomputed and it shows you what moved before writing anything.

**You want to know why it did something.**
Ask. Every fact it states about a client should come with the file it came from. If it ever tells you something without saying where it came from, push back.

---

## Getting better results

**Fill in the client's details properly once.** Everything downstream depends on it. A missing year end means no deadlines, no calendar entry, and no schedule.

**Say when something is wrong.** Corrections stick. A note that a client always sends photographs instead of PDFs changes how the extraction is handled next year.

**Save attachments as they arrive**, into `02-Source-Documents`. Ten seconds at the time, and everything else depends on it.

**Ask for the reasoning when a number matters.** "Where did that come from?" is always a fair question and always has an answer.

---

## When to push back on it

It is a capable assistant, not a colleague with a licence. Push back when:

- **It states a deadline as fact.** Deadlines shift and grace periods change. It should say a date is computed and ask you to confirm. If it sounds certain, check.
- **It offers an opinion on tax treatment.** It should raise the question, not answer it. If it tells you something is deductible, that is out of bounds; ask it to show you the basis and make the call yourself.
- **It gives you a figure without a source.** Every extracted number should be traceable to a file and a location.
- **A total reconciles too neatly after a correction.** Ask what changed. It should never adjust a figure to force a balance.

The output is a draft. Your name is on the filing.
