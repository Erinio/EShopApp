import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class CategoryService {
  Future<List<String>> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.categoriesUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((category) => category['name'].toString()).toList();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (error) {
      throw Exception('Error fetching categories: $error');
    }
  }
}
