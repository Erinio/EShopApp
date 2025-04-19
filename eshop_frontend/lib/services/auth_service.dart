import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/user.dart';

class AuthService {
  static const String _loginEndpoint = '/api/auth/login';
  static const String _signupEndpoint = '/api/auth/signup';

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.baseUrl + _loginEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 0) {
        throw Exception('Network error, please try again later.');
      }

      // Try to parse as JSON, if fails, treat as plain text
      try {
        final responseData = json.decode(response.body);
        if (response.statusCode == 200) {
          return {
            'token': responseData['token'],
            'user': User.fromJson(responseData['user']),
          };
        } else {
          throw Exception(responseData['message'] ?? 'An error occurred');
        }
      } catch (e) {
        // If JSON parsing fails, use the raw response body as the error message
        throw Exception(response.body.trim());
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Failed to login: $e');
    }
  }

  Future<User> signup(String username, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.baseUrl + _signupEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      try {
        final responseData = json.decode(response.body);
        if (response.statusCode == 200) {
          return User.fromJson(responseData);
        } else {
          throw Exception(responseData['message'] ?? 'An error occurred');
        }
      } catch (e) {
        throw Exception(response.body.trim());
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Failed to signup: $e');
    }
  }
}
