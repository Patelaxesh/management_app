import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://dummyjson.com';

  Future<dynamic> get(String endpoint) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl$endpoint'))
          .timeout(const Duration(seconds: 10));

      return _handleResponse(response);
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }

      throw Exception('Please check your internet connection.');
    }
  }

  Future<dynamic> post(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl$endpoint'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 10));

      return _handleResponse(response);
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }

      throw Exception('Please check your internet connection.');
    }
  }

  dynamic _handleResponse(http.Response response) {
    dynamic data;

    if (response.body.isNotEmpty) {
      try {
        data = jsonDecode(response.body);
      } catch (_) {
        throw Exception('Invalid server response.');
      }
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    }

    if (data is Map<String, dynamic> && data['message'] != null) {
      throw Exception(data['message']);
    }

    switch (response.statusCode) {
      case 400:
        throw Exception('Bad request.');

      case 401:
        throw Exception('Unauthorized.');

      case 404:
        throw Exception('Resource not found.');

      case 500:
        throw Exception('Server error.');

      default:
        throw Exception('Request failed: ${response.statusCode}');
    }
  }
}
