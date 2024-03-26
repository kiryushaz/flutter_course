import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course/src/features/menu/model/category.dart';

final dio = Dio(BaseOptions(baseUrl: 'https://coffeeshop.academy.effective.band/api/v1'));

Future<List<Category>> fetchCategories({int page = 0, int limit = 25}) async {
  final response = await dio.get('/products/categories?page=$page&limit=$limit');

  if (response.statusCode == 200) {
    final data = response.data!['data'].map((json) => Category.fromJson(json));
    final result = List<Category>.from(data);
    debugPrint('fetching categories');
    return result;
  } else {
    throw Exception('Failed to load categories');
  }
}
