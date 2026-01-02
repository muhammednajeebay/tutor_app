import 'package:tutor_app/core/utils/logger.dart';
import 'package:tutor_app/data/models/video_details_model.dart';
import 'package:tutor_app/data/services/api_service.dart';

/// Abstract repository for video data
abstract class VideoRepository {
  Future<VideoDetailsModel> getVideoDetails({bool forceRefresh = false});
}

/// Implementation of video repository with caching
class VideoRepositoryImpl implements VideoRepository {
  final ApiService _apiService;

  VideoDetailsModel? _cachedData;
  DateTime? _cacheTime;
  static const Duration _cacheDuration = Duration(minutes: 5);

  VideoRepositoryImpl(this._apiService);

  @override
  Future<VideoDetailsModel> getVideoDetails({bool forceRefresh = false}) async {
    try {
      // Check if we have valid cached data
      if (!forceRefresh && _cachedData != null && _cacheTime != null) {
        final cacheAge = DateTime.now().difference(_cacheTime!);
        if (cacheAge < _cacheDuration) {
          AppLogger.info(
            'Returning cached data (age: ${cacheAge.inSeconds}s)',
            tag: 'VideoRepo',
          );
          return _cachedData!;
        } else {
          AppLogger.info(
            'Cache expired, fetching fresh data',
            tag: 'VideoRepo',
          );
        }
      }

      // Fetch fresh data
      AppLogger.info('Fetching video details from API', tag: 'VideoRepo');
      final data = await _apiService.getVideoDetails();

      // Update cache
      _cachedData = data;
      _cacheTime = DateTime.now();

      AppLogger.success('Video details cached successfully', tag: 'VideoRepo');
      return data;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to get video details',
        tag: 'VideoRepo',
        error: e,
        stackTrace: stackTrace,
      );

      // Return cached data if available, even if expired
      if (_cachedData != null) {
        AppLogger.warning(
          'Returning stale cached data due to error',
          tag: 'VideoRepo',
        );
        return _cachedData!;
      }

      rethrow;
    }
  }

  /// Clear the cache
  void clearCache() {
    AppLogger.info('Clearing video details cache', tag: 'VideoRepo');
    _cachedData = null;
    _cacheTime = null;
  }
}
