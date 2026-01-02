import '../models/home_model.dart';
import '../models/video_details_model.dart';
import '../models/streak_model.dart';
import '../../core/network/api_client.dart';

/// Service for handling all API calls
class ApiService {
  final ApiClient _apiClient;

  // API endpoints
  static const String homeEndpoint = 'home.php';
  static const String videoDetailsEndpoint = 'video_details.php';
  static const String streakEndpoint = 'streak.php';

  ApiService(this._apiClient);

  /// Fetches home screen data
  Future<HomeModel> getHomeData() async {
    final response = await _apiClient.get(homeEndpoint);
    return HomeModel.fromJson(response);
  }

  /// Fetches video details
  Future<VideoDetailsModel> getVideoDetails() async {
    final response = await _apiClient.get(videoDetailsEndpoint);
    return VideoDetailsModel.fromJson(response);
  }

  /// Fetches streak data
  Future<StreakModel> getStreakData() async {
    final response = await _apiClient.get(streakEndpoint);
    return StreakModel.fromJson(response);
  }
}
