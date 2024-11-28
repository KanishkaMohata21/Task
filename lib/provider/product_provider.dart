import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product.dart';

Future<List<Product>> fetchProducts(int page, int limit) async {
  final response = await http.get(
    Uri.parse('https://dummyjson.com/products?limit=$limit&skip=${page * limit}'),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return (data['products'] as List)
        .map((product) => Product.fromJson(product))
        .toList();
  } else {
    throw Exception('Failed to load products');
  }
}

final productProvider = FutureProvider.family<List<Product>, int>((ref, page) async {
  return fetchProducts(page, 10); 
});
