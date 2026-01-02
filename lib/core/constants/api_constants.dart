/// API configuration constants
class ApiConstants {
  // Base URL
  static const String baseUrl = 'http://trogon.info/task/api';

  // Endpoints
  static const String homeEndpoint = '/home';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Headers
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Full URLs
  static String get homeUrl => '$baseUrl$homeEndpoint';
}
