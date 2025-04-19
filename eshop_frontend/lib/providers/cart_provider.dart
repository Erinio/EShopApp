import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart.dart';
import '../services/cart_service.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../main.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class CartProvider with ChangeNotifier {
  CartService? _cartService;
  final Map<String, CartItem> _items = {};
  String? _userId;

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, item) {
      total += item.product.price * item.quantity;
    });
    return total;
  }

  Future<void> loadCart(String userId) async {
    try {
      _userId = userId;
      final authProvider = Provider.of<AuthProvider>(
        navigatorKey.currentContext!,
        listen: false,
      );

      _cartService = CartService(authToken: authProvider.token);
      final cartData = await _cartService?.getCart(userId);

      if (cartData != null) {
        _items.clear();
        for (var item in cartData.items) {
          // You'll need to fetch product details or store them in the cart
          // This is a simplified version
          _items[item.productId] = CartItem(
            product: Product(
              id: item.productId,
              name: '', // You might want to fetch these details
              description: '',
              price: item.price,
              imageUrl: '',
              category: '',
            ),
            quantity: item.quantity,
          );
        }
      }
      notifyListeners();
    } catch (e) {
      print('Error loading cart: $e');
    }
  }

  Future<void> addItem(Product product) async {
    final authProvider = Provider.of<AuthProvider>(
      navigatorKey.currentContext!,
      listen: false,
    );

    if (authProvider.userId == null) return;

    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (existing) => CartItem(
          product: existing.product,
          quantity: existing.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItem(product: product),
      );
    }

    _userId = authProvider.userId;
    await _updateCartOnServer();
    notifyListeners();
  }

  Future<void> removeItem(String productId) async {
    if (_userId == null) return;

    _items.remove(productId);
    await _updateCartOnServer();
    notifyListeners();
  }

  Future<void> clear() async {
    if (_userId == null) return;

    _items.clear();
    await _updateCartOnServer();
    notifyListeners();
  }

  Future<void> _updateCartOnServer() async {
    if (_userId == null || _cartService == null) return;

    try {
      final cartData = CartData(
        userId: _userId!,
        items: _items.entries
            .map((entry) => CartItemData(
                  productId: entry.key,
                  quantity: entry.value.quantity,
                  price: entry.value.product.price,
                ))
            .toList(),
        total: totalAmount,
      );

      await _cartService!.updateCart(cartData);
    } catch (e) {
      print('Error updating cart: $e');
    }
  }
}
