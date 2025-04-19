import 'dart:io';

class ApiConfig {
  static String get baseUrl {
    // Use 10.0.2.2 for Android emulator, localhost for iOS and 127.0.0.1 for macOS
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8080';
    } else if (Platform.isMacOS) {
      return 'http://127.0.0.1:8080';
    }
    return 'http://localhost:8080';
  }

  static const String productsEndpoint = '/api/products';
  static const String categoriesEndpoint = '/api/categories';
  static const String addressesEndpoint = '/api/addresses';
  static const String ordersEndpoint = '/api/orders';

  // Add more endpoints as needed
  static String get productsUrl => baseUrl + productsEndpoint;
  static String get categoriesUrl => baseUrl + categoriesEndpoint;
  static String get addressesUrl => baseUrl + addressesEndpoint;
  static String get ordersUrl => baseUrl + ordersEndpoint;
}
