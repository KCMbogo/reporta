class Product {
  final int? id;
  final String name;
  final String description;
  final double price;
  final int stockQuantity;
  final int lowStockThreshold;
  final String category;
  final String currency;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stockQuantity,
    this.lowStockThreshold = 10,
    this.category = 'General',
    this.currency = 'USD',
    this.imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  // Convert Product to Map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stock_quantity': stockQuantity,
      'low_stock_threshold': lowStockThreshold,
      'category': category,
      'currency': currency,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Create Product from Map (database result)
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id']?.toInt(),
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      stockQuantity: map['stock_quantity']?.toInt() ?? 0,
      lowStockThreshold: map['low_stock_threshold']?.toInt() ?? 10,
      category: map['category'] ?? 'General',
      currency: map['currency'] ?? 'USD',
      imageUrl: map['image_url'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  // Create a copy of Product with updated fields
  Product copyWith({
    int? id,
    String? name,
    String? description,
    double? price,
    int? stockQuantity,
    int? lowStockThreshold,
    String? category,
    String? currency,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      category: category ?? this.category,
      currency: currency ?? this.currency,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  // Check if product is low stock
  bool get isLowStock => stockQuantity <= lowStockThreshold;

  // Get stock status
  String get stockStatus {
    if (stockQuantity == 0) return 'Out of Stock';
    if (isLowStock) return 'Low Stock';
    return 'In Stock';
  }

  // Get stock status color
  String get stockStatusColor {
    if (stockQuantity == 0) return 'error';
    if (isLowStock) return 'warning';
    return 'success';
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, price: $price, stock: $stockQuantity}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.price == price &&
        other.stockQuantity == stockQuantity;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        price.hashCode ^
        stockQuantity.hashCode;
  }
}
