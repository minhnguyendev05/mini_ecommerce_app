import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart_item_model.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import '../widgets/product_selection_bottom_sheet.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _isExpanded = false;
  String _selectedSize = 'M';
  String _selectedColor = 'Trắng';

  Future<ProductSelectionResult?> _showSelectionBottomSheet(
    Product product, {
    String confirmText = 'Xác nhận',
  }) {
    return showModalBottomSheet<ProductSelectionResult>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return ProductSelectionBottomSheet(
          product: product,
          initialSize: _selectedSize,
          initialColor: _selectedColor,
          confirmText: confirmText,
        );
      },
    );
  }

  Future<void> _handleAddToCart(Product product) async {
    final result = await _showSelectionBottomSheet(product);
    if (result == null || !mounted) {
      return;
    }

    setState(() {
      _selectedSize = result.size;
      _selectedColor = result.color;
    });

    context.read<CartProvider>().addToCart(
      product,
      variation: result.variationLabel,
      quantity: result.quantity,
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Đã thêm ${result.quantity} sản phẩm vào giỏ hàng'),
          backgroundColor: Colors.teal,
        ),
      );
  }

  Future<void> _handleBuyNow(Product product) async {
    final result = await _showSelectionBottomSheet(
      product,
      confirmText: 'Mua ngay',
    );
    if (result == null || !mounted) {
      return;
    }

    setState(() {
      _selectedSize = result.size;
      _selectedColor = result.color;
    });

    final buyNowItem = CartItem(
      product: product,
      quantity: result.quantity,
      variation: result.variationLabel,
      isSelected: true,
    );

    Navigator.pushNamed(
      context,
      '/checkout',
      arguments: <CartItem>[buyNowItem],
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product?;

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Chi tiết sản phẩm')),
        body: const Center(child: Text('Không tìm thấy sản phẩm')),
      );
    }

    // Mock original price
    final double originalPrice = product.price * 1.25;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết sản phẩm'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined)),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/cart'),
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero animation and Image Slider
            Hero(
              tag: 'product-image-${product.id}',
              child: SizedBox(
                height: 400,
                width: double.infinity,
                child: PageView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Image.network(product.image, fit: BoxFit.contain);
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '\$${originalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          Text(
                            ' ${product.rating?.rate ?? 0.0} (${product.rating?.count ?? 0})',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const Text(
                    'Mô tả sản phẩm',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    maxLines: _isExpanded ? null : 3,
                    overflow: _isExpanded
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                  ),
                  InkWell(
                    onTap: () => setState(() => _isExpanded = !_isExpanded),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        _isExpanded ? 'Thu gọn' : 'Xem thêm',
                        style: const TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Chọn phân loại',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Màu: $_selectedColor, Size: $_selectedSize',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _handleAddToCart(product),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pushNamed(
                context,
                '/productChat',
                arguments: product,
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.chat_bubble_outline, size: 20),
                  Text('Chat', style: TextStyle(fontSize: 10)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const VerticalDivider(width: 1, indent: 10, endIndent: 10),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/cart'),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.shopping_cart_outlined, size: 20),
                  Text('Giỏ hàng', style: TextStyle(fontSize: 10)),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 45,
                      child: OutlinedButton(
                        onPressed: () => _handleAddToCart(product),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.teal),
                          foregroundColor: Colors.teal,
                          padding: EdgeInsets.zero,
                        ),
                        child: const Text(
                          'Thêm vào giỏ',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SizedBox(
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () => _handleBuyNow(product),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.zero,
                        ),
                        child: const Text(
                          'Mua ngay',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
