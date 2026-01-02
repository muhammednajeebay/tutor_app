import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:tutor_app/core/utils/logger.dart';
import 'package:tutor_app/data/models/video_details_model.dart';
import 'package:tutor_app/data/repositories/video_repository.dart';

class SubjectController extends GetxController {
  final VideoRepository _repository;

  SubjectController({required VideoRepository repository})
    : _repository = repository;

  // State
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final Rx<VideoDetailsModel?> videoDetails = Rx<VideoDetailsModel?>(null);
  final Rx<Video?> currentVideo = Rx<Video?>(null);
  final Rx<VideoPlayerController?> videoPlayerController =
      Rx<VideoPlayerController?>(null);
  final isVideoInitialized = false.obs;
  final isVideoPlaying = false.obs;
  final videoPlayerError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    AppLogger.info('SubjectController initialized', tag: 'SUBJECT');
    fetchVideoDetails();
  }

  Future<void> fetchVideoDetails({bool forceRefresh = false}) async {
    try {
      AppLogger.info('Fetching video details...', tag: 'SUBJECT');

      if (!forceRefresh) {
        isLoading.value = true;
        hasError.value = false;
      }

      final data = await _repository.getVideoDetails(
        forceRefresh: forceRefresh,
      );
      videoDetails.value = data;

      AppLogger.success('Video details loaded successfully', tag: 'SUBJECT');

      // // Auto-play first video if available
      if (data.videos?.videos != null && data.videos!.videos!.isNotEmpty) {
        final firstVideo = data.videos!.videos!.first;
        selectVideo(firstVideo);
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to load video details',
        tag: 'SUBJECT',
        error: e,
        stackTrace: stackTrace,
      );
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    AppLogger.info('Refreshing video details...', tag: 'SUBJECT');
    await fetchVideoDetails(forceRefresh: true);
  }

  bool _isValidHttpsVideo(String url) {
    final uri = Uri.tryParse(url);
    return uri != null && uri.scheme == 'https';
  }

  void selectVideo(Video video) {
    // Don't allow locked videos to be played
    if (video.status == 'locked') {
      AppLogger.warning(
        'Attempted to play locked video: ${video.title}',
        tag: 'SUBJECT',
      );
      return;
    }

    AppLogger.info('Selecting video: ${video.title}', tag: 'SUBJECT');
    currentVideo.value = video;

    if (video.videoUrl == null || video.videoUrl!.isEmpty) {
      videoPlayerError.value = 'Video URL missing';
      return;
    }

    // Validate HTTPS
    if (!_isValidHttpsVideo(video.videoUrl!)) {
      videoPlayerError.value =
          'Video is unavailable. Please update the app or try later.';
      AppLogger.error(
        'Blocked HTTP video URL: ${video.videoUrl}',
        tag: 'SUBJECT',
      );
      return;
    }

    _initializeVideoPlayer(video.videoUrl!);
  }

  Future<void> _initializeVideoPlayer(String videoUrl) async {
    try {
      await _disposeVideoPlayer();

      AppLogger.info('Initializing video player: $videoUrl', tag: 'SUBJECT');
      isVideoInitialized.value = false;
      videoPlayerError.value = '';

      final controller = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl),
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );
      videoPlayerController.value = controller;

      await controller.initialize();
      isVideoInitialized.value = true;

      controller.play();
      isVideoPlaying.value = true;

      controller.addListener(_videoPlayerListener);

      AppLogger.success('Video player initialized', tag: 'SUBJECT');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Video initialization failed',
        tag: 'SUBJECT',
        error: e,
        stackTrace: stackTrace,
      );

      videoPlayerError.value =
          'Unable to play this video. Please try again later.';
      isVideoInitialized.value = false;
    }
  }

  /// Video player listener
  void _videoPlayerListener() {
    final controller = videoPlayerController.value;
    if (controller != null) {
      isVideoPlaying.value = controller.value.isPlaying;
    }
  }

  /// Toggle play/pause
  void togglePlayPause() {
    final controller = videoPlayerController.value;
    if (controller == null || !isVideoInitialized.value) return;

    if (controller.value.isPlaying) {
      controller.pause();
      AppLogger.debug('Video paused', tag: 'SUBJECT');
    } else {
      controller.play();
      AppLogger.debug('Video playing', tag: 'SUBJECT');
    }
  }

  void seekTo(Duration position) {
    final controller = videoPlayerController.value;
    if (controller == null || !isVideoInitialized.value) return;

    controller.seekTo(position);
    AppLogger.debug('Seeking to: ${position.inSeconds}s', tag: 'SUBJECT');
  }

  Future<void> _disposeVideoPlayer() async {
    final controller = videoPlayerController.value;
    if (controller != null) {
      controller.removeListener(_videoPlayerListener);
      await controller.dispose();
      videoPlayerController.value = null;
      isVideoInitialized.value = false;
      isVideoPlaying.value = false;
      videoPlayerError.value = '';
      AppLogger.debug('Video player disposed', tag: 'SUBJECT');
    }
  }

  @override
  void onClose() {
    AppLogger.info('SubjectController disposed', tag: 'SUBJECT');
    _disposeVideoPlayer();
    super.onClose();
  }
}
