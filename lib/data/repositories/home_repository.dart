import 'package:tutor_app/core/utils/logger.dart';
import 'package:tutor_app/data/models/home_model.dart';
import 'package:tutor_app/data/services/home_api_service.dart';

/// Abstract repository for home data
abstract class HomeRepository {
  Future<HomeModel> getHomeData({bool forceRefresh = false});
}

/// Implementation of home repository with caching
class HomeRepositoryImpl implements HomeRepository {
  final HomeApiService _apiService;

  HomeModel? _cachedData;
  DateTime? _cacheTime;
  static const Duration _cacheDuration = Duration(minutes: 5);

  HomeRepositoryImpl(this._apiService);

  @override
  Future<HomeModel> getHomeData({bool forceRefresh = false}) async {
    try {
      // Check if we have valid cached data
      if (!forceRefresh && _cachedData != null && _cacheTime != null) {
        final cacheAge = DateTime.now().difference(_cacheTime!);
        if (cacheAge < _cacheDuration) {
          AppLogger.info(
            'Returning cached data (age: ${cacheAge.inSeconds}s)',
            tag: 'HomeRepo',
          );
          return _cachedData!;
        } else {
          AppLogger.info('Cache expired, fetching fresh data', tag: 'HomeRepo');
        }
      }

      // Fetch fresh data
      AppLogger.info('Fetching home data from API', tag: 'HomeRepo');
      final data = await _apiService.fetchHomeData();

      // Update cache
      _cachedData = data;
      _cacheTime = DateTime.now();

      AppLogger.success('Home data cached successfully', tag: 'HomeRepo');
      return data;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to get home data',
        tag: 'HomeRepo',
        error: e,
        stackTrace: stackTrace,
      );

      // Return cached data if available, even if expired
      if (_cachedData != null) {
        AppLogger.warning(
          'Returning stale cached data due to error',
          tag: 'HomeRepo',
        );
        return _cachedData!;
      }

      rethrow;
    }
  }

  /// Clear the cache
  void clearCache() {
    AppLogger.info('Clearing home data cache', tag: 'HomeRepo');
    _cachedData = null;
    _cacheTime = null;
  }
}
