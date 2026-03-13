import 'package:flutter/material.dart';

/// CartScreen - Người 4 phụ trách
///
/// Yêu cầu:
/// - Hiển thị danh sách giỏ hàng
/// - Checkbox select/select all
/// - Vuốt trái để xóa (Dismissible)
/// - Quantity +/- buttons
/// - Tính tổng tiền realtime
/// - Button Thanh toán
///
/// TODO: Người 4 thực hiện screen này
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Giỏ hàng')),
      body: Column(
        children: [
          // TODO: Checkbox "Chọn tất cả"
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Checkbox(value: false, onChanged: (_) {}),
                const Text('Chọn tất cả'),
              ],
            ),
          ),
          // TODO: ListView cart items (với Dismissible)
          Expanded(
            child: Center(
              child: Text(
                'Cart Items Placeholder\n(Người 4 thực hiện)',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // TODO: Bottom bar: Tổng tiền + Thanh toán
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: const Border(top: BorderSide(color: Colors.black12)),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Tổng: \$0.00',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Thanh toán'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
