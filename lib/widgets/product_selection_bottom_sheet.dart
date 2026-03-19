import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ProductSelectionResult {
  const ProductSelectionResult({
    required this.size,
    required this.color,
    required this.quantity,
  });

  final String size;
  final String color;
  final int quantity;

  String get variationLabel => 'Size: $size, Màu: $color';
}

class ProductSelectionBottomSheet extends StatefulWidget {
  final Product product;
  final String initialSize;
  final String initialColor;
  final String confirmText;

  const ProductSelectionBottomSheet({
    super.key,
    required this.product,
    this.initialSize = 'M',
    this.initialColor = 'Trắng',
    this.confirmText = 'Xác nhận',
  });

  @override
  State<ProductSelectionBottomSheet> createState() =>
      _ProductSelectionBottomSheetState();
}

class _ProductSelectionBottomSheetState
    extends State<ProductSelectionBottomSheet> {
  late String _selectedSize;
  late String _selectedColor;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _selectedSize = widget.initialSize;
    _selectedColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(widget.product.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\$${widget.product.price}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const Text('Kho: 123'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Màu sắc', style: TextStyle(fontWeight: FontWeight.bold)),
          Wrap(
            spacing: 8,
            children: ['Đỏ', 'Xanh', 'Trắng', 'Đen'].map((color) {
              final isSelected = _selectedColor == color;
              return ChoiceChip(
                label: Text(color),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() => _selectedColor = color);
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Text(
            'Kích thước',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Wrap(
            spacing: 8,
            children: ['S', 'M', 'L', 'XL'].map((size) {
              final isSelected = _selectedSize == size;
              return ChoiceChip(
                label: Text(size),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() => _selectedSize = size);
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Số lượng',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _quantity > 1
                          ? () => setState(() => _quantity--)
                          : null,
                      icon: const Icon(Icons.remove),
                    ),
                    Text(
                      '$_quantity',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => setState(() => _quantity++),
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  ProductSelectionResult(
                    size: _selectedSize,
                    color: _selectedColor,
                    quantity: _quantity,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(widget.confirmText),
            ),
          ),
        ],
      ),
    );
  }
}
