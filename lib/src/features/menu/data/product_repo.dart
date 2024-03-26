import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course/src/features/menu/model/product.dart';

final dio = Dio(BaseOptions(baseUrl: 'https://coffeeshop.academy.effective.band/api/v1'));

Future<List<Product>> fetchProducts({int categoryId = 0, int page = 0, int limit = 25}) async {
  final response = await dio.get('/products/?category=$categoryId&page=$page&limit=$limit');

  if (response.statusCode == 200) {
    final data = response.data!['data'].map((json) => Product.fromJson(json));
    final result = List<Product>.from(data);
    debugPrint('fetching products');
    return result;
  } else {
    throw Exception('Failed to load products');
  }
}
