import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../errors/failures.dart';

/// HTTP client wrapper for making API requests
class ApiClient {
  static const String baseUrl = 'https://trogon.info/task/api/';
  static const Duration timeoutDuration = Duration(seconds: 30);

  /// Makes a GET request to the specified endpoint
  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');

      final response = await http.get(uri).timeout(timeoutDuration);

      return _handleResponse(response);
    } on TimeoutException {
      throw const NetworkFailure('Request timeout. Please try again.');
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        throw const NetworkFailure('No internet connection');
      }
      if (e is Failure) {
        rethrow;
      }
      throw UnexpectedFailure('Something went wrong: ${e.toString()}');
    }
  }

  /// Makes a POST request to the specified endpoint
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');

      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(timeoutDuration);

      return _handleResponse(response);
    } on TimeoutException {
      throw const NetworkFailure('Request timeout. Please try again.');
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        throw const NetworkFailure('No internet connection');
      }
      if (e is Failure) {
        rethrow;
      }
      throw UnexpectedFailure('Something went wrong: ${e.toString()}');
    }
  }

  /// Handles HTTP response and throws appropriate failures
  Map<String, dynamic> _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        try {
          return jsonDecode(response.body) as Map<String, dynamic>;
        } catch (e) {
          throw const ServerFailure('Invalid JSON response');
        }
      case 400:
        throw const ServerFailure('Bad request');
      case 401:
        throw const ServerFailure('Unauthorized');
      case 403:
        throw const ServerFailure('Forbidden');
      case 404:
        throw const ServerFailure('Not found');
      case 500:
        throw const ServerFailure('Internal server error');
      default:
        throw ServerFailure('Error: ${response.statusCode}');
    }
  }
}
