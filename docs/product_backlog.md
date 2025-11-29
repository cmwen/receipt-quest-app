# Product Backlog

## Product Epics
[High-level feature groups]

## Feature Definitions
[Detailed feature descriptions]

## User Stories
[User stories with acceptance criteria]

## Priority Matrix
[Feature prioritization]

## Dependencies & Blockers
[Dependencies and blocking issues]

---
# Product Backlog

*Last Updated: 2025-11-29*

## Introduction
This living document translates the project vision into a prioritized backlog of epics and user stories. It is designed to guide the development team, ensure alignment with strategic goals, and facilitate traceability from vision to execution.

---

## Epic 1: Foundational Scaffolding & Hygiene (P0)
**Vision Link**: Open Source + Privacy, Habit Formation
**Goal**: Establish a clean, maintainable, and community-friendly repository structure from day one. This is critical for building trust and enabling open-source contributions.
**[Product → Design]**

### User Stories
- **Story 1.1: Initialize Repository Structure**
  - **Priority**: P0 - Must Have
  - **Acceptance Criteria**:
    - [ ] A language-appropriate `.gitignore` is present (e.g., for Swift/Kotlin).
    - [ ] Core folders exist: `src/`, `tests/`, `docs/`.
    - [ ] `README.md` is updated with a project summary, quick start guide, and links to all `docs/` files.
    - [ ] A "hello world" smoke test runs successfully.
    - [ ] Entries created in `/docs/execution_log.md` and linked in `/docs/governance_traceability.md`.

- **Story 1.2: Setup CI/CD Pipeline**
  - **Priority**: P0 - Must Have
  - **Acceptance Criteria**:
    - [ ] A basic CI pipeline (e.g., GitHub Actions) is configured.
    - [ ] The pipeline runs on every push to `main` and for every PR.
    - [ ] The CI pipeline runs the smoke test.
    - [ ] A code linting step is included in the pipeline.

- **Story 1.3: Define Contribution Guidelines**
  - **Priority**: P1 - Should Have
  - **Acceptance Criteria**:
    - [ ] `CONTRIBUTING.md` file is created.
    - [ ] Guidelines include instructions for setting up the dev environment, running tests, and submitting a PR.
    - [ ] A simple code of conduct is included.

---

## Epic 2: MVP - Core Habit Loop (P0)
**Vision Link**: Habit Formation, Immediate Visual Feedback
**Goal**: Deliver the minimum viable product that allows "Freelance Sarah" to scan a receipt and see immediate, motivating feedback on her potential tax savings.
**[Product → Design]**

### User Stories
- **Story 2.1: User Profile Setup**
  - **Priority**: P0 - Must Have
  - **Description**: As a new user, I want to set up a basic profile so the app can provide personalized tax estimates based on Australian tax rates.
  - **Acceptance Criteria**:
    - [ ] User can select their country/region (Australia is the default and only option for MVP).
    - [ ] User can select the current financial year (e.g., FY 2024-2025: July 1, 2024 - June 30, 2025).
    - [ ] User can select their estimated annual income bracket from Australian tax brackets:
      - $0 - $18,200 (0% tax-free threshold)
      - $18,201 - $45,000 (19%)
      - $45,001 - $120,000 (32.5%)
      - $120,001 - $180,000 (37%)
      - $180,001+ (45%)
    - [ ] This data is stored securely on the local device only.
    - [ ] A clear disclaimer states this information is for estimation purposes only.
    - [ ] User can update their profile settings at any time.

- **Story 2.2: Receipt Scanning & OCR**
  - **Priority**: P0 - Must Have
  - **Description**: As a user, I want to scan a receipt using my phone's camera so I can capture an expense.
  - **Acceptance Criteria**:
    - [ ] App can open the camera and capture an image.
    - [ ] On-device OCR extracts the total amount and vendor name from the receipt.
    - [ ] The user can manually correct the extracted amount if the OCR is inaccurate.
    - [ ] The scanned receipt image is saved locally.

- **Story 2.3: Immediate Tax Savings Calculation**
  - **Priority**: P0 - Must Have
  - **Description**: As a user, I want to see my potential tax savings immediately after scanning a receipt so I feel motivated.
  - **Acceptance Criteria**:
    - [ ] After a receipt amount is confirmed, the app displays a "Potential Tax Savings" estimate.
    - [ ] The calculation uses Australian tax brackets for FY 2024-2025:
      - $0 - $18,200: 0%
      - $18,201 - $45,000: 19%
      - $45,001 - $120,000: 32.5%
      - $120,001 - $180,000: 37%
      - $180,001+: 45%
    - [ ] The calculation is based on the user's selected income bracket from their profile.
    - [ ] A prominent disclaimer "Estimate Only - Not Professional Tax Advice" is displayed next to the amount.
    - [ ] The calculation logic is simple, documented, and auditable in the open-source code.
    - [ ] The tax configuration system is designed to be extensible for future country support.

- **Story 2.4: Basic Gamification - Progress Tracker**
  - **Priority**: P1 - Should Have
  - **Description**: As a user, I want to see a running total of my potential tax savings so I can track my progress.
  - **Acceptance Criteria**:
    - [ ] A dashboard screen displays the cumulative potential tax savings for the year.
    - [ ] The dashboard shows a list of recently scanned receipts.
    - [ ] The app celebrates a new milestone (e.g., "You've passed $100 in potential savings!").

---

## Epic 3: Post-MVP - Enhancing the Core (P2)
**Vision Link**: Educational Impact, Community Building
**Goal**: Improve the core experience with better categorization, educational content, and features that prepare users for tax time.
**[Product → QA]**

### User Stories
- **Story 3.1: Expense Categorization**
  - **Priority**: P2 - Nice to Have
  - **Description**: As a user, I want to categorize my expenses (e.g., "Office Supplies," "Business Meals") so my records are organized.
  - **Acceptance Criteria**:
    - [ ] User can assign a category to each scanned receipt from a predefined list.
    - [ ] The app suggests a category based on the vendor name.

- **Story 3.2: Educational Tooltips**
  - **Priority**: P2 - Nice to Have
  - **Description**: As a user, I want to understand *why* an expense is deductible so I can learn more about taxes.
  - **Acceptance Criteria**:
    - [ ] When a user categorizes an expense, a small tooltip provides a simple explanation of the deduction rule (e.g., "Business meals are typically 50% deductible").

- **Story 3.3: Data Export for Tax Time**
  - **Priority**: P1 - Should Have
  - **Vision Link**: Data Ownership Principles
  - **Description**: As a user, I want to export a summary of my expenses so I can easily file my taxes or send it to my accountant.
  - **Acceptance Criteria**:
    - [ ] User can generate a CSV export of all expenses for a selected financial year.
    - [ ] User can generate a PDF report of all expenses for a selected financial year.
    - [ ] The CSV export includes: date, vendor, amount, category, potential tax saving.
    - [ ] The PDF report includes:
      - Summary section with total expenses and total potential tax savings.
      - Expenses grouped by category with subtotals.
      - Individual receipt details with date, vendor, amount, and category.
      - Financial year period clearly stated (e.g., "FY 2024-2025: July 1, 2024 - June 30, 2025").
      - Disclaimer that this is an estimate and not professional tax advice.
    - [ ] User can select the date range for export (default: current financial year).
    - [ ] Export files are saved to the device or can be shared via system share sheet.
    - [ ] User owns their exported data with no restrictions on usage.

---

## Epic 4: Data Ownership & Regional Configuration (P1)
**Vision Link**: Data Ownership Principles, Regional Focus & Extensibility
**Goal**: Empower users with full control over their data and provide accurate, region-specific tax information for Australian users while building an extensible foundation for future international expansion.
**[Product → Design]**

### User Stories

- **Story 4.1: Receipt Editing & Updates**
  - **Priority**: P1 - Should Have
  - **Vision Link**: Data Ownership Principles
  - **Description**: As a user, I want to edit my receipt records after capture so I can correct mistakes or add missing information.
  - **Acceptance Criteria**:
    - [ ] User can access any previously captured receipt from the receipt history.
    - [ ] User can edit the following fields: amount, vendor name, category, date, notes.
    - [ ] The potential tax savings is automatically recalculated when the amount is changed.
    - [ ] Changes are saved locally and the "last modified" timestamp is updated.
    - [ ] Original receipt image is preserved; user can optionally retake/replace the image.
    - [ ] User can delete a receipt entirely with confirmation dialog.
    - [ ] All edits are stored locally only (no cloud sync).

- **Story 4.2: Tax Year Configuration**
  - **Priority**: P1 - Should Have
  - **Vision Link**: Regional Focus & Extensibility
  - **Description**: As a user, I want to select my tax year so the app calculates savings for the correct financial period.
  - **Acceptance Criteria**:
    - [ ] User can view the current selected financial year on the dashboard.
    - [ ] User can select from available financial years (current and previous 2 years).
    - [ ] For Australia, financial year runs July 1 - June 30.
    - [ ] Dashboard displays receipts and savings filtered by the selected financial year.
    - [ ] Tax brackets are applied based on the selected financial year (brackets may change year to year).
    - [ ] User is reminded when the financial year changes (e.g., July 1 notification).

- **Story 4.3: Country/Region Selection**
  - **Priority**: P1 - Should Have
  - **Vision Link**: Regional Focus & Extensibility
  - **Description**: As a user, I want to select my country/region so the app uses the correct tax rates and financial year dates.
  - **Acceptance Criteria**:
    - [ ] User can select their country/region from a list during onboarding.
    - [ ] For MVP, only Australia is available (other countries display "Coming Soon").
    - [ ] Selecting a country automatically sets:
      - Financial year start/end dates
      - Currency symbol and format
      - Available tax brackets
      - Tax-related terminology
    - [ ] The system is designed to easily add new countries via configuration.
    - [ ] User can change their country/region in settings (with warning about data interpretation).

- **Story 4.4: Australian Tax Bracket Configuration**
  - **Priority**: P0 - Must Have
  - **Vision Link**: Regional Focus & Extensibility
  - **Description**: As an Australian user, I want to select my income bracket so the app calculates accurate potential tax savings.
  - **Acceptance Criteria**:
    - [ ] Australian tax brackets for FY 2024-2025 are pre-configured:
      - $0 - $18,200: 0% (Tax-free threshold)
      - $18,201 - $45,000: 19%
      - $45,001 - $120,000: 32.5%
      - $120,001 - $180,000: 37%
      - $180,001+: 45%
    - [ ] User can select their income bracket during onboarding.
    - [ ] User can update their income bracket at any time in settings.
    - [ ] Tax savings calculation uses the marginal tax rate for the user's bracket.
    - [ ] A tooltip explains "Your potential tax saving is calculated at your marginal tax rate of X%".
    - [ ] Tax bracket configuration is stored in an extensible format for future country support.

- **Story 4.5: Built-in Tax Calendar**
  - **Priority**: P2 - Nice to Have
  - **Vision Link**: Regional Focus & Extensibility
  - **Description**: As a user, I want to see important tax dates so I don't miss deadlines.
  - **Acceptance Criteria**:
    - [ ] Dashboard shows countdown to end of financial year (June 30 for Australia).
    - [ ] User can view a tax calendar with key dates:
      - Financial year start (July 1)
      - Financial year end (June 30)
      - Tax return lodgement deadline (October 31 for self-lodgers)
      - Tax agent deadline (varies)
    - [ ] Optional push notification reminders before key dates.
    - [ ] Tax calendar dates are configurable per country for future extensibility.

- **Story 4.6: Data Deletion & Privacy Controls**
  - **Priority**: P1 - Should Have
  - **Vision Link**: Data Ownership Principles
  - **Description**: As a user, I want to delete my data so I have full control over my information.
  - **Acceptance Criteria**:
    - [ ] User can delete individual receipts with confirmation.
    - [ ] User can delete all data for a specific financial year.
    - [ ] User can delete all app data (factory reset) with strong confirmation.
    - [ ] Data deletion is permanent and irreversible (clear warning shown).
    - [ ] No data is retained after deletion (local-only storage).
    - [ ] User can view a summary of stored data (receipt count, date range, storage size).

## Change Log
- **2025-11-29**: Added Epic 4 (Data Ownership & Regional Configuration) with user stories for receipt editing, tax year configuration, country/region selection, Australian tax brackets, tax calendar, and data deletion. Updated Stories 2.1, 2.3, and 3.3 with Australian tax bracket requirements and elevated data export priority.
- **2025-09-07**: Initial backlog created from the project vision. Prioritized foundational scaffolding and core MVP loop. Deferred advanced features like professional networking and complex tax calculations to post-MVP.
