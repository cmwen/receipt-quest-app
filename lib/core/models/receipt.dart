class Receipt {
  final String id;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String imagePath;
  final String? vendorName;
  final double totalAmount;
  final double potentialTaxSaving;
  final String? category;
  final String? notes;
  final String financialYearId;
  final bool isDeleted;

  Receipt({
    required this.id,
    required this.createdAt,
    this.updatedAt,
    required this.imagePath,
    this.vendorName,
    required this.totalAmount,
    required this.potentialTaxSaving,
    this.category,
    this.notes,
    this.financialYearId = '',
    this.isDeleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'imagePath': imagePath,
      'vendorName': vendorName,
      'totalAmount': totalAmount,
      'potentialTaxSaving': potentialTaxSaving,
      'category': category,
      'notes': notes,
      'financialYearId': financialYearId,
      'isDeleted': isDeleted ? 1 : 0,
    };
  }

  factory Receipt.fromMap(Map<String, dynamic> map) {
    return Receipt(
      id: map['id'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int)
          : null,
      imagePath: map['imagePath'] as String,
      vendorName: map['vendorName'] as String?,
      totalAmount: (map['totalAmount'] as num).toDouble(),
      potentialTaxSaving: (map['potentialTaxSaving'] as num).toDouble(),
      category: map['category'] as String?,
      notes: map['notes'] as String?,
      financialYearId: map['financialYearId'] as String? ?? '',
      isDeleted: map['isDeleted'] == 1,
    );
  }

  Receipt copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? imagePath,
    String? vendorName,
    double? totalAmount,
    double? potentialTaxSaving,
    String? category,
    String? notes,
    String? financialYearId,
    bool? isDeleted,
  }) {
    return Receipt(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      imagePath: imagePath ?? this.imagePath,
      vendorName: vendorName ?? this.vendorName,
      totalAmount: totalAmount ?? this.totalAmount,
      potentialTaxSaving: potentialTaxSaving ?? this.potentialTaxSaving,
      category: category ?? this.category,
      notes: notes ?? this.notes,
      financialYearId: financialYearId ?? this.financialYearId,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
