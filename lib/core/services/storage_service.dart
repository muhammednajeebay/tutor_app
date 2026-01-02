import 'package:get_storage/get_storage.dart';

/// Service to manage app storage using GetStorage
class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  static const String _onboardingKey = 'onboarding_complete';

  final _storage = GetStorage();

  /// Initialize GetStorage
  static Future<void> init() async {
    await GetStorage.init();
  }

  /// Check if onboarding has been completed
  bool isOnboardingComplete() {
    return _storage.read(_onboardingKey) ?? false;
  }

  /// Mark onboarding as complete
  Future<void> setOnboardingComplete(bool value) async {
    await _storage.write(_onboardingKey, value);
  }

  /// Clear all storage (useful for testing)
  Future<void> clearAll() async {
    await _storage.erase();
  }
}
