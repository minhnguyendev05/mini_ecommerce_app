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
  bool _hasReachedApiEnd = false;

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
  bool get hasMore =>
      _visibleProducts.length < _filteredProducts.length || !_hasReachedApiEnd;

  Future<void> fetchProducts({bool forceRefresh = false}) async {
    if (_isInitialLoading || _isRefreshing) {
      return;
    }

    if (_allProducts.isNotEmpty &&
        !forceRefresh &&
        _visibleProducts.isNotEmpty) {
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
      _allProducts.clear();
      _hasReachedApiEnd = false;
      await _loadMoreFromApi();
      _applyCategoryFilter(resetVisible: true);
      _appendVisiblePage();
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
    _appendVisiblePage();
    notifyListeners();
  }

  Future<void> loadMoreProducts() async {
    if (_isLoadingMore || _isInitialLoading || _isRefreshing || !hasMore) {
      return;
    }

    _isLoadingMore = true;
    notifyListeners();

    try {
      if (_visibleProducts.length >= _filteredProducts.length &&
          !_hasReachedApiEnd) {
        await _loadMoreFromApi();
        _applyCategoryFilter(resetVisible: false);
      }

      _appendVisiblePage();
    } catch (_) {
      _errorMessage = 'Không thể tải thêm sản phẩm. Vui lòng thử lại.';
    }

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

    _visibleProducts.clear();
  }

  Future<void> _loadMoreFromApi() async {
    final requestLimit = _allProducts.length + _pageSize;
    final fetched = await _apiService.fetchProducts(limit: requestLimit);

    if (fetched.length <= _allProducts.length) {
      _hasReachedApiEnd = true;
      return;
    }

    final existingIds = _allProducts.map((item) => item.id).toSet();
    for (final product in fetched) {
      if (!existingIds.contains(product.id)) {
        _allProducts.add(product);
      }
    }
  }

  void _appendVisiblePage() {
    final nextEndIndex = (_visibleProducts.length + _pageSize).clamp(
      0,
      _filteredProducts.length,
    );

    _visibleProducts
      ..clear()
      ..addAll(_filteredProducts.take(nextEndIndex));
  }
}
