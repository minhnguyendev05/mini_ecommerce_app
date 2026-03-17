import 'package:flutter/foundation.dart';

import '../models/product_model.dart';
import '../services/api_service.dart';

/// ProductProvider - Người 2 phụ trách
///
/// Chức năng:
/// - Fetch danh sách sản phẩm từ FakeStore API
/// - Quản lý trạng thái loading/error
/// - Pull to refresh
/// - Infinite scroll pagination
///
class ProductProvider extends ChangeNotifier {
  ProductProvider({ApiService? apiService})
    : _apiService = apiService ?? ApiService();

  static const int _pageSize = 6;

  final ApiService _apiService;
  final List<Product> _allProducts = <Product>[];
  final List<Product> _filteredProducts = <Product>[];
  final List<Product> _visibleProducts = <Product>[];
  Set<String> _categoryFilter = <String>{};

  bool _isInitialLoading = false;
  bool _isRefreshing = false;
  bool _isLoadingMore = false;
  String? _errorMessage;

  List<Product> get products => List<Product>.unmodifiable(_visibleProducts);
  bool get isInitialLoading => _isInitialLoading;
  bool get isRefreshing => _isRefreshing;
  bool get isLoadingMore => _isLoadingMore;
  String? get errorMessage => _errorMessage;
  bool get hasProducts => _visibleProducts.isNotEmpty;
  bool get hasMore => _visibleProducts.length < _filteredProducts.length;

  Future<void> fetchProducts({bool forceRefresh = false}) async {
    if (_isInitialLoading || _isRefreshing) {
      return;
    }

    if (_allProducts.isNotEmpty && !forceRefresh) {
      return;
    }

    _errorMessage = null;
    if (forceRefresh) {
      _isRefreshing = true;
    } else {
      _isInitialLoading = true;
    }
    notifyListeners();

    try {
      final fetched = await _apiService.fetchProducts();
      _allProducts
        ..clear()
        ..addAll(fetched);
      _applyCategoryFilter(resetVisible: true);
    } catch (_) {
      _errorMessage = 'Không thể tải sản phẩm. Vui lòng thử lại.';
    } finally {
      _isInitialLoading = false;
      _isRefreshing = false;
      notifyListeners();
    }
  }

  Future<void> refreshProducts() async {
    await fetchProducts(forceRefresh: true);
  }

  void setCategoryFilter(Set<String> categories) {
    final normalized = categories
        .map((category) => category.toLowerCase().trim())
        .toSet();

    if (setEquals(_categoryFilter, normalized)) {
      return;
    }

    _categoryFilter = normalized;
    _applyCategoryFilter(resetVisible: true);
    notifyListeners();
  }

  Future<void> loadMoreProducts() async {
    if (_isLoadingMore || _isInitialLoading || _isRefreshing || !hasMore) {
      return;
    }

    _isLoadingMore = true;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 350));

    final nextEndIndex = (_visibleProducts.length + _pageSize).clamp(
      0,
      _filteredProducts.length,
    );

    _visibleProducts
      ..clear()
      ..addAll(_filteredProducts.take(nextEndIndex));

    _isLoadingMore = false;
    notifyListeners();
  }

  void _applyCategoryFilter({required bool resetVisible}) {
    final source = _categoryFilter.isEmpty
        ? _allProducts
        : _allProducts.where((product) {
            return _categoryFilter.contains(product.category.toLowerCase());
          });

    _filteredProducts
      ..clear()
      ..addAll(source);

    if (!resetVisible) {
      return;
    }

    _visibleProducts
      ..clear()
      ..addAll(_filteredProducts.take(_pageSize));
  }
}
