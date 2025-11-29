import '../services/tax_configuration_service.dart';

class UserProfile {
  final String incomeBracket;
  final String filingStatus;
  final String? taxBracketId;
  final String countryCode;
  final String? financialYearId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserProfile({
    required this.incomeBracket,
    required this.filingStatus,
    this.taxBracketId,
    this.countryCode = 'AU',
    this.financialYearId,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'incomeBracket': incomeBracket,
      'filingStatus': filingStatus,
      'taxBracketId': taxBracketId,
      'countryCode': countryCode,
      'financialYearId': financialYearId,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      incomeBracket: json['incomeBracket'] as String,
      filingStatus: json['filingStatus'] as String,
      taxBracketId: json['taxBracketId'] as String?,
      countryCode: json['countryCode'] as String? ?? 'AU',
      financialYearId: json['financialYearId'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['updatedAt'] as int)
          : null,
    );
  }

  /// Returns the user's marginal tax rate.
  ///
  /// This getter provides backward compatibility for existing code while
  /// using the TaxConfigurationService for new tax bracket configurations.
  /// For new code, prefer using TaxConfigurationService directly.
  double get taxRate {
    // Use new tax configuration service if taxBracketId is available
    if (taxBracketId != null && taxBracketId!.isNotEmpty) {
      final rate = TaxConfigurationService.instance.getTaxRate(taxBracketId);
      if (rate > 0) {
        return rate;
      }
    }

    // Fallback to legacy bracket-based calculation for backward compatibility
    switch (incomeBracket) {
      case 'low': // <$40k
        return 0.12;
      case 'medium': // $40k-$90k
        return 0.22;
      case 'high': // >$90k
        return 0.24;
      default:
        return 0.20;
    }
  }

  UserProfile copyWith({
    String? incomeBracket,
    String? filingStatus,
    String? taxBracketId,
    String? countryCode,
    String? financialYearId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      incomeBracket: incomeBracket ?? this.incomeBracket,
      filingStatus: filingStatus ?? this.filingStatus,
      taxBracketId: taxBracketId ?? this.taxBracketId,
      countryCode: countryCode ?? this.countryCode,
      financialYearId: financialYearId ?? this.financialYearId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
