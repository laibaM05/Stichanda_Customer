class OrderDetailsModel {
  final String id;
  final String itemType; // e.g., 'Shirt', 'Trouser', 'Kurta', etc.
  final String clothType; // e.g., 'Lawn', 'Cotton', 'Silk', etc.
  final int price;
  final String? description;
  final String? measurements;
  final DateTime createdAt;

  OrderDetailsModel({
    required this.id,
    required this.itemType,
    required this.clothType,
    required this.price,
    this.description,
    this.measurements,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert from JSON (for Firestore)
  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailsModel(
      id: json['id'] ?? '',
      itemType: json['itemType'] ?? '',
      clothType: json['clothType'] ?? '',
      price: json['price'] ?? 0,
      description: json['description'],
      measurements: json['measurements'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  // Convert to JSON (for Firestore)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemType': itemType,
      'clothType': clothType,
      'price': price,
      'description': description,
      'measurements': measurements,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create a copy with updated fields
  OrderDetailsModel copyWith({
    String? id,
    String? itemType,
    String? clothType,
    int? price,
    String? description,
    String? measurements,
    DateTime? createdAt,
  }) {
    return OrderDetailsModel(
      id: id ?? this.id,
      itemType: itemType ?? this.itemType,
      clothType: clothType ?? this.clothType,
      price: price ?? this.price,
      description: description ?? this.description,
      measurements: measurements ?? this.measurements,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'OrderDetailsModel(id: $id, itemType: $itemType, clothType: $clothType, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OrderDetailsModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

