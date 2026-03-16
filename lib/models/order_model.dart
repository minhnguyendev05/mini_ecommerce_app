import 'package:mini_ecommerce_app/models/cart_item_model.dart';

class OrderStatus {
  static const String PENDING = 'pending';
  static const String SHIPPING = 'shipping';
  static const String DELIVERED = 'delivered';
  static const String CANCELLED = 'cancelled';

  static const List<String> ALL = <String>[
    PENDING,
    SHIPPING,
    DELIVERED,
    CANCELLED,
  ];

  static String toDisplayText(String status) {
    switch (status) {
      case SHIPPING:
        return 'Đang giao';
      case DELIVERED:
        return 'Đã giao';
      case CANCELLED:
        return 'Đã hủy';
      case PENDING:
      default:
        return 'Chờ xác nhận';
    }
  }
}

class PaymentMethod {
  static const String COD = 'COD';
  static const String MOMO = 'MOMO';

  static String toDisplayText(String method) {
    switch (method) {
      case MOMO:
        return 'Momo';
      case COD:
      default:
        return 'COD';
    }
  }
}

class OrderModel {
  const OrderModel({
    required this.id,
    required this.items,
    required this.totalPrice,
    required this.createdAt,
    required this.shippingAddress,
    required this.paymentMethod,
    this.status = OrderStatus.PENDING,
  });

  final String id;
  final List<CartItem> items;
  final double totalPrice;
  final DateTime createdAt;
  final String shippingAddress;
  final String paymentMethod;
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
      shippingAddress: (json['shippingAddress'] ?? '') as String,
      paymentMethod: (json['paymentMethod'] ?? PaymentMethod.COD) as String,
      status: (json['status'] ?? OrderStatus.PENDING) as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'totalPrice': totalPrice,
      'createdAt': createdAt.toIso8601String(),
      'shippingAddress': shippingAddress,
      'paymentMethod': paymentMethod,
      'status': status,
    };
  }

  OrderModel copyWith({String? status}) {
    return OrderModel(
      id: id,
      items: items,
      totalPrice: totalPrice,
      createdAt: createdAt,
      shippingAddress: shippingAddress,
      paymentMethod: paymentMethod,
      status: status ?? this.status,
    );
  }
}
