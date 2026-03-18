import 'package:flutter/foundation.dart';

import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartProvider extends ChangeNotifier {
  final Map<int, CartItem> _items = <int, CartItem>{};

  List<CartItem> get items => _items.values.toList();

  List<CartItem> get selectedItems =>
      items.where((item) => item.isSelected).toList();

  int get totalQuantity =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);

  bool get isAllSelected =>
      _items.isNotEmpty && _items.values.every((item) => item.isSelected);

  void addToCart(Product product, {String? variation}) {
    if (_items.containsKey(product.id)) {
      final existing = _items[product.id]!;
      _items[product.id] = existing.copyWith(quantity: existing.quantity + 1);
    } else {
      _items[product.id] = CartItem(
        product: product,
        quantity: 1,
        variation: variation,
      );
    }
    notifyListeners();
  }

  void removeFromCart(int productId) {
    _items.remove(productId);
    notifyListeners();
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
    notifyListeners();
  }

  void toggleSelectItem(int productId) {
    if (!_items.containsKey(productId)) {
      return;
    }

    final existing = _items[productId]!;
    _items[productId] = existing.copyWith(isSelected: !existing.isSelected);
    notifyListeners();
  }

  void toggleSelectAll(bool isSelected) {
    _items.updateAll((_, item) => item.copyWith(isSelected: isSelected));
    notifyListeners();
  }

  double getTotalPrice() {
    return selectedItems.fold(0, (sum, item) => sum + item.totalPrice);
  }

  void clearSelectedItems() {
    _items.removeWhere((_, item) => item.isSelected);
    notifyListeners();
  }
}
