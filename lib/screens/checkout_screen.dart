import 'package:flutter/material.dart';

/// CheckoutScreen - Người 5 phụ trách
///
/// Yêu cầu:
/// - Hiển thị danh sách item được chọn
/// - Form nhập địa chỉ giao hàng
/// - Lựa chọn payment (COD, Momo)
/// - Button "Đặt hàng" -> tạo Order
/// - Xóa item khỏi cart sau khi order thành công
///
/// TODO: Người 5 thực hiện screen này
class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thanh toán')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TODO: Danh sách items được chọn
            const Text(
              'Danh sách sản phẩm',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Container(
              height: 100,
              color: Colors.grey.shade200,
              child: const Center(
                child: Text('Items placeholder (Người 5 thực hiện)'),
              ),
            ),
            const SizedBox(height: 24),
            // TODO: Form địa chỉ
            const Text(
              'Địa chỉ giao hàng',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: 'Nhập địa chỉ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // TODO: Phương thức thanh toán
            const Text(
              'Phương thức thanh toán',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Text('COD'),
                    selected: true,
                    onSelected: (_) {},
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Momo'),
                    selected: false,
                    onSelected: (_) {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // TODO: Tổng tiền
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Tổng thanh toán',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Text(
                  '\$0.00',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.teal,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Xác nhận đặt hàng'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
