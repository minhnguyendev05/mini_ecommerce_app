import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartProvider extends ChangeNotifier {
  CartProvider() {
    _loadCart();
  }

  static const String _cartStorageKey = 'cart_items';
  final Map<int, CartItem> _items = <int, CartItem>{};

  List<CartItem> get items => _items.values.toList();

  List<CartItem> get selectedItems =>
      items.where((item) => item.isSelected).toList();

  int get totalQuantity =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);

  bool get isAllSelected =>
      _items.isNotEmpty && _items.values.every((item) => item.isSelected);

  void addToCart(Product product, {String? variation, int quantity = 1}) {
    final normalizedQuantity = quantity < 1 ? 1 : quantity;

    if (_items.containsKey(product.id)) {
      final existing = _items[product.id]!;
      _items[product.id] = existing.copyWith(
        quantity: existing.quantity + normalizedQuantity,
        variation: variation ?? existing.variation,
      );
    } else {
      _items[product.id] = CartItem(
        product: product,
        quantity: normalizedQuantity,
        variation: variation ?? 'Size: M, Màu: Trắng',
      );
    }
    _persistAndNotify();
  }

  void removeFromCart(int productId) {
    _items.remove(productId);
    _persistAndNotify();
  }

  void updateQuantity(int productId, int quantity) {
    if (!_items.containsKey(productId)) {
      return;
    }

    if (quantity <= 0) {
      // Don't remove here, let UI handle confirmation
      return;
    }

    final existing = _items[productId]!;
    _items[productId] = existing.copyWith(quantity: quantity);
    _persistAndNotify();
  }

  void toggleSelectItem(int productId) {
    if (!_items.containsKey(productId)) {
      return;
    }

    final existing = _items[productId]!;
    _items[productId] = existing.copyWith(isSelected: !existing.isSelected);
    _persistAndNotify();
  }

  void toggleSelectAll(bool isSelected) {
    _items.updateAll((_, item) => item.copyWith(isSelected: isSelected));
    _persistAndNotify();
  }

  double getTotalPrice() {
    return selectedItems.fold(0, (sum, item) => sum + item.totalPrice);
  }

  void clearSelectedItems() {
    _items.removeWhere((_, item) => item.isSelected);
    _persistAndNotify();
  }

  Future<void> _loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_cartStorageKey) ?? <String>[];

    final loadedItems = <int, CartItem>{};
    for (final rawItem in raw) {
      final parsed = jsonDecode(rawItem);
      if (parsed is Map<String, dynamic>) {
        final item = CartItem.fromJson(parsed);
        loadedItems[item.product.id] = item;
      }
    }

    _items
      ..clear()
      ..addAll(loadedItems);
    notifyListeners();
  }

  Future<void> _persistCart() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = _items.values
        .map((item) => jsonEncode(item.toJson()))
        .toList(growable: false);
    await prefs.setStringList(_cartStorageKey, raw);
  }

  void _persistAndNotify() {
    notifyListeners();
    _persistCart();
  }
}
