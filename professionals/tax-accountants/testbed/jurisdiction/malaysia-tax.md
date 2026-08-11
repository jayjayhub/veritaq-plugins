# Jurisdiction Pack: Malaysia

Everything country-specific used by the Tax Accountant in a Box skills lives here. The skills themselves contain only workflow logic and read this file for the facts.

**To support another jurisdiction**, copy this file, replace its contents, and point `Jurisdiction pack` in the practice config at the new file. The skills do not need to change. Keep the section headings identical, since the skills refer to them by name.

**Currency:** MYR (RM) · **Tax authority:** Lembaga Hasil Dalam Negeri Malaysia (LHDN / IRBM) · **Tax year:** Year of Assessment (YA)

> Deadlines, thresholds and phase dates in this file change. Treat everything here as a starting assumption to confirm, never as settled law. Any date recorded in a client's own `CLAUDE.md` overrides this file. Verify against LHDN before relying on a date for a filing decision.

---

## Entity types

| Type | Description | Typical forms |
|---|---|---|
| Sdn Bhd | Private limited company | Form C, CP204, Form E if it has employees |
| Berhad | Public limited company | Form C, CP204, Form E |
| Sole proprietor | Individual trading in own name | Form B, Form E if it has employees |
| Partnership | Two or more partners | Form P (partnership return), partners file Form B |
| Individual, employment income only | Salaried | Form BE |
| Individual with business income | Any non-salary trade income | Form B |
| LLP | Limited liability partnership | Form PT |

---

## Filing deadlines

Working deadlines assume electronic filing. The manual date is earlier and is worth noting in correspondence.

| Form | Who | Manual | Electronic |
|---|---|---|---|
| Form E | Employers, annual return | 31 March | 31 March, confirm current grace |
| Form BE | Individual, employment income only | 30 April | 15 May |
| Form B | Individual with business income | 30 June | 15 July |
| Form P | Partnerships | 30 June | 15 July |
| Form C | Companies | 7 months after financial year end | 8 months, via one month e-Filing grace |
| CP204 | Company tax estimate | 30 days before the basis period begins. New companies within 3 months of incorporation | same |
| CP204A | Revised estimate | Revision windows in the 6th, 9th and 11th month of the basis period | same |
| MITRS | Supporting document upload | Within 30 days after the Form C filing deadline | same |
| CP58 | Incentive payments to agents and distributors | 31 March | same |

**Derivation notes**

- Form C: statutory rule is 7 months from the close of the accounting period. The 8th month is available through the e-Filing grace period. Use the electronic date as the working deadline.
- MITRS is a separate obligation with its own clock, counted from the filing deadline rather than the filing date. It is easy to forget after the return goes in.
- Individuals have no financial year end to ask about; the basis year is the calendar year.

---

## Document checklists

Starting checklists by engagement type. The accountant's own version always wins.

### Individual, employment income only (Form BE)

- EA form from each employer for the year
- Dividend vouchers
- Rental income statement and related expense receipts, if any
- Insurance premium statements, life, medical, education
- Approved medical expense receipts
- Lifestyle relief receipts, books, devices, internet, sports
- SSPN statement
- Zakat or approved donation receipts
- EPF annual statement
- Prior year return and any LHDN correspondence

### Individual with business income (Form B)

Everything in the Form BE list, plus:

- Business bank statements for the full basis period
- Sales and purchase listings or summary
- Business expense records
- Fixed asset additions and disposals with supporting invoices
- Closing stock figure
- CP500 instalment payment receipts

### Company (Form C)

- Management accounts or trial balance for the financial year
- Audited financial statements, once available, or unaudited plus directors' certificate if exempt
- Bank statements for all accounts, full financial year
- Fixed asset additions and disposals with invoices
- Loan and hire purchase statements
- Directors' fees and remuneration resolution
- Debtors and creditors listing
- Stock listing at year end
- CP204 and CP204A submissions and instalment payment records
- Related-party transaction details, if any

### Employer (Form E and EA)

- Full-year payroll summary by employee
- EPF, SOCSO and EIS contribution records
- List of new hires and resignations during the year, with dates
- Benefits-in-kind and perquisites detail
- Director remuneration detail

---

## Audit exemption

A private company may qualify for audit exemption by meeting at least two of three tests, in the current year and the two immediately preceding years. Thresholds phase in across 2025 to 2027; confirm the applicable year before relying on them.

- Annual turnover not exceeding RM2 million
- Total assets not exceeding RM2 million
- Not more than 20 employees

Exempt companies file unaudited financial statements together with a directors' certificate confirming eligibility. A dormant company still files Form C.

**Workflow consequence:** where an audit is required, the tax computation waits on the external auditor, and that timeline is outside the accountant's control. Treat it as a dependency, not a task.

---

## Tax computation

The computation reconciles accounting profit to chargeable income. The mechanical parts are automatable; the treatment decisions are not.

- Depreciation charged in the accounts is not deductible and is added back
- Tax relief for asset wear and tear is claimed instead as **capital allowances under Schedule 3, Income Tax Act 1967**
- Capital allowances are only given where claimed, on qualifying expenditure, for assets used in the business
- Whether an asset meets the definition of "plant" is a matter of case law, not arithmetic
- Land, most buildings other than those qualifying for Industrial Building Allowance, and assets not used for business purposes do not qualify

**This is the highest-risk area in the whole workflow.** Both the MIA and the major firms publish regularly on common capital allowance errors, which tells you experienced practitioners get this wrong. Any skill touching it must surface treatment questions to the tax accountant rather than resolving them.

---

## Filing mechanism

- Returns are filed through the **MyTax portal** at mytax.hasil.gov.my
- A licensed tax agent files using the **TAeF (Tax Agent e-Filing)** role
- **e-DTS C** is an API web service allowing tax agent firms to submit Form C data from their own taxation systems. It serves commercial tax software, not general-purpose tools
- **MITRS** submissions are made through MyTax using the director or tax agent role
- There is **no connector** for MyTax, MITRS or MyInvois. Filing is manual, permanently

Common commercial tax software in Malaysian practice includes **Superior** and **iBiZZtax**, both of which compute capital allowances, carry balances forward between years, and integrate with e-DTS C. Where the accountant uses one, the skills should feed it rather than duplicate it.

---

## e-Invoicing (MyInvois)

Phased mandate by annual turnover. Confirm current phase dates and relaxation periods before advising.

| Phase | Turnover band | Mandated from |
|---|---|---|
| 1 | Above RM100 million | August 2024 |
| 2 | RM25m to RM100m | January 2025 |
| 3 | RM5m to RM25m | July 2025 |
| 4 | RM1m to RM5m | January 2026 |
| Later phases | Below RM1m | Deferred; exemption threshold raised to RM1m from January 2026 |

Relaxation and penalty-free periods have been extended more than once. Treat any phase date as needing confirmation.

---

## Professional and regulatory context

**Professional body:** Malaysian Institute of Accountants (MIA). The MIA By-Laws on Professional Ethics, Conduct and Practice set out confidentiality as a fundamental principle: information acquired through a professional or business relationship must be respected and safeguarded.

**Data protection:** Personal Data Protection Act 2010 (PDPA). Client personal data passing through a third-party service engages the accountant's obligations as a data user.

**Tax agent licensing:** approval under Section 153(3) of the Income Tax Act 1967, administered by the Ministry of Finance.

**How skills should treat this:** describe the shape of the obligation, never assert a specific rule as settled. Whether a given tool or workflow is permitted is a question for the accountant's own compliance resource, the MIA, or their professional adviser. Skills should flag and defer, not advise.

---

## Vocabulary

Terms to use, so output sounds native to the practice rather than translated.

| Term | Meaning |
|---|---|
| YA | Year of Assessment |
| Basis period | The accounting period forming the basis for a YA |
| LHDN / IRBM | The tax authority |
| Sdn Bhd | Private limited company |
| EA form | Annual statement of employee remuneration |
| EPF / KWSP | Employees Provident Fund |
| SOCSO / PERKESO | Social Security Organisation |
| EIS | Employment Insurance System |
| SSPN | National Education Savings Scheme |
| Zakat | Islamic religious levy, creditable against tax |
| CP204 | Company tax estimate |
| CP500 | Instalment scheme for individuals with business income |
| MITRS | Malaysian Income Tax Reporting System |
| MBRS | Malaysian Business Reporting System, SSM filing |
| SSM | Companies Commission of Malaysia |
