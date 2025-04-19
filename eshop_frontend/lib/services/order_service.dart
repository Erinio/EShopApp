import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/order.dart';

class OrderService {
  final String? authToken;

  OrderService({this.authToken});

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (authToken != null) 'Authorization': 'Bearer $authToken',
      };

  Future<Map<String, dynamic>> createOrder(
      String userId, String shippingAddressId, String paymentMethod) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/orders'),
        headers: _headers,
        body: json.encode({
          'userId': userId,
          'shippingAddress': shippingAddressId,
          'paymentMethod': paymentMethod,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to create order');
      }
    } catch (e) {
      throw Exception('Error creating order: $e');
    }
  }

  Future<List<Order>> getUserOrders(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/orders/user/$userId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Order.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      throw Exception('Error fetching orders: $e');
    }
  }
}
