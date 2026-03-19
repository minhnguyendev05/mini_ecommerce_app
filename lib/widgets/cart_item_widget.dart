import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart_item_model.dart';
import '../providers/cart_provider.dart';

/// CartItemWidget - Widget hiển thị một item trong giỏ hàng
///
/// - Checkbox để chọn
/// - Ảnh sản phẩm
/// - Tên sản phẩm
/// - Giá
/// - Quantity +/-
/// - Button xóa
class CartItemWidget extends StatelessWidget {
  const CartItemWidget({super.key, required this.cartItem});

  final CartItem cartItem;

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.read<CartProvider>();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Checkbox(
              value: cartItem.isSelected,
              onChanged: (_) {
                cartProvider.toggleSelectItem(cartItem.product.id);
              },
            ),
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(cartItem.product.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.product.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (cartItem.variation != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      cartItem.variation!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    '\$${cartItem.product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          if (cartItem.quantity > 1) {
                            cartProvider.updateQuantity(
                              cartItem.product.id,
                              cartItem.quantity - 1,
                            );
                          } else {
                            // Confirm remove when quantity would become 0
                            final shouldRemove = await showDialog<bool>(
                              context: context,
                              builder: (dialogContext) => AlertDialog(
                                title: const Text('Xác nhận'),
                                content: Text(
                                  'Bạn có muốn xóa ${cartItem.product.title} khỏi giỏ hàng?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(dialogContext).pop(false),
                                    child: const Text('Hủy'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(dialogContext).pop(true),
                                    child: const Text('Xóa'),
                                  ),
                                ],
                              ),
                            );
                            if (shouldRemove == true) {
                              cartProvider.removeFromCart(cartItem.product.id);
                            }
                          }
                        },
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Text(
                        '${cartItem.quantity}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          cartProvider.updateQuantity(
                            cartItem.product.id,
                            cartItem.quantity + 1,
                          );
                        },
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                cartProvider.removeFromCart(cartItem.product.id);
              },
              icon: const Icon(Icons.delete_outline),
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
