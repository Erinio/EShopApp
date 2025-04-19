import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/cart.dart';

class CartService {
  final String? authToken;

  CartService({this.authToken});

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (authToken != null) 'Authorization': 'Bearer $authToken',
      };

  Future<CartData> getCart(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/cart/$userId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return CartData.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load cart');
      }
    } catch (e) {
      throw Exception('Error fetching cart: $e');
    }
  }

  Future<CartData> updateCart(CartData cart) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/api/cart'),
        headers: _headers,
        body: json.encode(cart.toJson()),
      );

      if (response.statusCode == 200) {
        return CartData.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update cart: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error updating cart: $e');
    }
  }
}
