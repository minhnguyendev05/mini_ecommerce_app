import 'package:flutter/material.dart';
import 'package:mini_ecommerce_app/models/order_model.dart';
import 'package:mini_ecommerce_app/providers/order_provider.dart';
import 'package:provider/provider.dart';

/// Màn hình lịch sử đơn hàng theo 4 trạng thái xử lý.
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
          _OrderListByStatus(status: OrderStatus.pending),
          _OrderListByStatus(status: OrderStatus.shipping),
          _OrderListByStatus(status: OrderStatus.delivered),
          _OrderListByStatus(status: OrderStatus.cancelled),
        ],
      ),
    );
  }
}

class _OrderListByStatus extends StatelessWidget {
  const _OrderListByStatus({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (_, provider, _) {
        final orders = provider.getOrdersByStatus(status);

        if (orders.isEmpty) {
          return const Center(child: Text('Chưa có đơn hàng nào ở mục này.'));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: orders.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (_, index) {
            final order = orders[index];

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mã đơn: #${order.id}',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 12),
                    Text('Ngày: ${order.createdAt.toLocal()}'),
                    Text('Số sản phẩm: ${order.items.length}'),
                    Text(
                      'Thanh toán: ${PaymentMethod.toDisplayText(order.paymentMethod)}',
                    ),
                    Text('Địa chỉ: ${order.shippingAddress}'),
                    Text('Tổng tiền: \$${order.totalPrice.toStringAsFixed(2)}'),
                    const SizedBox(height: 12),
                    Chip(label: Text(OrderStatus.toDisplayText(order.status))),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
