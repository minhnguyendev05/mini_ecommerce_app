import 'package:flutter/material.dart';

/// ProductCard - Người 2 phụ trách
///
/// Hiển thị một sản phẩm trong grid:
/// - Ảnh sản phẩm (với Hero animation cho detail)
/// - Tên (max 2 dòng)
/// - Giá
/// - Rating
/// - Button thêm giỏ hàng
///
/// TODO: Người 2 thực hiện widget này
class ProductCard extends StatelessWidget {
  const ProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TODO: Hero animation image placeholder
          Container(
            height: 120,
            color: Colors.grey.shade200,
            child: const Center(
              child: Text('Product Image\n(Người 2 thực hiện)'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TODO: Tên sản phẩm (max 2 dòng)
                Container(height: 20, color: Colors.grey.shade300),
                const SizedBox(height: 4),
                // TODO: Rating
                Container(height: 12, width: 80, color: Colors.grey.shade300),
                const SizedBox(height: 8),
                Row(
                  children: [
                    // TODO: Giá
                    Container(
                      height: 16,
                      width: 60,
                      color: Colors.grey.shade300,
                    ),
                    const Spacer(),
                    // TODO: Button thêm giỏ
                    const Icon(Icons.add_shopping_cart),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
