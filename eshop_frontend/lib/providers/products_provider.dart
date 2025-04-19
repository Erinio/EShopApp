import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/products_service.dart';
import '../services/category_service.dart';

class ProductsProvider with ChangeNotifier {
  final _productsService = ProductsService();
  final _categoryService = CategoryService();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Product> _products = [];
  List<String> _categories = [];
  String _selectedCategory = 'All';

  String get selectedCategory => _selectedCategory;

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> fetchCategories() async {
    try {
      _categories = await _categoryService.fetchCategories();
      notifyListeners();
    } catch (error) {
      print('Error fetching categories: $error');
    }
  }

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.wait([
        _productsService
            .fetchProducts()
            .then((products) => _products = products),
        fetchCategories(),
      ]);
    } catch (error) {
      print('Error fetching data: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Product> get products => [..._products];
  List<String> get categories => [..._categories];

  List<Product> getProductsByCategory(String category) {
    return _products.where((product) => product.category == category).toList();
  }

  List<Product> searchProducts(String query) {
    return _products
        .where((product) =>
            product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
