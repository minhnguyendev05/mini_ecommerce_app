import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../widgets/cart_item_widget.dart';

/// CartScreen - Hiển thị giỏ hàng
///
/// - Checkbox "Chọn tất cả" + auto-check when all selected
/// - ListView cart items với Dismissible (vuốt trái để xóa)
/// - Bottom bar: tổng tiền + button "Thanh toán"
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Giỏ hàng')),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          final items = cartProvider.items;

          if (items.isEmpty) {
            return const Center(
              child: Text(
                'Giỏ hàng trống\nThêm sản phẩm để bắt đầu mua sắm!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return Column(
            children: [
              // ListView cart items với Dismissible
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Dismissible(
                      key: Key('cart_item_${item.product.id}'),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) {
                        final removedItem = item;
                        cartProvider.removeFromCart(item.product.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${item.product.title} đã được xóa khỏi giỏ hàng',
                            ),
                            action: SnackBarAction(
                              label: 'Hoàn tác',
                              onPressed: () {
                                cartProvider.addToCart(
                                  removedItem.product,
                                  variation: removedItem.variation,
                                );
                                // Set the correct quantity
                                cartProvider.updateQuantity(
                                  removedItem.product.id,
                                  removedItem.quantity,
                                );
                              },
                            ),
                          ),
                        );
                      },
                      child: CartItemWidget(cartItem: item),
                    );
                  },
                ),
              ),
              // Bottom bar: Checkbox chọn tất cả + Tổng tiền + Thanh toán
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  border: const Border(top: BorderSide(color: Colors.black12)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Checkbox "Chọn tất cả"
                    Row(
                      children: [
                        Checkbox(
                          value: cartProvider.isAllSelected,
                          onChanged: (value) {
                            if (value != null) {
                              cartProvider.toggleSelectAll(value);
                            }
                          },
                        ),
                        const Text('Chọn tất cả'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Tổng tiền + Button thanh toán
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Tổng: \$${cartProvider.getTotalPrice().toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: cartProvider.selectedItems.isNotEmpty
                              ? () {
                                  // Navigate to checkout
                                  Navigator.pushNamed(context, '/checkout');
                                }
                              : null,
                          child: const Text('Thanh toán'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
