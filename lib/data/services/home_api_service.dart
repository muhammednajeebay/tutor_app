import 'package:tutor_app/core/network/api_client.dart';
import 'package:tutor_app/core/utils/logger.dart';
import 'package:tutor_app/data/models/home_model.dart';

/// API service for home screen data using ApiClient
class HomeApiService {
  final ApiClient _apiClient;

  HomeApiService(this._apiClient);

  /// Fetch home screen data from API
  Future<HomeModel> fetchHomeData() async {
    try {
      AppLogger.api('Fetching home data', tag: 'HomeAPI');

      final response = await _apiClient.get('home.php');
      final homeModel = HomeModel.fromJson(response);

      AppLogger.success('Home data fetched successfully', tag: 'HomeAPI');
      return homeModel;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error fetching home data',
        tag: 'HomeAPI',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
