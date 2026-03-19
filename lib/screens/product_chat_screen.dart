import 'package:flutter/material.dart';

import '../models/product_model.dart';

class ProductChatScreen extends StatefulWidget {
  const ProductChatScreen({super.key});

  @override
  State<ProductChatScreen> createState() => _ProductChatScreenState();
}

class _ProductChatScreenState extends State<ProductChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<_ChatMessage> _messages = <_ChatMessage>[];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _ensureWelcome(Product product) {
    if (_messages.isNotEmpty) {
      return;
    }

    _messages.add(
      _ChatMessage(
        text:
            'Xin chào! Mình là trợ lý tư vấn cho sản phẩm "${product.title}". Bạn có thể hỏi về giá, đánh giá, phân loại và cách sử dụng.',
        isUser: false,
      ),
    );
  }

  void _sendMessage(Product product) {
    final input = _controller.text.trim();
    if (input.isEmpty) {
      return;
    }

    setState(() {
      _messages.add(_ChatMessage(text: input, isUser: true));
      _messages.add(
        _ChatMessage(text: _replyFor(product, input), isUser: false),
      );
      _controller.clear();
    });
  }

  String _replyFor(Product product, String question) {
    final q = question.toLowerCase();
    final rating = product.rating?.rate ?? 0;
    final count = product.rating?.count ?? 0;

    if (q.contains('giá') ||
        q.contains('gia') ||
        q.contains('bao nhiêu') ||
        q.contains('bao nhieu') ||
        q.contains('price')) {
      return 'Giá hiện tại là \$${product.price.toStringAsFixed(2)}. Bạn có thể thêm vào giỏ hoặc mua ngay từ màn hình chi tiết.';
    }

    if (q.contains('đánh giá') ||
        q.contains('danh gia') ||
        q.contains('review') ||
        q.contains('sao')) {
      return 'Sản phẩm đang có điểm $rating/5 từ $count lượt đánh giá. Nếu bạn ưu tiên chất lượng, đây là mức khá tốt.';
    }

    if (q.contains('size') ||
        q.contains('màu') ||
        q.contains('mau') ||
        q.contains('phân loại') ||
        q.contains('phan loai') ||
        q.contains('biến thể') ||
        q.contains('bien the')) {
      return 'Bạn có thể bấm "Chọn phân loại" để chọn Size (S, M, L, XL), màu sắc và số lượng trước khi thêm vào giỏ.';
    }

    if (q.contains('van chuyen') ||
        q.contains('vận chuyển') ||
        q.contains('giao hang') ||
        q.contains('giao hàng') ||
        q.contains('ship')) {
      return 'Sau khi chọn sản phẩm ở giỏ hàng, bạn thanh toán và nhập địa chỉ giao hàng. Đơn sẽ xuất hiện ở mục Đơn mua.';
    }

    return 'Mình gợi ý bạn xem kỹ mô tả, đánh giá và chọn phân loại phù hợp. Nếu cần, bạn hỏi cụ thể hơn về giá, size, màu hoặc cách đặt hàng nhé.';
  }

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)?.settings.arguments as Product?;

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Tư vấn sản phẩm')),
        body: const Center(child: Text('Không tìm thấy sản phẩm để tư vấn.')),
      );
    }

    _ensureWelcome(product);

    return Scaffold(
      appBar: AppBar(title: const Text('Chat tư vấn')),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.teal.shade50,
            child: Text(
              'Đang tư vấn: ${product.title}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final alignment = message.isUser
                    ? Alignment.centerRight
                    : Alignment.centerLeft;
                final color = message.isUser
                    ? Colors.teal.shade400
                    : Colors.grey.shade200;
                final textColor = message.isUser
                    ? Colors.white
                    : Colors.black87;

                return Align(
                  alignment: alignment,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    constraints: const BoxConstraints(maxWidth: 320),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      message.text,
                      style: TextStyle(color: textColor),
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(product),
                      decoration: const InputDecoration(
                        hintText: 'Hỏi về sản phẩm này...',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () => _sendMessage(product),
                    child: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  const _ChatMessage({required this.text, required this.isUser});

  final String text;
  final bool isUser;
}
