import 'package:flutter/material.dart';
import 'package:mini_ecommerce_app/models/cart_item_model.dart';
import 'package:mini_ecommerce_app/models/order_model.dart';
import 'package:mini_ecommerce_app/providers/cart_provider.dart';
import 'package:mini_ecommerce_app/providers/order_provider.dart';
import 'package:provider/provider.dart';

/// Màn hình thanh toán: xác nhận sản phẩm, địa chỉ, phương thức thanh toán.
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  static const String screenTitle = 'Thanh toán';
  static const String placeOrderButton = 'Đặt hàng';

  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();

  String _selectedPayment = PaymentMethod.cod;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder(List<CartItem> items) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bạn chưa chọn sản phẩm để đặt hàng.')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final orderProvider = context.read<OrderProvider>();
    final cartProvider = context.read<CartProvider>();

    await orderProvider.placeOrder(
      items: items,
      shippingAddress: _addressController.text.trim(),
      paymentMethod: _selectedPayment,
    );

    cartProvider.clearSelectedItems();

    if (!mounted) {
      return;
    }

    setState(() {
      _isSubmitting = false;
    });

    final shouldOpenOrders = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Đặt hàng thành công'),
          content: const Text('Cảm ơn bạn. Đơn hàng của bạn đã được ghi nhận.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Về trang chủ'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Xem đơn mua'),
            ),
          ],
        );
      },
    );

    if (!mounted) {
      return;
    }

    if (shouldOpenOrders == true) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/orders',
        ModalRoute.withName('/home'),
      );
      return;
    }

    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)?.settings.arguments;
    final routeItems = routeArgs is List<CartItem> ? routeArgs : <CartItem>[];
    final selectedItems = routeItems.isNotEmpty
        ? routeItems
        : context.watch<CartProvider>().selectedItems;
    final total = selectedItems.fold<double>(
      0,
      (sum, item) => sum + item.totalPrice,
    );

    return Scaffold(
      appBar: AppBar(title: const Text(screenTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Danh sách sản phẩm đã chọn',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              if (selectedItems.isEmpty)
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('Chưa có sản phẩm được chọn.'),
                  ),
                )
              else
                Column(
                  children: selectedItems
                      .map(
                        (item) => Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            title: Text(item.product.title),
                            subtitle: Text(
                              'SL: ${item.quantity} x ${item.product.price.toStringAsFixed(2)}',
                            ),
                            trailing: Text(
                              item.totalPrice.toStringAsFixed(2),
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              const SizedBox(height: 12),
              const Text(
                'Địa chỉ giao hàng',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressController,
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập địa chỉ giao hàng';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: 'Nhập địa chỉ nhận hàng',
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Phương thức thanh toán',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('COD'),
                      selected: _selectedPayment == PaymentMethod.cod,
                      onSelected: (_) {
                        setState(() {
                          _selectedPayment = PaymentMethod.cod;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Momo'),
                      selected: _selectedPayment == PaymentMethod.momo,
                      onSelected: (_) {
                        setState(() {
                          _selectedPayment = PaymentMethod.momo;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Tổng thanh toán',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(
                    '\$${total.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.teal,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting
                      ? null
                      : () => _placeOrder(selectedItems),
                  child: Text(
                    _isSubmitting ? 'Đang xử lý...' : placeOrderButton,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
