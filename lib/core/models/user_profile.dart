class UserProfile {
  final String incomeBracket;
  final String filingStatus;

  UserProfile({required this.incomeBracket, required this.filingStatus});

  Map<String, dynamic> toJson() {
    return {'incomeBracket': incomeBracket, 'filingStatus': filingStatus};
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      incomeBracket: json['incomeBracket'] as String,
      filingStatus: json['filingStatus'] as String,
    );
  }

  double get taxRate {
    // Conservative tax rate estimates based on income bracket
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
}
