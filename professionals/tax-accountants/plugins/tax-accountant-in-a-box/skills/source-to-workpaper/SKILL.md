---
name: source-to-workpaper
description: Use this skill whenever the tax accountant needs figures pulled out of client source documents and into a working spreadsheet. Trigger on requests like "extract the bank statements", "pull the figures out of these receipts", "get this into a spreadsheet", "summarise these invoices", "build the workpaper for [client]", "key in the payroll", "turn these PDFs into a schedule", "do the data entry for [client]", or whenever documents have arrived in a client folder and the next step is getting numbers out of them. Also trigger when they ask what is still unreadable or missing from what a client has sent.
---

# Source Documents to Workpaper

Reads what the client sent in `02-Source-Documents` and produces a structured spreadsheet in `03-Workpapers`.

This is the step that removes the most manual work, and it is also the one where a mistake becomes a filing error. Everything below is built around one idea: **make verification cheaper than re-entry.** If checking your output takes as long as typing the figures by hand, this skill has failed regardless of how accurate it was.

## The hard line

**You extract facts. You never assign tax treatment.**

Extract `Entertainment - client dinner, 450.00` exactly as the document says it. Do not mark it deductible, non-deductible, or partially allowable. Do not sort items into tax categories. Do not decide that something is capital rather than revenue.

That is the tax computation, it is the next step, and it belongs to the tax accountant. Crossing this line is the single worst thing this skill could do, because a treatment decision buried in a spreadsheet column looks like a fact and stops being questioned.

Grouping by the client's own descriptions or account codes is fine. Grouping by tax character is not.

## Before starting

1. **Read the practice config** for the preferred spreadsheet format and the jurisdiction pack.
2. **Read the engagement plan** at `05-Engagement-Admin/engagement-plan.md` for what documents should exist. Completeness is measured against the plan, not against what happens to be in the folder.
3. **Read the client's `CLAUDE.md`** for standing notes. "Sends bank statements as phone photos" changes what to expect and how much to trust it.

**Agree the scope before starting.** Ask what to extract: bank statements, purchase invoices, payroll, fixed asset additions, the trial balance, or everything. Extracting one document type well beats extracting five badly, and a focused run is far easier to check.

## Confidence tiers

Assign every extracted figure a confidence, and record it. This is what makes tiered verification possible.

| Tier | Source | Treatment |
|---|---|---|
| **High** | Native digital PDF, spreadsheet, CSV, structured export | Machine-readable text. Trust subject to control totals |
| **Medium** | Clean scan, good quality image | Read via OCR. Trust subject to control totals, spot-check |
| **Low** | Phone photograph, skewed or cropped scan, poor contrast, faint print | Every figure flagged for review regardless of whether totals reconcile |
| **Refuse** | Handwriting, illegible, partially cut off, ambiguous digits | Do not extract. Record in the source inventory as unreadable and say what is needed |

**Never upgrade a tier because a figure looks plausible.** A confidently misread number is worse than a blank.

## Control totals

This is the core of the design. A control total is a figure the document itself asserts, which your extraction must reproduce. When it reconciles, everything inside it is probably right, and the accountant can review lightly. When it does not, you have localised an error before anyone wasted time looking for it.

| Document | Control total |
|---|---|
| Bank statement | Opening balance plus movements equals closing balance |
| Purchase or sales invoice | Line items plus tax equals invoice total |
| Batch of invoices | Sum of invoice totals equals the accountant's expected batch total, where one was given |
| Payroll summary | Gross less deductions equals net; contribution totals agree to the statutory schedules |
| Trial balance | Debits equal credits |
| Fixed asset schedule | Opening cost plus additions less disposals equals closing cost |

**Always state the reconciliation result before anything else.** If a control total does not reconcile, say so at the top, give the difference, and point at the most likely rows. Do not bury it, and do not adjust a figure to force a reconciliation. A forced balance hides the error rather than fixing it.

## What to produce

A spreadsheet in `03-Workpapers`, in the format named in the practice config, with these sheets:

### `Control`
The first thing anyone sees. Extraction date, scope, and for each control total: expected, extracted, difference, and pass or fail. Plus counts of items extracted, items flagged, and documents unreadable.

At the top, in a cell that cannot be missed:

> **UNVERIFIED.** Figures extracted automatically and not yet checked against source. Do not use for the tax computation until reviewed.

That stays until the accountant confirms the review is done.

### One sheet per document type
Bank, Purchases, Sales, Payroll, Fixed Assets, or whatever the scope covered. Every row carries provenance columns:

| Column | Contents |
|---|---|
| Date | As shown on the document |
| Description | Verbatim from the source. Do not tidy, translate or reword |
| Amount | As shown, with sign preserved |
| Source file | Exact filename |
| Location | Page number, statement line, or cell reference |
| Confidence | High, medium or low |
| Checked | Left blank for the accountant |

### `Exceptions`
Everything needing human eyes, in one place, so review is a single pass rather than a hunt: all low-confidence figures, anything that failed a control total, suspected duplicates, dates outside the basis period, and unusually large or round amounts worth a second look.

### `Sources`
Every file in scope, and what happened to it: fully read, partly read, or unreadable, with the reason. **A file that could not be read must appear here.** Silent omission is the worst failure mode available, because nobody goes looking for a figure they do not know is missing.

## Checks to run

- **Completeness against the plan.** "Eleven of twelve months of bank statements are present. March is missing." Feed this back so it can be chased.
- **Period boundaries.** Flag anything dated outside the basis period. Clients routinely send an extra month at each end.
- **Duplicates.** Same amount, same date, same payee across files usually means the same receipt sent twice, or overlapping statement periods.
- **Sign errors.** A credit recorded as a debit. Where a document distinguishes them, preserve it exactly.
- **Decimal and thousands separators.** Formats vary between banks and between countries. Where a value is ambiguous, flag it rather than picking the likely reading.
- **Sequence gaps.** Missing invoice or cheque numbers in an otherwise continuous run.

## How to report back

Lead with what needs the accountant's attention, not with what went well.

1. **Reconciliation status.** Every control total, pass or fail, with differences.
2. **What needs review**, with a number. "Fourteen items flagged, out of 312 extracted."
3. **What could not be read**, and what is needed to fix it. Usually a better scan.
4. **What is missing** against the engagement plan.
5. **Where the file is.**

Then one line on what to do next. If everything reconciled and only a handful of items are flagged, say the review should take a few minutes and where to start. If a control total failed, say that first and do not describe the rest as ready.

## Never

- **Never guess a digit.** Flag it.
- **Never adjust a figure to make a total reconcile.**
- **Never silently skip a document.** It goes in `Sources` with a reason.
- **Never overwrite a workpaper the accountant has edited.** If one exists, write a new dated version and say what changed.
- **Never assign tax treatment**, and never sort into tax categories.
- **Never present output as ready.** It is unverified until the accountant says otherwise.
- **Never repeat national identity numbers or full account numbers** into the workpaper. Last four digits are enough to identify an account.

## After review

When the accountant confirms the review is complete, update the `Control` sheet: replace the unverified banner with the reviewed date, and record who reviewed it. That record matters if the engagement is ever queried.

If they correct a figure, note what was wrong and why in the `Control` sheet. Repeated errors of the same kind are worth knowing about: a bank whose format is consistently misread is a fixable problem, and a note in the client's `CLAUDE.md` will save the same mistake next year.
