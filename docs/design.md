# Design Document

*Last Updated: 2025-11-29*

## 1. Introduction
This document translates the product backlog into a technical and UX design for the Gamified Tax Deduction application. It covers foundational project structure and the core MVP features, exploring trade-offs and providing clear specifications for implementation.

---

## 2. Foundational Scaffolding & Hygiene (Epic 1)
**Backlog Link**: Epic 1: Foundational Scaffolding & Hygiene
**Goal**: Establish a clean, maintainable, and community-friendly repository to support our open-source vision.
**[Design → Execution]**

### 2.1. Project Structure
The repository will follow a standard, language-agnostic structure to ensure it is intuitive for new contributors.

```
gamify-tax-deduction/
├── .github/              # GitHub-specific files (Actions, issue templates)
│   └── workflows/
│       └── ci.yml        # Continuous Integration workflow
├── docs/                 # Project documentation (vision, backlog, design, etc.)
├── lib/                  # Flutter source code
│   ├── main.dart         # Application entry point
│   ├── features/         # Feature-based modules (e.g., UserProfile, ReceiptScanner)
│   ├── core/             # Shared business logic, utilities, data models
│   └── shared/           # Shared widgets and utilities
├── test/                 # Unit and widget tests
├── integration_test/     # Integration tests
├── android/              # Android-specific configuration
├── ios/                  # iOS-specific configuration
├── .gitignore            # Files and directories to ignore
├── pubspec.yaml          # Flutter dependencies and configuration
├── CONTRIBUTING.md       # Guidelines for contributors
├── LICENSE               # Project license (e.g., MIT)
└── README.md             # Project overview and setup instructions
```

### 2.2. Technology Stack Recommendation
- **Cross-Platform**: Flutter with Dart, using native camera and ML Kit plugins.
- **Testing**: Flutter's built-in testing framework with integration tests.
- **Rationale**: Flutter is chosen to provide a consistent user experience across platforms while maintaining access to native device capabilities through plugins. This approach reduces development complexity, accelerates feature delivery, and ensures consistent behavior for the core "scan and reward" loop across iOS and Android.

### 2.3. `.gitignore` Baseline
A comprehensive `.gitignore` will be created to ignore common OS, IDE, build, and dependency artifacts for Flutter development, including build folders, IDE configurations, and platform-specific generated files.

### 2.4. CI/CD Pipeline (GitHub Actions)
**Backlog Link**: Story 1.2: Setup CI/CD Pipeline
A `ci.yml` workflow will be established with the following steps:
1. **Trigger**: On push to `main` and on pull requests targeting `main`.
2. **Jobs**:
   - `lint`: Run Flutter's built-in linter (`flutter analyze`) to enforce code style.
   - `build_and_test`:
     - Check out the code.
     - Set up Flutter environment.
     - Run `flutter pub get` to install dependencies.
     - Execute `flutter test` for unit tests.
     - Run `flutter build` for both iOS and Android to ensure compilation succeeds.

---

## 3. MVP Architecture & Design (Epic 2)
**Backlog Link**: Epic 2: MVP - Core Habit Loop
**Goal**: Design the core features for the MVP, focusing on the local-first, privacy-centric habit loop.

### 3.1. High-Level Architecture
The application will use a local-first, 3-tier architecture. All data lives on the device and is processed there.

```
+--------------------------------+
|      Presentation Layer        |  (Flutter Widgets)
| (UI, Views, State Management)  |
+--------------------------------+
             |
+--------------------------------+
|      Business Logic Layer      |
| (OCR, Tax Calc, Gamification)  |
+--------------------------------+
             |
+--------------------------------+
|           Data Layer           |  (SQLite via sqflite, Local Storage)
|   (Database, File Storage)     |
+--------------------------------+
```

### 3.2. Data Models
The following data structures will be used for the MVP. They will be stored locally.

```dart
// Stored in a secure local key-value store (e.g., flutter_secure_storage)
class UserProfile {
  final String countryCode;      // 'AU' for Australia (MVP)
  final String incomeBracketId;  // Reference to TaxBracket.id
  final String financialYearId;  // Reference to FinancialYear.id
  final DateTime createdAt;
  final DateTime updatedAt;
  
  UserProfile({
    required this.countryCode,
    required this.incomeBracketId,
    required this.financialYearId,
    required this.createdAt,
    required this.updatedAt,
  });
}

// Stored in the local SQLite database
class Receipt {
  final String id;                    // UUID
  final DateTime createdAt;
  final DateTime updatedAt;           // For tracking edits
  final String imagePath;             // Path to the image file in local app storage
  final String? vendorName;
  final double totalAmount;
  final double potentialTaxSaving;
  final String? category;             // For Post-MVP
  final String? notes;                // User notes
  final String financialYearId;       // Which FY this receipt belongs to
  final bool isDeleted;               // Soft delete flag
  
  Receipt({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.imagePath,
    this.vendorName,
    required this.totalAmount,
    required this.potentialTaxSaving,
    this.category,
    this.notes,
    required this.financialYearId,
    this.isDeleted = false,
  });
}
```

### 3.2.1. Tax Configuration Data Models
**Backlog Link**: Epic 4: Data Ownership & Regional Configuration

The tax configuration system is designed to be extensible for multiple countries while providing accurate Australian tax information for the MVP.

```dart
// Country configuration - extensible for future markets
class CountryConfig {
  final String code;              // 'AU', 'NZ', 'US', 'UK', etc.
  final String name;              // 'Australia'
  final String currencyCode;      // 'AUD'
  final String currencySymbol;    // '$'
  final String dateFormat;        // 'dd/MM/yyyy'
  final int financialYearStartMonth;  // 7 for July (Australia)
  final int financialYearStartDay;    // 1
  final bool isEnabled;           // true for MVP (only Australia enabled)
  
  CountryConfig({
    required this.code,
    required this.name,
    required this.currencyCode,
    required this.currencySymbol,
    required this.dateFormat,
    required this.financialYearStartMonth,
    required this.financialYearStartDay,
    required this.isEnabled,
  });
}

// Financial year configuration
class FinancialYear {
  final String id;                // 'AU_2024_2025'
  final String countryCode;       // 'AU'
  final String displayName;       // 'FY 2024-2025'
  final DateTime startDate;       // July 1, 2024
  final DateTime endDate;         // June 30, 2025
  final bool isCurrent;           // true if current FY
  
  FinancialYear({
    required this.id,
    required this.countryCode,
    required this.displayName,
    required this.startDate,
    required this.endDate,
    required this.isCurrent,
  });
}

// Tax bracket configuration
class TaxBracket {
  final String id;                // 'AU_2024_2025_BRACKET_3'
  final String financialYearId;   // 'AU_2024_2025'
  final String displayName;       // '$45,001 - $120,000'
  final double minIncome;         // 45001
  final double maxIncome;         // 120000 (use double.infinity for top bracket)
  final double taxRate;           // 0.325 (32.5%)
  final int sortOrder;            // For UI ordering
  
  TaxBracket({
    required this.id,
    required this.financialYearId,
    required this.displayName,
    required this.minIncome,
    required this.maxIncome,
    required this.taxRate,
    required this.sortOrder,
  });
}

// Tax calendar events
class TaxCalendarEvent {
  final String id;
  final String countryCode;
  final String financialYearId;
  final String title;             // 'Financial Year End'
  final String description;       // 'Last day to claim deductions for FY 2024-2025'
  final DateTime date;
  final bool notificationEnabled;
  final int notificationDaysBefore;  // 7 days before
  
  TaxCalendarEvent({
    required this.id,
    required this.countryCode,
    required this.financialYearId,
    required this.title,
    required this.description,
    required this.date,
    required this.notificationEnabled,
    required this.notificationDaysBefore,
  });
}
```

### 3.2.2. Australian Tax Configuration (FY 2024-2025)
**Backlog Link**: Story 4.4: Australian Tax Bracket Configuration

Pre-configured tax brackets for Australian users:

```dart
// Australian Tax Brackets FY 2024-2025
final List<TaxBracket> australianTaxBrackets2024_2025 = [
  TaxBracket(
    id: 'AU_2024_2025_BRACKET_1',
    financialYearId: 'AU_2024_2025',
    displayName: '\$0 - \$18,200 (Tax-free)',
    minIncome: 0,
    maxIncome: 18200,
    taxRate: 0.0,
    sortOrder: 1,
  ),
  TaxBracket(
    id: 'AU_2024_2025_BRACKET_2',
    financialYearId: 'AU_2024_2025',
    displayName: '\$18,201 - \$45,000 (19%)',
    minIncome: 18201,
    maxIncome: 45000,
    taxRate: 0.19,
    sortOrder: 2,
  ),
  TaxBracket(
    id: 'AU_2024_2025_BRACKET_3',
    financialYearId: 'AU_2024_2025',
    displayName: '\$45,001 - \$120,000 (32.5%)',
    minIncome: 45001,
    maxIncome: 120000,
    taxRate: 0.325,
    sortOrder: 3,
  ),
  TaxBracket(
    id: 'AU_2024_2025_BRACKET_4',
    financialYearId: 'AU_2024_2025',
    displayName: '\$120,001 - \$180,000 (37%)',
    minIncome: 120001,
    maxIncome: 180000,
    taxRate: 0.37,
    sortOrder: 4,
  ),
  TaxBracket(
    id: 'AU_2024_2025_BRACKET_5',
    financialYearId: 'AU_2024_2025',
    displayName: '\$180,001+ (45%)',
    minIncome: 180001,
    maxIncome: double.infinity,
    taxRate: 0.45,
    sortOrder: 5,
  ),
];
```

### 3.3. Core Feature Design

#### 3.3.1. On-Device OCR (Story 2.2)
**[Design → QA]** *Risk: OCR accuracy is critical. QA should focus on testing with various receipt types (faded, crumpled, different currencies).*

- **Approach 1: Google ML Kit via Flutter Plugin (google_mlkit_text_recognition)**
  - **Pros**: Cross-platform consistency, OS-optimized, ultimate privacy, no cost.
  - **Cons**: Requires Flutter plugin integration.
- **Approach 2: Bundled Open-Source Model (e.g., TensorFlow Lite)**
  - **Pros**: More control over model accuracy.
  - **Cons**: Increases app size, requires model maintenance.

**Decision**: **Approach 1 (Google ML Kit via Flutter Plugin)** is selected for the MVP. It provides the best of both worlds - native performance with cross-platform consistency, aligns with our privacy-first vision, and is cost-effective.

#### 3.3.2. Local Storage (Data Layer)
- **Approach 1: High-Level ORMs (Hive / Isar)**
  - **Pros**: Powerful querying, Flutter-native.
  - **Cons**: Overkill for the MVP's simple data needs.
- **Approach 2: SQLite with sqflite Plugin**
  - **Pros**: Simple, robust, transparent, and easy for new contributors to understand.
  - **Cons**: Requires more boilerplate code for complex queries (not an issue for MVP).

**Decision**: **Approach 2 (SQLite with sqflite)** is selected. This provides a familiar SQL interface that most developers understand, with the `sqflite` plugin providing Flutter integration while maintaining simplicity and control.

### 3.4. UI/UX Flow
The user flow is designed to be as frictionless as possible to encourage habit formation.

1. **First Launch (Onboarding)**
   - `Screen 1`: Welcome screen explaining the app's value proposition (privacy, immediate feedback, data ownership).
   - `Screen 2`: Country selection (Australia is default and only option for MVP; other countries show "Coming Soon").
   - `Screen 3`: Financial year selection (current FY is default, e.g., FY 2024-2025: July 1, 2024 - June 30, 2025).
   - `Screen 4`: Income bracket selection from Australian tax brackets:
     - $0 - $18,200 (0% Tax-free threshold)
     - $18,201 - $45,000 (19%)
     - $45,001 - $120,000 (32.5%)
     - $120,001 - $180,000 (37%)
     - $180,001+ (45%)
   - A prominent disclaimer explains this is for local, anonymous estimation only and is not professional tax advice.

2. **Core Loop**
   - `Screen 5 (Dashboard)`: Displays a large, motivating number showing "Total Potential Savings" for the selected financial year. Shows tax calendar countdown (days until FY end). A primary call-to-action (CTA) button: `[Scan New Receipt]`.
   - `Action`: User taps `[Scan New Receipt]`.
   - `Screen 6 (Camera View)`: The camera opens. User takes a picture of a receipt.
   - `Screen 7 (Confirmation)`: The app shows the captured image and the OCR-extracted amount. The user can tap to correct the amount.
   - `Action`: User taps `[Confirm]`.
   - `Screen 8 (Reward)`: A rewarding, animated screen appears.
     - **Text**: "Nice! You've unlocked **$32.50** in potential tax savings at your 32.5% marginal rate."
     - **CTA**: `[Scan Another]` or `[Done]`.

This flow provides an immediate, positive feedback loop right after the user performs the desired action (scanning a receipt).

### 3.5. Educational Content Integration (Story 3.2)
**Backlog Link**: Story 3.2: Educational Tooltips
**[Design → QA]** *QA should validate that educational content enhances rather than interrupts the core flow.*

Educational content will be contextually integrated to enhance user understanding without disrupting the habit formation loop:

#### 3.5.1. Educational Tooltip System
- **Trigger Points**: 
  - After successful receipt scan (Screen 6 - Reward)
  - When user reviews receipt history on Dashboard
  - During expense categorization (Post-MVP)

- **Content Strategy**:
  - **Micro-Learning**: 1-2 sentence explanations maximum
  - **Contextual**: Triggered by specific expense types or amounts
  - **Progressive**: More advanced tips for experienced users

#### 3.5.2. Educational Content Examples
```
Business Meal Example:
"💡 Business meals are typically 50% deductible when discussing work with clients or colleagues."

Home Office Example:
"💡 Home office expenses can include a portion of your rent, utilities, and internet costs."

Equipment Purchase Example:
"💡 Business equipment over $2,500 may need to be depreciated over several years instead of deducted immediately."
```

#### 3.5.3. Educational UI Integration
- **Dashboard Integration**: Small "💡 Tip of the Day" card that rotates educational content
- **Receipt Detail View**: Tap-to-reveal "ℹ️" icon next to tax savings estimate
- **Settings Screen**: "Learn About Deductions" section with comprehensive guides

### 3.6. Gamification System Design (Story 2.4)
**Backlog Link**: Story 2.4: Basic Gamification - Progress Tracker
**Goal**: Drive sustained engagement through achievement psychology without manipulation.

#### 3.6.1. Achievement Framework
**Core Principle**: Celebrate positive financial habits, not just app usage.

**Achievement Categories**:
1. **Scanning Milestones**: "First Scan", "10 Receipts", "100 Receipts"
2. **Savings Milestones**: "$100 Tracked", "$500 Tracked", "$1000 Tracked"
3. **Consistency Rewards**: "3 Days in a Row", "Weekly Warrior", "Monthly Master"
4. **Learning Achievements**: "Tax Tip Explorer", "Deduction Detective"

#### 3.6.2. Progress Visualization
- **Primary Metric**: Annual potential tax savings (large, prominent number)
- **Secondary Metrics**: 
  - Monthly scanning streak
  - Number of receipts scanned this month
  - Progress toward next savings milestone

#### 3.6.3. Gamification UI Elements
```
Dashboard Gamification Section:
┌─────────────────────────────────────┐
│ 🎯 This Year's Progress             │
│                                     │
│ Total Potential Savings: $1,247     │
│ ████████░░ 83% to your $1,500 goal │
│                                     │
│ 🔥 7-day scanning streak            │
│ 📊 23 receipts this month           │
│                                     │
│ 🏆 Recent Achievement:              │
│ "Monthly Master" - 30 scans in Nov! │
└─────────────────────────────────────┘
```

#### 3.6.4. Achievement Notification System
- **Immediate Feedback**: Achievement popup after reaching milestone
- **Gentle Reminders**: Weekly summary of progress (not daily nagging)
- **Social Sharing**: Option to share milestones (respecting privacy - no dollar amounts)

### 3.7. Community Contribution Framework Design
**Backlog Link**: Story 1.3: Define Contribution Guidelines
**[Design → Execution]** *This section addresses the open-source community experience.*

#### 3.7.1. Contributor Onboarding Flow
The repository will be designed to welcome first-time contributors:

1. **README Experience**:
   - Clear "Quick Start" section for running the app locally
   - "Contributing" section linking to detailed guidelines
   - "Good First Issues" section highlighting beginner-friendly tasks

2. **CONTRIBUTING.md Structure**:
   - Development environment setup (iOS/Android)
   - Code style guidelines and automated linting
   - Testing requirements and how to run tests
   - Pull request process and review expectations
   - Community code of conduct

#### 3.7.2. Community Feature Integration
- **In-App Attribution**: "About" screen crediting community contributors
- **Development Mode**: Hidden developer options for contributors to test features
- **Feedback Channel**: Easy way for users to suggest features or report bugs

This flow provides an immediate, positive feedback loop right after the user performs the desired action (scanning a receipt).
**[Design → Execution]**
**[Design → QA]** *QA should validate that the flow is intuitive and that the "Reward" screen feels satisfying.*

### 3.8. Extensible Tax Configuration System
**Backlog Link**: Story 4.3: Country/Region Selection, Story 4.4: Australian Tax Bracket Configuration
**Vision Link**: Regional Focus & Extensibility
**[Design → Execution]**

#### 3.8.1. Architecture Overview
The tax configuration system is designed with a modular, extensible architecture that separates country-specific tax rules from the core application logic.

```
+----------------------------------+
|     Tax Configuration Service    |
|  (Loads config based on country) |
+----------------------------------+
              |
+----------------------------------+
|     Country Configuration        |
|  (AU, NZ, US, UK - extensible)   |
+----------------------------------+
              |
    +--------------------+
    |                    |
+--------+        +-------------+
| Tax    |        | Financial   |
| Brackets|       | Year Config |
+--------+        +-------------+
```

#### 3.8.2. Tax Configuration Service Design

```dart
// Service for managing tax configurations
class TaxConfigurationService {
  final CountryConfigRepository _countryRepo;
  final TaxBracketRepository _bracketRepo;
  final FinancialYearRepository _fyRepo;
  
  // Get all enabled countries (Australia only for MVP)
  Future<List<CountryConfig>> getEnabledCountries();
  
  // Get tax brackets for a specific country and financial year
  Future<List<TaxBracket>> getTaxBrackets(String countryCode, String financialYearId);
  
  // Get current financial year for a country
  Future<FinancialYear> getCurrentFinancialYear(String countryCode);
  
  // Get available financial years for a country
  Future<List<FinancialYear>> getAvailableFinancialYears(String countryCode);
  
  // Calculate potential tax savings using marginal rate
  double calculateTaxSavings(double amount, TaxBracket userBracket) {
    return amount * userBracket.taxRate;
  }
}
```

#### 3.8.3. Extensibility Strategy
To add support for a new country:
1. Add a new `CountryConfig` entry with country-specific settings
2. Add `FinancialYear` entries for supported tax years
3. Add `TaxBracket` entries for each income bracket
4. Add `TaxCalendarEvent` entries for key tax dates
5. No core application code changes required

**Future Country Support (Post-MVP)**:
- New Zealand: FY April 1 - March 31
- United States: FY January 1 - December 31
- United Kingdom: FY April 6 - April 5
- Canada: FY January 1 - December 31

### 3.9. Data Export Service Design
**Backlog Link**: Story 3.3: Data Export for Tax Time
**Vision Link**: Data Ownership Principles
**[Design → Execution]**

#### 3.9.1. Export Service Architecture

```dart
// Export service for generating CSV and PDF reports
abstract class DataExportService {
  Future<File> exportToCsv(List<Receipt> receipts, ExportOptions options);
  Future<File> exportToPdf(List<Receipt> receipts, ExportOptions options);
  Future<void> shareExport(File file);
}

class ExportOptions {
  final String financialYearId;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool includeImages;
  final String? customTitle;
  
  ExportOptions({
    required this.financialYearId,
    this.startDate,
    this.endDate,
    this.includeImages = false,
    this.customTitle,
  });
}
```

#### 3.9.2. CSV Export Format
```csv
Date,Vendor,Amount,Category,Potential Tax Saving,Notes
2024-07-15,Office Works,$150.00,Office Supplies,$48.75,Printer paper
2024-08-22,Telstra,$89.00,Internet,$28.93,Monthly internet
2024-09-10,Uber Eats,$45.50,Business Meals,$14.79,Client meeting lunch
```

**CSV Fields**:
- Date (yyyy-MM-dd format)
- Vendor name
- Amount (with currency symbol)
- Category
- Potential Tax Saving (calculated at marginal rate)
- Notes (user-entered)

#### 3.9.3. PDF Report Structure

```
┌─────────────────────────────────────────────────────────┐
│                    RECEIPT QUEST                         │
│              Tax Deduction Summary Report                │
├─────────────────────────────────────────────────────────┤
│ Financial Year: FY 2024-2025 (Jul 1, 2024 - Jun 30, 2025)│
│ Generated: November 29, 2025                             │
│ Income Bracket: $45,001 - $120,000 (32.5%)              │
├─────────────────────────────────────────────────────────┤
│                       SUMMARY                            │
│ Total Receipts: 47                                       │
│ Total Expenses: $3,245.50                                │
│ Potential Tax Savings: $1,054.79                         │
├─────────────────────────────────────────────────────────┤
│                   BY CATEGORY                            │
│ Office Supplies: $890.00 (Tax Saving: $289.25)          │
│ Business Meals: $456.50 (Tax Saving: $148.36)           │
│ Travel: $1,899.00 (Tax Saving: $617.18)                 │
├─────────────────────────────────────────────────────────┤
│                    RECEIPT DETAILS                       │
│ [Table with Date, Vendor, Amount, Category, Tax Saving] │
├─────────────────────────────────────────────────────────┤
│ DISCLAIMER: This report is for informational purposes   │
│ only and does not constitute professional tax advice.   │
│ Consult a registered tax agent for accurate tax filing. │
└─────────────────────────────────────────────────────────┘
```

#### 3.9.4. Export Flow
1. User navigates to Settings > Export Data
2. User selects export format (CSV or PDF)
3. User selects financial year or custom date range
4. App generates export file locally
5. System share sheet opens for user to save/share the file
6. Export history is logged locally (not the data, just the export event)

### 3.10. Receipt Update Functionality Design
**Backlog Link**: Story 4.1: Receipt Editing & Updates
**Vision Link**: Data Ownership Principles
**[Design → Execution]**

#### 3.10.1. Receipt Repository with Update Support

```dart
class ReceiptRepository {
  final Database _db;
  
  // Create
  Future<Receipt> createReceipt(Receipt receipt);
  
  // Read
  Future<Receipt?> getReceiptById(String id);
  Future<List<Receipt>> getReceiptsByFinancialYear(String financialYearId);
  Future<List<Receipt>> searchReceipts(String query);
  
  // Update - NEW for Story 4.1
  Future<Receipt> updateReceipt(Receipt receipt);
  Future<Receipt> updateReceiptAmount(String id, double newAmount);
  Future<Receipt> updateReceiptVendor(String id, String vendorName);
  Future<Receipt> updateReceiptCategory(String id, String category);
  Future<Receipt> updateReceiptNotes(String id, String notes);
  Future<Receipt> replaceReceiptImage(String id, String newImagePath);
  
  // Delete
  Future<void> softDeleteReceipt(String id);
  Future<void> hardDeleteReceipt(String id);
  Future<void> deleteAllReceipts();
  Future<void> deleteReceiptsByFinancialYear(String financialYearId);
}
```

#### 3.10.2. Receipt Edit Screen UI Flow
1. User taps on a receipt from the history list
2. Receipt detail screen opens showing:
   - Receipt image (tap to view full-screen or replace)
   - Editable fields: Amount, Vendor, Category, Notes, Date
   - Calculated tax saving (updates live as amount changes)
   - "Save Changes" and "Cancel" buttons
   - "Delete Receipt" button (with confirmation)
3. Changes are validated before saving
4. On save, `updatedAt` timestamp is set
5. User returns to receipt history with updated data

#### 3.10.3. Edit Validation Rules
- **Amount**: Must be positive number, max 2 decimal places
- **Vendor**: Optional, max 100 characters
- **Category**: Must be from predefined list or "Uncategorized"
- **Notes**: Optional, max 500 characters
- **Date**: Cannot be in the future, must be within a valid financial year

### 3.11. Tax Calendar System Design
**Backlog Link**: Story 4.5: Built-in Tax Calendar
**Vision Link**: Regional Focus & Extensibility
**[Design → QA]** *QA should validate notification timing and cross-timezone behavior.*

#### 3.11.1. Tax Calendar Service

```dart
class TaxCalendarService {
  final TaxCalendarRepository _repo;
  final NotificationService _notifications;
  
  // Get upcoming tax events for the user's country
  Future<List<TaxCalendarEvent>> getUpcomingEvents(String countryCode, int daysAhead);
  
  // Get days until financial year end
  int getDaysUntilFinancialYearEnd(FinancialYear fy);
  
  // Schedule notification for an event
  Future<void> scheduleEventNotification(TaxCalendarEvent event);
  
  // Cancel all tax calendar notifications
  Future<void> cancelAllNotifications();
}
```

#### 3.11.2. Australian Tax Calendar Events (FY 2024-2025)

| Event | Date | Notification |
|-------|------|--------------|
| Financial Year Start | July 1, 2024 | "New financial year started! Track your deductions." |
| Tax Return Opens | July 1, 2024 | "You can now lodge your tax return." |
| End of Q1 | September 30, 2024 | Optional quarterly reminder |
| End of Q2 | December 31, 2024 | Optional quarterly reminder |
| End of Q3 | March 31, 2025 | Optional quarterly reminder |
| Financial Year End | June 30, 2025 | "Last day for FY 2024-2025 deductions!" (7 days before) |
| Self-Lodgement Deadline | October 31, 2025 | "Tax return due in 2 weeks" (14 days before) |

#### 3.11.3. Dashboard Tax Calendar Widget

```
┌─────────────────────────────────────┐
│ 📅 Tax Calendar                     │
│                                     │
│ ⏰ 214 days until FY end (Jun 30)   │
│                                     │
│ Upcoming:                           │
│ • Dec 31 - End of Q2               │
│ • Jun 30 - Financial Year End      │
│                                     │
│ [View Full Calendar]               │
└─────────────────────────────────────┘
```

---

## 4. Design Completeness Review

### 4.1. Vision Alignment Verification
This design addresses all core vision requirements:

✅ **Habit Formation**: Core loop with immediate gratification (Section 3.4)
✅ **Privacy-First**: Local-only architecture with transparent data models (Section 3.1-3.2)  
✅ **Educational Impact**: Contextual learning system integrated (Section 3.5)
✅ **Community Building**: Contributor experience designed (Section 3.7)
✅ **Individual Focus**: UI optimized for primary persona "Freelance Sarah"
✅ **Open Source**: Community-friendly architecture and contribution framework
✅ **Data Ownership**: Full data export and deletion capabilities (Section 3.9, 3.10)
✅ **Regional Focus**: Australia-first with extensible architecture (Section 3.8)
✅ **Global Extensibility**: Modular tax configuration system for future countries (Section 3.8)

### 4.2. Product Backlog Coverage
All P0 and P1 user stories are fully specified:
- ✅ Story 1.1-1.3: Repository scaffolding detailed in Section 2
- ✅ Story 2.1-2.4: MVP core loop fully designed in Section 3
- ✅ Story 3.2: Educational tooltips system specified in Section 3.5
- ✅ Story 3.3: Data export (CSV/PDF) designed in Section 3.9
- ✅ Story 4.1: Receipt editing functionality designed in Section 3.10
- ✅ Story 4.2: Tax year configuration designed in Section 3.8
- ✅ Story 4.3: Country/region selection designed in Section 3.8
- ✅ Story 4.4: Australian tax bracket configuration designed in Section 3.2.2
- ✅ Story 4.5: Tax calendar system designed in Section 3.11
- ✅ Story 4.6: Data deletion and privacy controls designed in Section 3.10

### 4.3. Risk Mitigation
Key risks identified and addressed:
- **OCR Accuracy**: Native framework approach with user correction flow (Section 3.3.1)
- **User Engagement**: Multi-layered gamification without manipulation (Section 3.6)
- **Community Adoption**: Contributor onboarding experience designed (Section 3.7)
- **Tax Accuracy**: Transparent, configurable tax brackets with clear disclaimers (Section 3.2.2)
- **Data Portability**: Full export capabilities in standard formats (Section 3.9)
- **International Expansion**: Extensible architecture designed from the start (Section 3.8)

## 5. Handoff & Traceability
- This design document addresses **all P0 and P1 user stories** from the Product Backlog.
- **All vision requirements** are translated into specific technical implementations.
- **Data ownership principles** are implemented through export and deletion capabilities.
- **Australia-first approach** with extensible tax configuration for future markets.
- Key risks and testing areas have been flagged for the QA Agent with **[Design → QA]** tags.
- Repository scaffolding requirements are detailed for the Execution Agent with **[Design → Execution]** tags.
- The design is now **complete and ready** for implementation.

### 5.1. Cross-Document Traceability
| Vision Principle | Product Story | Design Section |
|------------------|---------------|----------------|
| Data Ownership | Story 3.3, 4.1, 4.6 | Section 3.9, 3.10 |
| Australia Focus | Story 4.2, 4.3, 4.4 | Section 3.8, 3.2.2 |
| Extensibility | Story 4.3 | Section 3.8 |
| Habit Formation | Story 2.1-2.4 | Section 3.4 |
| Privacy-First | Story 2.1, 4.6 | Section 3.1, 3.2 |
| Tax Calendar | Story 4.5 | Section 3.11 |

---

# System Design

## Architecture Overview
[High-level system architecture]

## Component Designs
[Detailed component specifications]

## Data Models
[Data structures and relationships]

## API Specifications
[API designs and contracts]

## Trade-off Decisions
[Design decisions and rationale]

## Non-functional Requirements
[Performance, security, scalability requirements]

---
*Created by Design Agent | Updated: 2025-11-29 | Links: [Vision](vision.md) → [Product Backlog](product_backlog.md) → [Execution Log](execution_log.md)*
