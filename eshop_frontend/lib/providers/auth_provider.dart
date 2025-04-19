import 'package:eshop_frontend/main.dart';
import 'package:eshop_frontend/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  final _storage = const FlutterSecureStorage();
  bool _isGuest = false;
  final _authService = AuthService();
  User? _user;

  bool get isGuest => _isGuest;
  bool get isAuth => _token != null || _isGuest;
  String? get token => _token;
  User? get user => _user;
  String? get userId => _user?.id;

  Future<void> login(String username, String password) async {
    try {
      final response = await _authService.login(username, password);
      _token = response['token'];
      _user = response['user'];
      await _storage.write(key: 'auth_token', value: _token);
      await _storage.write(key: 'user', value: _user?.username);

      // Initialize cart for logged in user
      if (_user?.id != null) {
        await Provider.of<CartProvider>(navigatorKey.currentContext!,
                listen: false)
            .loadCart(_user!.id!);
      }

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signup(String username, String email, String password) async {
    try {
      await _authService.signup(username, email, password);
      // After signup, login automatically
      await login(username, password);
    } catch (error) {
      rethrow;
    }
  }

  void continueAsGuest() {
    _isGuest = true;
    notifyListeners();
  }

  Future<void> logout() async {
    _token = null;
    _isGuest = false;
    await _storage.delete(key: 'auth_token');
    notifyListeners();
  }
}
