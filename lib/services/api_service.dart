import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product_model.dart';

class ApiService {
  static const String _baseUrl = 'https://fakestoreapi.com';

  Future<List<Product>> fetchProducts() async {
    final uri = Uri.parse('$_baseUrl/products');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load products: ${response.statusCode}');
    }

    final List<dynamic> rawProducts =
        jsonDecode(response.body) as List<dynamic>;
    return rawProducts
        .map((json) => Product.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
