import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/address.dart';

class AddressService {
  final String? authToken;

  AddressService({this.authToken});

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (authToken != null) 'Authorization': 'Bearer $authToken',
      };

  Future<Address> addAddress(Address address) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/addresses'),
        headers: _headers,
        body: json.encode(address.toJson()),
      );

      if (response.statusCode == 200) {
        return Address.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to add address');
      }
    } catch (e) {
      throw Exception('Error adding address: $e');
    }
  }

  Future<List<Address>> getUserAddresses(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/addresses/user/$userId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Address.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load addresses');
      }
    } catch (e) {
      throw Exception('Error fetching addresses: $e');
    }
  }

  Future<Address> updateAddress(String id, Address address) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/api/addresses/$id'),
        headers: _headers,
        body: json.encode(address.toJson()),
      );

      if (response.statusCode == 200) {
        return Address.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Address not found');
      } else {
        throw Exception('Failed to update address');
      }
    } catch (e) {
      throw Exception('Error updating address: $e');
    }
  }

  Future<bool> deleteAddress(String id, String userId) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/api/addresses/$id?userId=$userId'),
        headers: _headers,
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error deleting address: $e');
    }
  }
}
