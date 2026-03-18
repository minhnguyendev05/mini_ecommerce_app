import 'product_model.dart';

class CartItem {
  const CartItem({
    required this.product,
    required this.quantity,
    this.isSelected = true,
    this.variation,
  });

  final Product product;
  final int quantity;
  final bool isSelected;
  final String? variation;

  double get totalPrice => product.price * quantity;

  CartItem copyWith({
    Product? product,
    int? quantity,
    bool? isSelected,
    String? variation,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      isSelected: isSelected ?? this.isSelected,
      variation: variation ?? this.variation,
    );
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      quantity: (json['quantity'] ?? 1) as int,
      isSelected: (json['isSelected'] ?? true) as bool,
      variation: json['variation'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
      'isSelected': isSelected,
      'variation': variation,
    };
  }
}
