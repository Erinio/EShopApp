import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/product.dart';

class ProductsService {
  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.productsUrl));

      if (response.statusCode == 200) {
        final List<dynamic> productsJson = json.decode(response.body);
        return productsJson
            .map((json) => Product(
                  id: json['id'],
                  name: json['name'],
                  description: json['description'],
                  price: json['price'].toDouble(),
                  imageUrl: json['imageUrl'],
                  category: json['category'],
                ))
            .toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      throw Exception('Error fetching products: $error');
    }
  }
}
