import '../models/tax_config.dart';

/// Pre-configured Australian tax configuration.
class AustraliaTaxConfig {
  static const String countryCode = 'AU';

  /// Australian country configuration.
  static const CountryConfig countryConfig = CountryConfig(
    code: 'AU',
    name: 'Australia',
    currencyCode: 'AUD',
    currencySymbol: '\$',
    dateFormat: 'dd/MM/yyyy',
    financialYearStartMonth: 7, // July
    financialYearStartDay: 1,
    isEnabled: true,
  );

  /// Australian financial years.
  static final List<FinancialYear> financialYears = [
    FinancialYear(
      id: 'AU_FY_2023_2024',
      countryCode: 'AU',
      displayName: 'FY 2023-2024',
      startDate: DateTime(2023, 7, 1),
      endDate: DateTime(2024, 6, 30, 23, 59, 59),
      isCurrent: false,
    ),
    FinancialYear(
      id: 'AU_FY_2024_2025',
      countryCode: 'AU',
      displayName: 'FY 2024-2025',
      startDate: DateTime(2024, 7, 1),
      endDate: DateTime(2025, 6, 30, 23, 59, 59),
      isCurrent: true,
    ),
    FinancialYear(
      id: 'AU_FY_2025_2026',
      countryCode: 'AU',
      displayName: 'FY 2025-2026',
      startDate: DateTime(2025, 7, 1),
      endDate: DateTime(2026, 6, 30, 23, 59, 59),
      isCurrent: false,
    ),
  ];

  /// Australian tax brackets for FY 2024-2025.
  static const List<TaxBracket> taxBracketsFY2024_2025 = [
    TaxBracket(
      id: 'AU_FY_2024_2025_BRACKET_1',
      financialYearId: 'AU_FY_2024_2025',
      displayName: '\$0 - \$18,200',
      minIncome: 0,
      maxIncome: 18200,
      taxRate: 0.0,
      sortOrder: 1,
    ),
    TaxBracket(
      id: 'AU_FY_2024_2025_BRACKET_2',
      financialYearId: 'AU_FY_2024_2025',
      displayName: '\$18,201 - \$45,000',
      minIncome: 18201,
      maxIncome: 45000,
      taxRate: 0.19,
      sortOrder: 2,
    ),
    TaxBracket(
      id: 'AU_FY_2024_2025_BRACKET_3',
      financialYearId: 'AU_FY_2024_2025',
      displayName: '\$45,001 - \$120,000',
      minIncome: 45001,
      maxIncome: 120000,
      taxRate: 0.325,
      sortOrder: 3,
    ),
    TaxBracket(
      id: 'AU_FY_2024_2025_BRACKET_4',
      financialYearId: 'AU_FY_2024_2025',
      displayName: '\$120,001 - \$180,000',
      minIncome: 120001,
      maxIncome: 180000,
      taxRate: 0.37,
      sortOrder: 4,
    ),
    TaxBracket(
      id: 'AU_FY_2024_2025_BRACKET_5',
      financialYearId: 'AU_FY_2024_2025',
      displayName: '\$180,001+',
      minIncome: 180001,
      maxIncome: null,
      taxRate: 0.45,
      sortOrder: 5,
    ),
  ];

  /// All Australian tax brackets (for all financial years).
  static List<TaxBracket> get allTaxBrackets {
    return [...taxBracketsFY2024_2025];
  }

  /// Key Australian tax calendar events.
  static List<TaxCalendarEvent> getCalendarEvents(String financialYearId) {
    final fy = financialYears.firstWhere(
      (fy) => fy.id == financialYearId,
      orElse: () => financialYears.first,
    );

    return [
      TaxCalendarEvent(
        id: '${financialYearId}_FY_START',
        countryCode: 'AU',
        financialYearId: financialYearId,
        title: 'Financial Year Start',
        description: 'Start of ${fy.displayName}',
        date: fy.startDate,
        notificationEnabled: true,
        notificationDaysBefore: 7,
      ),
      TaxCalendarEvent(
        id: '${financialYearId}_FY_END',
        countryCode: 'AU',
        financialYearId: financialYearId,
        title: 'Financial Year End',
        description: 'End of ${fy.displayName}',
        date: fy.endDate,
        notificationEnabled: true,
        notificationDaysBefore: 14,
      ),
      TaxCalendarEvent(
        id: '${financialYearId}_SELF_LODGE_DEADLINE',
        countryCode: 'AU',
        financialYearId: financialYearId,
        title: 'Self-Lodgement Deadline',
        description:
            'Deadline for self-lodging your tax return for ${fy.displayName}',
        date: DateTime(fy.endDate.year, 10, 31), // October 31
        notificationEnabled: true,
        notificationDaysBefore: 30,
      ),
    ];
  }
}
