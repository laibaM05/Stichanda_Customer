import 'order_details_model.dart';

class OrderModel {
  final String id;
  final String tailorName;
  final String tailorArea;
  final String? tailorId;
  final List<OrderDetailsModel> orderDetails; // Changed from List<String> items
  final int totalPrice;
  final DateTime deadline;
  final DateTime orderDate;
  final String status; // 'In Progress' or 'Completed'
  final DateTime? deliveredDate;
  final String? customerId;

  OrderModel({
    required this.id,
    required this.tailorName,
    required this.tailorArea,
    this.tailorId,
    required this.orderDetails,
    required this.totalPrice,
    required this.deadline,
    required this.orderDate,
    required this.status,
    this.deliveredDate,
    this.customerId,
  });

  // Convenience getter for item names (for backward compatibility)
  List<String> get items => orderDetails.map((detail) => detail.itemType).toList();

  // Convenience getter for total number of sub-orders
  int get itemCount => orderDetails.length;

  // Convert from JSON (for Firestore)
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      tailorName: json['tailorName'] ?? '',
      tailorArea: json['tailorArea'] ?? '',
      tailorId: json['tailorId'],
      orderDetails: (json['orderDetails'] as List<dynamic>?)
          ?.map((item) => OrderDetailsModel.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      totalPrice: json['totalPrice'] ?? 0,
      deadline: json['deadline'] != null
          ? DateTime.parse(json['deadline'])
          : DateTime.now(),
      orderDate: json['orderDate'] != null
          ? DateTime.parse(json['orderDate'])
          : DateTime.now(),
      status: json['status'] ?? 'In Progress',
      deliveredDate: json['deliveredDate'] != null
          ? DateTime.parse(json['deliveredDate'])
          : null,
      customerId: json['customerId'],
    );
  }

  // Convert to JSON (for Firestore)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tailorName': tailorName,
      'tailorArea': tailorArea,
      'tailorId': tailorId,
      'orderDetails': orderDetails.map((detail) => detail.toJson()).toList(),
      'totalPrice': totalPrice,
      'deadline': deadline.toIso8601String(),
      'orderDate': orderDate.toIso8601String(),
      'status': status,
      'deliveredDate': deliveredDate?.toIso8601String(),
      'customerId': customerId,
    };
  }

  // Create a copy with updated fields
  OrderModel copyWith({
    String? id,
    String? tailorName,
    String? tailorArea,
    String? tailorId,
    List<OrderDetailsModel>? orderDetails,
    int? totalPrice,
    DateTime? deadline,
    DateTime? orderDate,
    String? status,
    DateTime? deliveredDate,
    String? customerId,
  }) {
    return OrderModel(
      id: id ?? this.id,
      tailorName: tailorName ?? this.tailorName,
      tailorArea: tailorArea ?? this.tailorArea,
      tailorId: tailorId ?? this.tailorId,
      orderDetails: orderDetails ?? this.orderDetails,
      totalPrice: totalPrice ?? this.totalPrice,
      deadline: deadline ?? this.deadline,
      orderDate: orderDate ?? this.orderDate,
      status: status ?? this.status,
      deliveredDate: deliveredDate ?? this.deliveredDate,
      customerId: customerId ?? this.customerId,
    );
  }

  // Check if order is in progress
  bool get isInProgress => status == 'In Progress';

  // Check if order is completed
  bool get isCompleted => status == 'Completed';

  // Check if order is overdue (deadline passed but not completed)
  bool get isOverdue =>
      isInProgress && deadline.isBefore(DateTime.now());

  // Days remaining until deadline (negative if overdue)
  int get daysUntilDeadline {
    final difference = deadline.difference(DateTime.now());
    return difference.inDays;
  }

  @override
  String toString() {
    return 'OrderModel(id: $id, tailorName: $tailorName, itemCount: $itemCount, status: $status, totalPrice: $totalPrice)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OrderModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

