class Receipt {
  final String id;
  final DateTime createdAt;
  final String imagePath;
  final String? vendorName;
  final double totalAmount;
  final double potentialTaxSaving;
  final String? category;

  Receipt({
    required this.id,
    required this.createdAt,
    required this.imagePath,
    this.vendorName,
    required this.totalAmount,
    required this.potentialTaxSaving,
    this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'imagePath': imagePath,
      'vendorName': vendorName,
      'totalAmount': totalAmount,
      'potentialTaxSaving': potentialTaxSaving,
      'category': category,
    };
  }

  factory Receipt.fromMap(Map<String, dynamic> map) {
    return Receipt(
      id: map['id'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      imagePath: map['imagePath'] as String,
      vendorName: map['vendorName'] as String?,
      totalAmount: map['totalAmount'] as double,
      potentialTaxSaving: map['potentialTaxSaving'] as double,
      category: map['category'] as String?,
    );
  }
}
