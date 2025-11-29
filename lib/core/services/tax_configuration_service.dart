import '../models/tax_config.dart';
import '../config/australia_tax_config.dart';

/// Service for managing tax configurations across different countries.
class TaxConfigurationService {
  static final TaxConfigurationService instance =
      TaxConfigurationService._init();

  TaxConfigurationService._init();

  /// Get all enabled country configurations.
  List<CountryConfig> getEnabledCountries() {
    final countries = <CountryConfig>[
      AustraliaTaxConfig.countryConfig,
    ];
    return countries.where((c) => c.isEnabled).toList();
  }

  /// Get country configuration by code.
  CountryConfig? getCountryConfig(String countryCode) {
    final countries = getEnabledCountries();
    try {
      return countries.firstWhere((c) => c.code == countryCode);
    } catch (e) {
      return null;
    }
  }

  /// Get all financial years for a country.
  List<FinancialYear> getFinancialYears(String countryCode) {
    switch (countryCode) {
      case 'AU':
        return AustraliaTaxConfig.financialYears;
      default:
        return [];
    }
  }

  /// Get the current financial year for a country.
  FinancialYear? getCurrentFinancialYear(String countryCode) {
    final years = getFinancialYears(countryCode);
    try {
      return years.firstWhere((fy) => fy.isCurrent);
    } catch (e) {
      // Fallback: find FY that contains current date
      final now = DateTime.now();
      try {
        return years.firstWhere((fy) => fy.containsDate(now));
      } catch (e) {
        return years.isNotEmpty ? years.last : null;
      }
    }
  }

  /// Get financial year by ID.
  FinancialYear? getFinancialYearById(String financialYearId) {
    // Search across all countries
    for (final countryConfig in getEnabledCountries()) {
      final years = getFinancialYears(countryConfig.code);
      try {
        return years.firstWhere((fy) => fy.id == financialYearId);
      } catch (e) {
        continue;
      }
    }
    return null;
  }

  /// Determine which financial year a date belongs to.
  FinancialYear? getFinancialYearForDate(String countryCode, DateTime date) {
    final years = getFinancialYears(countryCode);
    try {
      return years.firstWhere((fy) => fy.containsDate(date));
    } catch (e) {
      return null;
    }
  }

  /// Get tax brackets for a specific financial year.
  List<TaxBracket> getTaxBrackets(String financialYearId) {
    // Extract country code from financial year ID
    if (financialYearId.startsWith('AU_')) {
      return AustraliaTaxConfig.allTaxBrackets
          .where((b) => b.financialYearId == financialYearId)
          .toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    }
    return [];
  }

  /// Get tax bracket by ID.
  TaxBracket? getTaxBracketById(String taxBracketId) {
    // Search Australian brackets
    try {
      return AustraliaTaxConfig.allTaxBrackets.firstWhere(
        (b) => b.id == taxBracketId,
      );
    } catch (e) {
      return null;
    }
  }

  /// Get tax brackets for a country and financial year.
  List<TaxBracket> getTaxBracketsForCountry(
    String countryCode,
    String financialYearId,
  ) {
    return getTaxBrackets(financialYearId);
  }

  /// Calculate tax savings based on user's tax bracket.
  double calculateTaxSavings(double amount, String? taxBracketId) {
    if (taxBracketId == null || taxBracketId.isEmpty) {
      return 0.0;
    }
    final bracket = getTaxBracketById(taxBracketId);
    if (bracket == null) {
      return 0.0;
    }
    return amount * bracket.taxRate;
  }

  /// Calculate tax savings using legacy bracket names (for backward compatibility).
  double calculateTaxSavingsLegacy(
    double amount,
    String incomeBracket,
    String countryCode,
  ) {
    final currentFY = getCurrentFinancialYear(countryCode);
    if (currentFY == null) {
      return _legacyTaxRate(incomeBracket) * amount;
    }

    final brackets = getTaxBrackets(currentFY.id);
    if (brackets.isEmpty) {
      return _legacyTaxRate(incomeBracket) * amount;
    }

    // Map legacy brackets to new bracket indices
    final bracketIndex = _legacyBracketToIndex(incomeBracket, brackets.length);
    if (bracketIndex >= 0 && bracketIndex < brackets.length) {
      return amount * brackets[bracketIndex].taxRate;
    }

    return _legacyTaxRate(incomeBracket) * amount;
  }

  double _legacyTaxRate(String incomeBracket) {
    switch (incomeBracket) {
      case 'low':
        return 0.12;
      case 'medium':
        return 0.22;
      case 'high':
        return 0.24;
      default:
        return 0.20;
    }
  }

  int _legacyBracketToIndex(String incomeBracket, int totalBrackets) {
    switch (incomeBracket) {
      case 'low':
        return 1; // Second bracket (first non-zero rate typically)
      case 'medium':
        return 2; // Third bracket
      case 'high':
        return totalBrackets - 1; // Highest bracket
      default:
        return 1;
    }
  }

  /// Get tax rate for a bracket ID.
  double getTaxRate(String? taxBracketId) {
    if (taxBracketId == null || taxBracketId.isEmpty) {
      return 0.0;
    }
    final bracket = getTaxBracketById(taxBracketId);
    return bracket?.taxRate ?? 0.0;
  }

  /// Get calendar events for a financial year.
  List<TaxCalendarEvent> getCalendarEvents(
    String countryCode,
    String financialYearId,
  ) {
    switch (countryCode) {
      case 'AU':
        return AustraliaTaxConfig.getCalendarEvents(financialYearId);
      default:
        return [];
    }
  }
}
