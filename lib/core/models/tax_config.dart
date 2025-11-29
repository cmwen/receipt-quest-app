/// Country configuration for tax calculations.
class CountryConfig {
  final String code;
  final String name;
  final String currencyCode;
  final String currencySymbol;
  final String dateFormat;
  final int financialYearStartMonth;
  final int financialYearStartDay;
  final bool isEnabled;

  const CountryConfig({
    required this.code,
    required this.name,
    required this.currencyCode,
    required this.currencySymbol,
    required this.dateFormat,
    required this.financialYearStartMonth,
    required this.financialYearStartDay,
    this.isEnabled = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'currencyCode': currencyCode,
      'currencySymbol': currencySymbol,
      'dateFormat': dateFormat,
      'financialYearStartMonth': financialYearStartMonth,
      'financialYearStartDay': financialYearStartDay,
      'isEnabled': isEnabled,
    };
  }

  factory CountryConfig.fromMap(Map<String, dynamic> map) {
    return CountryConfig(
      code: map['code'] as String,
      name: map['name'] as String,
      currencyCode: map['currencyCode'] as String,
      currencySymbol: map['currencySymbol'] as String,
      dateFormat: map['dateFormat'] as String,
      financialYearStartMonth: map['financialYearStartMonth'] as int,
      financialYearStartDay: map['financialYearStartDay'] as int,
      isEnabled: map['isEnabled'] as bool? ?? true,
    );
  }
}

/// Financial year definition.
class FinancialYear {
  final String id;
  final String countryCode;
  final String displayName;
  final DateTime startDate;
  final DateTime endDate;
  final bool isCurrent;

  const FinancialYear({
    required this.id,
    required this.countryCode,
    required this.displayName,
    required this.startDate,
    required this.endDate,
    this.isCurrent = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'countryCode': countryCode,
      'displayName': displayName,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
      'isCurrent': isCurrent,
    };
  }

  factory FinancialYear.fromMap(Map<String, dynamic> map) {
    return FinancialYear(
      id: map['id'] as String,
      countryCode: map['countryCode'] as String,
      displayName: map['displayName'] as String,
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate'] as int),
      endDate: DateTime.fromMillisecondsSinceEpoch(map['endDate'] as int),
      isCurrent: map['isCurrent'] as bool? ?? false,
    );
  }

  /// Check if a given date falls within this financial year.
  bool containsDate(DateTime date) {
    return !date.isBefore(startDate) && !date.isAfter(endDate);
  }
}

/// Tax bracket definition.
class TaxBracket {
  final String id;
  final String financialYearId;
  final String displayName;
  final double minIncome;
  final double? maxIncome;
  final double taxRate;
  final int sortOrder;

  const TaxBracket({
    required this.id,
    required this.financialYearId,
    required this.displayName,
    required this.minIncome,
    this.maxIncome,
    required this.taxRate,
    required this.sortOrder,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'financialYearId': financialYearId,
      'displayName': displayName,
      'minIncome': minIncome,
      'maxIncome': maxIncome,
      'taxRate': taxRate,
      'sortOrder': sortOrder,
    };
  }

  factory TaxBracket.fromMap(Map<String, dynamic> map) {
    return TaxBracket(
      id: map['id'] as String,
      financialYearId: map['financialYearId'] as String,
      displayName: map['displayName'] as String,
      minIncome: (map['minIncome'] as num).toDouble(),
      maxIncome:
          map['maxIncome'] != null ? (map['maxIncome'] as num).toDouble() : null,
      taxRate: (map['taxRate'] as num).toDouble(),
      sortOrder: map['sortOrder'] as int,
    );
  }
}

/// Tax calendar event for reminders and notifications.
class TaxCalendarEvent {
  final String id;
  final String countryCode;
  final String financialYearId;
  final String title;
  final String description;
  final DateTime date;
  final bool notificationEnabled;
  final int notificationDaysBefore;

  const TaxCalendarEvent({
    required this.id,
    required this.countryCode,
    required this.financialYearId,
    required this.title,
    required this.description,
    required this.date,
    this.notificationEnabled = true,
    this.notificationDaysBefore = 7,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'countryCode': countryCode,
      'financialYearId': financialYearId,
      'title': title,
      'description': description,
      'date': date.millisecondsSinceEpoch,
      'notificationEnabled': notificationEnabled,
      'notificationDaysBefore': notificationDaysBefore,
    };
  }

  factory TaxCalendarEvent.fromMap(Map<String, dynamic> map) {
    return TaxCalendarEvent(
      id: map['id'] as String,
      countryCode: map['countryCode'] as String,
      financialYearId: map['financialYearId'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      notificationEnabled: map['notificationEnabled'] as bool? ?? true,
      notificationDaysBefore: map['notificationDaysBefore'] as int? ?? 7,
    );
  }
}
