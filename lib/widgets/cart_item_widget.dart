import 'package:flutter/material.dart';

/// CartItemWidget - Người 4 phụ trách
///
/// Widget hiển thị một item trong giỏ hàng:
/// - Checkbox để chọn
/// - Ảnh sản phẩm
/// - Tên sản phẩm
/// - Giá
/// - Quantity +/-
/// - Button xóa
///
/// TODO: Người 4 thực hiện widget này
class CartItemWidget extends StatelessWidget {
  const CartItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Checkbox(value: false, onChanged: (_) {}),
            Container(
              width: 70,
              height: 70,
              color: Colors.grey.shade300,
              child: const Center(child: Text('Image')),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 16, color: Colors.grey.shade300),
                  const SizedBox(height: 4),
                  Container(height: 12, width: 60, color: Colors.grey.shade300),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      const Text('1'),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ),
      ),
    );
  }
}
