import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../widgets/banner_slider.dart';
import '../widgets/category_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  double _offset = 0;
  int _selectedCategoryIndex = 0;

  static const List<_CategoryData> _categories = <_CategoryData>[
    _CategoryData(label: 'Thời trang', icon: Icons.checkroom),
    _CategoryData(label: 'Điện tử', icon: Icons.devices_other),
    _CategoryData(label: 'Gia dụng', icon: Icons.kitchen),
    _CategoryData(label: 'Mẹ & Bé', icon: Icons.child_friendly),
    _CategoryData(label: 'Sách', icon: Icons.menu_book),
    _CategoryData(label: 'Làm đẹp', icon: Icons.face_retouching_natural),
    _CategoryData(label: 'Thể thao', icon: Icons.sports_soccer),
    _CategoryData(label: 'Phụ kiện', icon: Icons.watch),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final nextOffset = _scrollController.offset;
    if ((nextOffset - _offset).abs() < 2) {
      return;
    }

    setState(() {
      _offset = nextOffset;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ratio = (_offset / 120).clamp(0.0, 1.0);
    final appBarColor = Color.lerp(Colors.transparent, Colors.white, ratio);

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 132,
            pinned: true,
            elevation: 0,
            backgroundColor: appBarColor,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 16, bottom: 12),
              title: Text(
                'TH4 - Nhóm 8',
                style: TextStyle(
                  color: ratio > 0.6 ? Colors.black87 : Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF00A59B), Color(0xFF26C6DA)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            actions: [
              Consumer<CartProvider>(
                builder: (_, cartProvider, __) {
                  return badges.Badge(
                    showBadge: cartProvider.totalQuantity > 0,
                    badgeContent: Text(
                      '${cartProvider.totalQuantity}',
                      style: const TextStyle(color: Colors.white, fontSize: 11),
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pushNamed(context, '/cart'),
                      icon: Icon(
                        Icons.shopping_cart_outlined,
                        color: ratio > 0.6 ? Colors.black87 : Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickySearchDelegate(),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          const SliverToBoxAdapter(child: BannerSlider()),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Danh mục nổi bật',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 10)),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 190,
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  mainAxisExtent: 88,
                ),
                itemBuilder: (_, index) {
                  final item = _categories[index];
                  return CategoryItem(
                    label: item.label,
                    icon: item.icon,
                    isSelected: _selectedCategoryIndex == index,
                    onTap: () {
                      setState(() {
                        _selectedCategoryIndex = index;
                      });
                    },
                  );
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Khu vực sản phẩm (Người 2 phụ trách)',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Placeholder cho Product Grid + Pull to Refresh + Infinite Scroll.',
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

class _StickySearchDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: SearchBar(
        hintText: 'Tìm kiếm sản phẩm, danh mục...',
        leading: const Icon(Icons.search),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        elevation: const WidgetStatePropertyAll(0),
      ),
    );
  }

  @override
  double get maxExtent => 66;

  @override
  double get minExtent => 66;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class _CategoryData {
  const _CategoryData({required this.label, required this.icon});

  final String label;
  final IconData icon;
}
