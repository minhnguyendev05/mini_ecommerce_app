import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class BannerSlider extends StatefulWidget {
  const BannerSlider({super.key});

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  int _currentIndex = 0;

  static const List<String> _banners = <String>[
    'https://wsrv.nl/?url=https://magiamgiashopee.vn/wp-content/uploads/2024/03/shopee-3.3.webp&output=jpg',
    'https://wsrv.nl/?url=https://magiamgia.com/wp-content/uploads/2025/02/Bloggiamgia-1000-x-500-px-1.webp&output=jpg',
    'https://wsrv.nl/?url=https://images.bloggiamgia.vn/01-03-2026/Shopee-3-1772357636649.webp&output=jpg',
    'https://wsrv.nl/?url=https://images.bloggiamgia.vn/01-03-2026/Shopee-3-1772358568657.webp&output=jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            viewportFraction: 1,
            enlargeCenterPage: false,
            height: 182,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: _banners.map((url) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      url,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.teal.shade100,
                          alignment: Alignment.center,
                          child: const Icon(Icons.image_not_supported_outlined),
                        );
                      },
                    ),
                    Container(
                      color: Colors.black26,
                      alignment: Alignment.bottomLeft,
                      padding: const EdgeInsets.all(16),
                      child: const Text(
                        'Ưu đãi hôm nay',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List<Widget>.generate(_banners.length, (index) {
            final bool isActive = _currentIndex == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: isActive ? 18 : 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: isActive ? Colors.teal : Colors.teal.shade100,
                borderRadius: BorderRadius.circular(6),
              ),
            );
          }),
        ),
      ],
    );
  }
}
