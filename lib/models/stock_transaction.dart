enum TransactionType {
  stockIn,
  stockOut,
  sale,
  adjustment,
}

class StockTransaction {
  final int? id;
  final int productId;
  final TransactionType transactionType;
  final int quantity;
  final double? unitPrice;
  final double? totalAmount;
  final String? notes;
  final String? reference;
  final DateTime createdAt;

  StockTransaction({
    this.id,
    required this.productId,
    required this.transactionType,
    required this.quantity,
    this.unitPrice,
    this.totalAmount,
    this.notes,
    this.reference,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert StockTransaction to Map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_id': productId,
      'transaction_type': transactionType.name,
      'quantity': quantity,
      'unit_price': unitPrice,
      'total_amount': totalAmount,
      'notes': notes,
      'reference': reference,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Create StockTransaction from Map (database result)
  factory StockTransaction.fromMap(Map<String, dynamic> map) {
    return StockTransaction(
      id: map['id']?.toInt(),
      productId: map['product_id']?.toInt() ?? 0,
      transactionType: TransactionType.values.firstWhere(
        (e) => e.name == map['transaction_type'],
        orElse: () => TransactionType.adjustment,
      ),
      quantity: map['quantity']?.toInt() ?? 0,
      unitPrice: map['unit_price']?.toDouble(),
      totalAmount: map['total_amount']?.toDouble(),
      notes: map['notes'],
      reference: map['reference'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  // Create a copy of StockTransaction with updated fields
  StockTransaction copyWith({
    int? id,
    int? productId,
    TransactionType? transactionType,
    int? quantity,
    double? unitPrice,
    double? totalAmount,
    String? notes,
    String? reference,
    DateTime? createdAt,
  }) {
    return StockTransaction(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      transactionType: transactionType ?? this.transactionType,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      totalAmount: totalAmount ?? this.totalAmount,
      notes: notes ?? this.notes,
      reference: reference ?? this.reference,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Get transaction type display name
  String get transactionTypeDisplayName {
    switch (transactionType) {
      case TransactionType.stockIn:
        return 'Stock In';
      case TransactionType.stockOut:
        return 'Stock Out';
      case TransactionType.sale:
        return 'Sale';
      case TransactionType.adjustment:
        return 'Adjustment';
    }
  }

  // Get transaction type icon
  String get transactionTypeIcon {
    switch (transactionType) {
      case TransactionType.stockIn:
        return 'add_box';
      case TransactionType.stockOut:
        return 'remove_circle';
      case TransactionType.sale:
        return 'shopping_cart';
      case TransactionType.adjustment:
        return 'edit';
    }
  }

  // Check if transaction increases stock
  bool get increasesStock {
    return transactionType == TransactionType.stockIn;
  }

  // Check if transaction decreases stock
  bool get decreasesStock {
    return transactionType == TransactionType.stockOut || 
           transactionType == TransactionType.sale;
  }

  // Get effective quantity (positive for increase, negative for decrease)
  int get effectiveQuantity {
    if (increasesStock) return quantity;
    if (decreasesStock) return -quantity;
    return quantity; // For adjustments, use as-is
  }

  @override
  String toString() {
    return 'StockTransaction{id: $id, productId: $productId, type: $transactionType, quantity: $quantity}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StockTransaction &&
        other.id == id &&
        other.productId == productId &&
        other.transactionType == transactionType &&
        other.quantity == quantity;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        productId.hashCode ^
        transactionType.hashCode ^
        quantity.hashCode;
  }
}
