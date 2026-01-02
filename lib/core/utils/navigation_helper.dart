import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Navigation helper with custom transitions
class NavigationHelper {
  /// Navigate to a new page
  static Future<T?> to<T>(
    Widget page, {
    Transition? transition,
    Duration? duration,
  }) async {
    return Get.to<T>(
      () => page,
      transition: transition ?? Transition.rightToLeft,
      duration: duration ?? const Duration(milliseconds: 300),
    );
  }

  /// Navigate to a new page and remove the previous page
  static Future<T?> off<T>(
    Widget page, {
    Transition? transition,
    Duration? duration,
  }) async {
    return Get.off<T>(
      () => page,
      transition: transition ?? Transition.rightToLeft,
      duration: duration ?? const Duration(milliseconds: 300),
    );
  }

  /// Navigate to a new page and remove all previous pages
  static Future<T?> offAll<T>(
    Widget page, {
    Transition? transition,
    Duration? duration,
  }) async {
    return Get.offAll<T>(
      () => page,
      transition: transition ?? Transition.rightToLeft,
      duration: duration ?? const Duration(milliseconds: 300),
    );
  }

  /// Navigate to a named route
  static Future<T?> toNamed<T>(
    String routeName, {
    dynamic arguments,
    Transition? transition,
  }) async {
    return Get.toNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  /// Navigate to a named route and remove the previous page
  static Future<T?> offNamed<T>(
    String routeName, {
    dynamic arguments,
    Transition? transition,
  }) async {
    return Get.offNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  /// Navigate to a named route and remove all previous pages
  static Future<T?> offAllNamed<T>(
    String routeName, {
    dynamic arguments,
    Transition? transition,
  }) async {
    return Get.offAllNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  /// Go back to the previous page
  static void back<T>({T? result}) {
    Get.back<T>(result: result);
  }

  /// Check if can go back
  static bool canGoBack() {
    return Navigator.canPop(Get.context!);
  }
}
