import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  ApiService._(); // prevent instantiation

  // --- Base URL ---
  // Replace this with your real backend URL when ready
  static const String _baseUrl = 'https://api.giftanusav.com/v1';

  // --- Default Headers ---
  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // --- GET request ---
  static Future<dynamic> get(String endpoint) async {
    try {
      final uri = Uri.parse('$_baseUrl/$endpoint');
      final response = await http.get(uri, headers: _headers);
      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }

  // --- POST request ---
  static Future<dynamic> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final uri = Uri.parse('$_baseUrl/$endpoint');
      final response = await http.post(
        uri,
        headers: _headers,
        body: json.encode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }

  // --- PUT request ---
  static Future<dynamic> put(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final uri = Uri.parse('$_baseUrl/$endpoint');
      final response = await http.put(
        uri,
        headers: _headers,
        body: json.encode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }

  // --- DELETE request ---
  static Future<dynamic> delete(String endpoint) async {
    try {
      final uri = Uri.parse('$_baseUrl/$endpoint');
      final response = await http.delete(uri, headers: _headers);
      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }

  // --- Handle Response ---
  static dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return json.decode(response.body);
      case 400:
        throw ApiException('Bad request: ${response.body}');
      case 401:
        throw ApiException('Unauthorized: Please log in again');
      case 403:
        throw ApiException('Forbidden: You do not have permission');
      case 404:
        throw ApiException('Not found: The resource does not exist');
      case 500:
        throw ApiException('Server error: Please try again later');
      default:
        throw ApiException('Unexpected error: ${response.statusCode}');
    }
  }
}

// --- Custom Exception ---
class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  @override
  String toString() => 'ApiException: $message';
}