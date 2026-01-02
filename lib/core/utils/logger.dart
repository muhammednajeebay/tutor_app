import 'dart:developer' as developer;

/// Colored console logger for debugging
class AppLogger {
  // ANSI escape codes for colors
  static const String _reset = '\x1B[0m';
  static const String _red = '\x1B[31m';
  static const String _green = '\x1B[32m';
  static const String _yellow = '\x1B[33m';
  static const String _blue = '\x1B[34m';
  static const String _cyan = '\x1B[36m';
  static const String _magenta = '\x1B[35m';

  /// Log info message in cyan
  static void info(String message, {String? tag}) {
    final tagStr = tag != null ? '[$tag] ' : '';
    developer.log('$_cyan$tagStr$message$_reset', name: 'INFO');
    print('$_cyan[INFO] $tagStr$message$_reset');
  }

  /// Log success message in green
  static void success(String message, {String? tag}) {
    final tagStr = tag != null ? '[$tag] ' : '';
    developer.log('$_green$tagStr$message$_reset', name: 'SUCCESS');
    print('$_green[SUCCESS] $tagStr$message$_reset');
  }

  /// Log warning message in yellow
  static void warning(String message, {String? tag}) {
    final tagStr = tag != null ? '[$tag] ' : '';
    developer.log('$_yellow$tagStr$message$_reset', name: 'WARNING');
    print('$_yellow[WARNING] $tagStr$message$_reset');
  }

  /// Log error message in red with optional error object
  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final tagStr = tag != null ? '[$tag] ' : '';
    final errorStr = error != null ? '\nError: $error' : '';
    final stackStr = stackTrace != null ? '\nStack: $stackTrace' : '';

    developer.log(
      '$_red$tagStr$message$errorStr$stackStr$_reset',
      name: 'ERROR',
      error: error,
      stackTrace: stackTrace,
    );
    print('$_red[ERROR] $tagStr$message$errorStr$_reset');
  }

  /// Log debug message in blue
  static void debug(String message, {String? tag}) {
    final tagStr = tag != null ? '[$tag] ' : '';
    developer.log('$_blue$tagStr$message$_reset', name: 'DEBUG');
    print('$_blue[DEBUG] $tagStr$message$_reset');
  }

  /// Log API request in magenta
  static void api(String message, {String? tag}) {
    final tagStr = tag != null ? '[$tag] ' : '';
    developer.log('$_magenta$tagStr$message$_reset', name: 'API');
    print('$_magenta[API] $tagStr$message$_reset');
  }
}
