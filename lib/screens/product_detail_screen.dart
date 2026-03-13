import 'package:flutter/material.dart';

/// ProductDetailScreen - Người 3 phụ trách
///
/// Yêu cầu:
/// - Hero animation từ product card
/// - Image slider (nhiều ảnh)
/// - Tên, giá gốc (gạch ngang), rating
/// - Description (Xem thêm/Thu gọn)
/// - BottomSheet chọn size/màu
/// - Buttons: Chat, Like, Add to Cart, Buy now
///
/// TODO: Người 3 thực hiện chi tiết screen này
class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết sản phẩm')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TODO: Image slider placeholder
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text('Image Slider\n(Người 3 thực hiện)'),
              ),
            ),
            const SizedBox(height: 16),
            // TODO: Product info (name, price, rating)
            Container(height: 20, color: Colors.grey.shade300),
            const SizedBox(height: 24),
            // TODO: Description + Xem thêm
            Container(height: 60, color: Colors.grey.shade300),
            const SizedBox(height: 24),
            // TODO: BottomSheet button + Add to cart
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: const Text('Chat'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.favorite_outline),
                    label: const Text('Yêu thích'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Thêm giỏ hàng'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Mua ngay'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
