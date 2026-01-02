import 'package:tutor_app/core/utils/logger.dart';
import 'package:tutor_app/data/models/streak_model.dart';
import 'package:tutor_app/data/services/api_service.dart';

/// Abstract repository for streak data
abstract class StreakRepository {
  Future<StreakModel> getStreakData({bool forceRefresh = false});
}

/// Implementation of streak repository with caching
class StreakRepositoryImpl implements StreakRepository {
  final ApiService _apiService;

  StreakModel? _cachedData;
  DateTime? _cacheTime;
  static const Duration _cacheDuration = Duration(minutes: 5);

  StreakRepositoryImpl(this._apiService);

  @override
  Future<StreakModel> getStreakData({bool forceRefresh = false}) async {
    try {
      // Check if we have valid cached data
      if (!forceRefresh && _cachedData != null && _cacheTime != null) {
        final cacheAge = DateTime.now().difference(_cacheTime!);
        if (cacheAge < _cacheDuration) {
          AppLogger.info(
            'Returning cached streak data (age: ${cacheAge.inSeconds}s)',
            tag: 'StreakRepo',
          );
          return _cachedData!;
        } else {
          AppLogger.info(
            'Cache expired, fetching fresh streak data',
            tag: 'StreakRepo',
          );
        }
      }

      // Fetch fresh data
      AppLogger.info('Fetching streak data from API', tag: 'StreakRepo');
      // Note: Assuming ApiService has this method. If not, it needs to be added or this will fail.
      // Based on previous checks, ApiService has getStreakData().
      final data = await _apiService.getStreakData();

      // Update cache
      _cachedData = data;
      _cacheTime = DateTime.now();

      AppLogger.success('Streak data cached successfully', tag: 'StreakRepo');
      return data;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to get streak data',
        tag: 'StreakRepo',
        error: e,
        stackTrace: stackTrace,
      );

      // Return cached data if available, even if expired
      if (_cachedData != null) {
        AppLogger.warning(
          'Returning stale cached streak data due to error',
          tag: 'StreakRepo',
        );
        return _cachedData!;
      }

      rethrow;
    }
  }

  /// Clear the cache
  void clearCache() {
    AppLogger.info('Clearing streak data cache', tag: 'StreakRepo');
    _cachedData = null;
    _cacheTime = null;
  }
}
