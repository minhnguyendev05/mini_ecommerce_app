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
  String _searchQuery = '';

  static const List<_CategoryData> _categories = <_CategoryData>[
    _CategoryData(
      label: 'Tất cả',
      icon: Icons.apps,
      apiCategories: <String>{},
    ),
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
    _CategoryData(
      label: 'Gia dụng',
      icon: Icons.kitchen_outlined,
      apiCategories: <String>{'electronics', 'jewelery'},
    ),
    _CategoryData(
      label: 'Làm đẹp',
      icon: Icons.spa_outlined,
      apiCategories: <String>{'jewelery', "women's clothing"},
    ),
    _CategoryData(
      label: 'Phụ kiện',
      icon: Icons.watch_outlined,
      apiCategories: <String>{'jewelery', 'electronics'},
    ),
    _CategoryData(
      label: 'Nam giới',
      icon: Icons.sports_martial_arts_outlined,
      apiCategories: <String>{"men's clothing"},
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
productlist
    final ratio = (_offset / 120).clamp(0.0, 1.0);
    final appBarColor = Color.lerp(
      Colors.transparent,
      const Color(0xFF00A59B),
      ratio,

    final ratio = (_offset / 150).clamp(0.0, 1.0);
    final easedRatio = Curves.easeOutCubic.transform(ratio);
    final isForegroundDark = easedRatio < 0.5;
    final appBarColor = Color.lerp(
      const Color(0x0000A59B),
      const Color(0xFF00897B),
      easedRatio,
    );
    final appBarShadow = Color.lerp(
      const Color(0x00000000),
      const Color(0x29000000),
      easedRatio,
    );
    final appBarTopColor = Color.lerp(
      const Color(0x0000A59B),
      const Color(0xFF00897B),
      easedRatio,
    );
    final appBarBottomColor = Color.lerp(
      const Color(0x0026C6DA),
      const Color(0xFF00A59B),
      easedRatio,
main
    );
    final productProvider = context.watch<ProductProvider>();
    final selectedCategory = _categories[_selectedCategoryIndex];
    final displayedProducts =
        _searchQuery.trim().isEmpty
            ? productProvider.products
            : productProvider.products.where((product) {
              final normalizedQuery = _searchQuery.toLowerCase().trim();
              return product.title.toLowerCase().contains(normalizedQuery) ||
                  product.category.toLowerCase().contains(normalizedQuery);
            }).toList();

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
              expandedHeight: 152,
              toolbarHeight: 78,
              pinned: true,
              elevation: 0,
              shadowColor: appBarShadow,
              backgroundColor: appBarColor,
              titleSpacing: 12,
              title: Text(
                'TH4 - Nhóm 8',
                style: TextStyle(
productlist
                  color: Colors.white,
                  fontSize: 28,

                  color: isForegroundDark ? Colors.black87 : Colors.white,
                  fontSize: 26,
 main
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      appBarTopColor ?? const Color(0xFF00A59B),
                      appBarBottomColor ?? const Color(0xFF26C6DA),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(74),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                  child: _HomeSearchBar(
                    scrollProgress: easedRatio,
                    query: _searchQuery,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
              ),
              actions: [
                Consumer<CartProvider>(
                  builder: (context, cartProvider, child) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: badges.Badge(
                        showBadge: cartProvider.items.isNotEmpty,
                        position: badges.BadgePosition.topEnd(top: 2, end: 0),
                        badgeStyle: const badges.BadgeStyle(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 2,
                          ),
                        ),
                        badgeContent: Text(
                          '${cartProvider.items.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        ),
                        child: IconButton(
                          onPressed: () => Navigator.pushNamed(context, '/cart'),
                          icon: Icon(
                            Icons.shopping_cart_outlined,
 productlist
                            color: Colors.white,

                            color:
                                isForegroundDark ? Colors.black87 : Colors.white,
main
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 10)),
            const SliverToBoxAdapter(child: BannerSlider()),
            const SliverToBoxAdapter(child: SizedBox(height: 14)),
            SliverToBoxAdapter(
              child: Padding(
 productlist
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
                height: 132,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final tileWidth = (constraints.maxWidth - 24 - 8) / 2;

                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            mainAxisExtent: tileWidth,
                          ),
                      itemBuilder: (context, index) {
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
                      },
                    );
                  },

                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE8F8F6), Color(0xFFFFFFFF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFD7EEEB)),
                  ),
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.grid_view_rounded, size: 16),
                          SizedBox(width: 6),
                          Text(
                            'Danh mục nổi bật',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 148,
                        child: GridView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                mainAxisExtent: 108,
                                childAspectRatio: 1.7,
                              ),
                          itemBuilder: (context, index) {
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
                          },
                          itemCount: _categories.length,
                        ),
                      ),
                    ],
                  ),
 main
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    const Icon(Icons.local_fire_department, color: Colors.orange),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Gợi ý hôm nay • ${selectedCategory.label}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      '${displayedProducts.length} sản phẩm',
                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
            if (_searchQuery.trim().isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
                  child: Row(
                    children: [
                      Text(
                        'Kết quả cho "$_searchQuery"',
                        style: const TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                        child: const Text('Xóa lọc'),
                      ),
                    ],
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
            else if (displayedProducts.isEmpty)
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
                    childAspectRatio: 0.6,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final product = displayedProducts[index];
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
                  }, childCount: displayedProducts.length),
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

class _HomeSearchBar extends StatelessWidget {
  const _HomeSearchBar({
    required this.scrollProgress,
    required this.query,
    required this.onChanged,
  });

  final double scrollProgress;
  final String query;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final shellColor = Color.lerp(
      const Color(0x00007E75),
      const Color(0xCC007E75),
      scrollProgress,
    );
    final borderColor = Color.lerp(
      const Color(0x00000000),
      const Color(0xCCFFFFFF),
      scrollProgress,
    );
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: shellColor,
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(6),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor ?? const Color(0x4DFFFFFF)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1F000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: SearchBar(
          hintText: 'Tìm kiếm sản phẩm, danh mục...',
          leading: const Icon(Icons.search),
          trailing:
              query.isEmpty
                  ? null
                  : [
                    IconButton(
                      onPressed: () => onChanged(''),
                      icon: const Icon(Icons.close_rounded, size: 18),
                    ),
                  ],
          onChanged: onChanged,
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          elevation: const WidgetStatePropertyAll(0),
          backgroundColor: const WidgetStatePropertyAll(Colors.white),
        ),
      ),
    );
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
