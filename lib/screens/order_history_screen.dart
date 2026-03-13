import 'package:flutter/material.dart';

/// OrderHistoryScreen - Người 5 phụ trách
///
/// Yêu cầu:
/// - TabBar: Chờ xác nhận | Đang giao | Đã giao | Đã hủy
/// - Mỗi tab hiển thị list order theo status
/// - Card hiển thị: ID, ngày, số sản phẩm, tổng giá, status
/// - Tap vào để xem chi tiết (optional)
///
/// TODO: Người 5 thực hiện screen này
class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch sử đơn hàng'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Chờ xác nhận'),
            Tab(text: 'Đang giao'),
            Tab(text: 'Đã giao'),
            Tab(text: 'Đã hủy'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // TODO: Chờ xác nhận
          Center(child: Text('Orders pending (Người 5 thực hiện)')),
          // TODO: Đang giao
          Center(child: Text('Orders shipping (Người 5 thực hiện)')),
          // TODO: Đã giao
          Center(child: Text('Orders delivered (Người 5 thực hiện)')),
          // TODO: Đã hủy
          Center(child: Text('Orders cancelled (Người 5 thực hiện)')),
        ],
      ),
    );
  }
}
