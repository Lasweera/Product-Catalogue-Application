import 'package:flutter/foundation.dart';

import '../data/product_repository.dart';
import '../models/product.dart';

enum ProductLoadStatus { loading, loaded, error }

/// Holds the product catalogue state fetched from [ProductRepository]:
/// loading/error/loaded status, the product list, and any error message.
class ProductProvider extends ChangeNotifier {
  ProductProvider(this._repository);

  final ProductRepository _repository;

  ProductLoadStatus _status = ProductLoadStatus.loading;
  List<Product> _allProducts = [];
  String _searchQuery = '';
  String? _errorMessage;

  ProductLoadStatus get status => _status;
  String get searchQuery => _searchQuery;
  String? get errorMessage => _errorMessage;

  /// Products filtered by [searchQuery] (substring match on name,
  /// case-insensitive). Returns the full list when the query is empty.
  List<Product> get products {
    if (_searchQuery.trim().isEmpty) return _allProducts;
    final query = _searchQuery.trim().toLowerCase();
    return _allProducts
        .where((p) => p.name.toLowerCase().contains(query))
        .toList();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> loadProducts() async {
    _status = ProductLoadStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _allProducts = await _repository.fetchProducts();
      _status = ProductLoadStatus.loaded;
    } catch (e) {
      _status = ProductLoadStatus.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }
}