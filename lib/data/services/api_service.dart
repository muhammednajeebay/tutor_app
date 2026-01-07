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
  static const String saveProgressEndpoint = 'save_progress.php';
  static const String streakEndpoint = 'streak.php';
  static const String userId = 'user_id=8';

  ApiService(this._apiClient);

  /// Fetches home screen data
  Future<HomeModel> getHomeData() async {
    final response = await _apiClient.get(homeEndpoint);
    return HomeModel.fromJson(response);
  }

  /// Fetches video details
  Future<VideoDetailsModel> getVideoDetails() async {
    final response = await _apiClient.get("$videoDetailsEndpoint?$userId");
    return VideoDetailsModel.fromJson(response);
  }

  /// Save Video Progress &video_id=1&total_duration=600&user_progress=240
  Future<String> saveProgress({
    required int videoId,
    required int totalDuration,
    required int userProgress,
  }) async {
    final response = await _apiClient.get(
      "$saveProgressEndpoint?$userId&video_id=$videoId&total_duration=$totalDuration&user_progress=$userProgress",
    );
    return response['message'];
  }

  /// Fetches streak data
  Future<StreakModel> getStreakData() async {
    final response = await _apiClient.get(streakEndpoint);
    return StreakModel.fromJson(response);
  }
}
