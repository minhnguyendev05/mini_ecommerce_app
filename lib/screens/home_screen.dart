import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';
import '../widgets/banner_slider.dart';
import '../widgets/category_item.dart';
import '../widgets/product_card.dart';

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
    _CategoryData(
      label: 'Điện tử',
      icon: Icons.devices_other,
      apiCategories: <String>{'electronics'},
    ),
    _CategoryData(
      label: 'Trang sức',
      icon: Icons.diamond_outlined,
      apiCategories: <String>{'jewelery'},
    ),
    _CategoryData(
      label: 'Quần áo nam',
      icon: Icons.checkroom,
      apiCategories: <String>{"men's clothing"},
    ),
    _CategoryData(
      label: 'Quần áo nữ',
      icon: Icons.woman_2_outlined,
      apiCategories: <String>{"women's clothing"},
    ),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      final productProvider = context.read<ProductProvider>();
      productProvider.setCategoryFilter(
        _categories[_selectedCategoryIndex].apiCategories,
      );
      productProvider.fetchProducts();
    });
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

    if (_scrollController.position.extentAfter < 520) {
      context.read<ProductProvider>().loadMoreProducts();
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
    final productProvider = context.watch<ProductProvider>();
    final selectedCategory = _categories[_selectedCategoryIndex];

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: productProvider.refreshProducts,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            SliverAppBar(
              expandedHeight: 88,
              toolbarHeight: 72,
              pinned: true,
              elevation: 0,
              backgroundColor: appBarColor,
              titleSpacing: 12,
              title: Text(
                'TH4 - Nhóm 8',
                style: TextStyle(
                  color: ratio > 0.6 ? Colors.black87 : Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF00A59B), Color(0xFF26C6DA)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              actions: [
                Consumer<CartProvider>(
                  builder: (context, cartProvider, child) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: badges.Badge(
                        showBadge: cartProvider.totalQuantity > 0,
                        position: badges.BadgePosition.topEnd(top: 2, end: 0),
                        badgeStyle: const badges.BadgeStyle(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 2,
                          ),
                        ),
                        badgeContent: Text(
                          '${cartProvider.totalQuantity}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        ),
                        child: IconButton(
                          onPressed: () => Navigator.pushNamed(context, '/cart'),
                          icon: Icon(
                            Icons.shopping_cart_outlined,
                            color: ratio > 0.6 ? Colors.black87 : Colors.white,
                          ),
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
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1.9,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final item = _categories[index];
                  return CategoryItem(
                    label: item.label,
                    icon: item.icon,
                    isSelected: _selectedCategoryIndex == index,
                    onTap: () {
                      setState(() {
                        _selectedCategoryIndex = index;
                      });
                      context.read<ProductProvider>().setCategoryFilter(
                        item.apiCategories,
                      );
                    },
                  );
                }, childCount: _categories.length),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Sản phẩm ${selectedCategory.label}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 8)),
            if (productProvider.isInitialLoading && !productProvider.hasProducts)
              const SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                sliver: _ProductGridSkeletonSliver(),
              )
            else if (productProvider.errorMessage != null &&
                !productProvider.hasProducts)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: _ProductErrorState(
                    message: productProvider.errorMessage!,
                    onRetry: () => productProvider.fetchProducts(forceRefresh: true),
                  ),
                ),
              )
            else if (!productProvider.hasProducts)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: _ProductEmptyState(
                    categoryName: selectedCategory.label,
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.62,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final product = productProvider.products[index];
                    return ProductCard(
                      product: product,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/productDetail',
                          arguments: product,
                        );
                      },
                      onAddToCart: () {
                        context.read<CartProvider>().addToCart(product);
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              content: Text('Đã thêm ${product.title} vào giỏ.'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                      },
                    );
                  }, childCount: productProvider.products.length),
                ),
              ),
            if (productProvider.isLoadingMore)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}

class _ProductGridSkeletonSliver extends StatelessWidget {
  const _ProductGridSkeletonSliver();

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.62,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 12,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                color: Colors.grey.shade300,
              ),
              const SizedBox(height: 6),
              Container(
                height: 12,
                width: 70,
                margin: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                color: Colors.grey.shade300,
              ),
            ],
          ),
        );
      }, childCount: 6),
    );
  }
}

class _ProductErrorState extends StatelessWidget {
  const _ProductErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(color: Colors.red.shade700),
          ),
          const SizedBox(height: 8),
          FilledButton.tonal(
            onPressed: onRetry,
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }
}

class _ProductEmptyState extends StatelessWidget {
  const _ProductEmptyState({required this.categoryName});

  final String categoryName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade100),
      ),
      child: Text(
        'Hiện chưa có sản phẩm cho danh mục $categoryName.',
        style: TextStyle(color: Colors.amber.shade900),
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
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
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
  double get maxExtent => 56;

  @override
  double get minExtent => 56;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class _CategoryData {
  const _CategoryData({
    required this.label,
    required this.icon,
    required this.apiCategories,
  });

  final String label;
  final IconData icon;
  final Set<String> apiCategories;
}
