import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mini_ecommerce_app/models/cart_item_model.dart';
import 'package:mini_ecommerce_app/models/order_model.dart';

/// Quản lý danh sách đơn hàng và lưu cục bộ bằng SharedPreferences.
class OrderProvider extends ChangeNotifier {
  OrderProvider() {
    loadOrders();
  }

  static const String ORDERS_KEY = 'orders_history';
  List<OrderModel> _orders = <OrderModel>[];

  List<OrderModel> get orders => List<OrderModel>.unmodifiable(_orders);

  List<OrderModel> getOrdersByStatus(String status) {
    return _orders.where((order) => order.status == status).toList();
  }

  Future<void> loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final rawOrders = prefs.getStringList(ORDERS_KEY) ?? <String>[];

    _orders = rawOrders
        .map((raw) => OrderModel.fromJson(
              Map<String, dynamic>.from(
                (jsonDecode(raw) as Map<String, dynamic>),
              ),
            ))
        .toList();

    notifyListeners();
  }

  Future<void> placeOrder({
    required List<CartItem> items,
    required String shippingAddress,
    required String paymentMethod,
  }) async {
    if (items.isEmpty) {
      return;
    }

    final totalPrice = items.fold<double>(
      0,
      (sum, item) => sum + item.totalPrice,
    );

    final newOrder = OrderModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      items: items,
      totalPrice: totalPrice,
      createdAt: DateTime.now(),
      shippingAddress: shippingAddress,
      paymentMethod: paymentMethod,
      status: OrderStatus.PENDING,
    );

    _orders = <OrderModel>[newOrder, ..._orders];
    await _persistOrders();
    notifyListeners();
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    if (!OrderStatus.ALL.contains(status)) {
      return;
    }

    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index == -1) {
      return;
    }

    _orders[index] = _orders[index].copyWith(status: status);
    await _persistOrders();
    notifyListeners();
  }

  Future<void> _persistOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = _orders.map((order) => jsonEncode(order.toJson())).toList();
    await prefs.setStringList(ORDERS_KEY, raw);
  }
}
