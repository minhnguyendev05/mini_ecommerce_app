import 'cart_item_model.dart';

class OrderModel {
  const OrderModel({
    required this.id,
    required this.items,
    required this.totalPrice,
    required this.createdAt,
    this.status = 'Pending',
  });

  final String id;
  final List<CartItem> items;
  final double totalPrice;
  final DateTime createdAt;
  final String status;

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final rawItems = (json['items'] ?? <dynamic>[]) as List<dynamic>;

    return OrderModel(
      id: (json['id'] ?? '') as String,
      items: rawItems
          .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      createdAt:
          DateTime.tryParse((json['createdAt'] ?? '') as String) ??
          DateTime.now(),
      status: (json['status'] ?? 'Pending') as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'totalPrice': totalPrice,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
    };
  }
}
