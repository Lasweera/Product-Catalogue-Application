import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductRepository {
  ProductRepository({http.Client? client}) : _client = client ?? http.Client();

  static const String _baseUrl = 'https://fakestoreapi.com';
  final http.Client _client;

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await _client
          .get(Uri.parse('$_baseUrl/products'))
          .timeout(const Duration(seconds: 12));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as List<dynamic>;
        return decoded
            .map((item) => Product.fromJson(item as Map<String, dynamic>))
            .toList();
      }

      throw ProductFetchException(
        'Server returned an error (status ${response.statusCode}).',
      );
    } on SocketException {
      throw const ProductFetchException(
        'No internet connection. Please check your network.',
      );
    } on TimeoutException {
      throw const ProductFetchException(
        'The request timed out. Please try again.',
      );
    } on FormatException {
      throw const ProductFetchException(
        'Received an unexpected response from the server.',
      );
    } on ProductFetchException {
      rethrow;
    } catch (_) {
      throw const ProductFetchException(
        'Something went wrong while loading products.',
      );
    }
  }
}

class ProductFetchException implements Exception {
  final String message;
  const ProductFetchException(this.message);

  @override
  String toString() => message;
}
