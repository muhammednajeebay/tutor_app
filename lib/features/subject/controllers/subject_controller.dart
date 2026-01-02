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

      // Auto-play first unlocked video if available
      if (data.videos?.videos != null && data.videos!.videos!.isNotEmpty) {
        // Find first unlocked video
        final firstUnlockedVideo = data.videos!.videos!.firstWhere(
          (v) => v.status != 'locked',
          orElse: () => data.videos!.videos!.first,
        );
        selectVideo(firstUnlockedVideo);
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to load video details',
        tag: 'SUBJECT',
        error: e,
        stackTrace: stackTrace,
      );
      hasError.value = true;
      errorMessage.value = 'Failed to load videos. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    AppLogger.info('Refreshing video details...', tag: 'SUBJECT');
    await fetchVideoDetails(forceRefresh: true);
  }

  void selectVideo(Video video) {
    // Don't allow locked videos to be played
    if (video.status == 'locked') {
      AppLogger.warning(
        'Attempted to play locked video: ${video.title}',
        tag: 'SUBJECT',
      );
      Get.snackbar(
        'Video Locked',
        'Complete previous videos to unlock this one',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    AppLogger.info('Selecting video: ${video.title}', tag: 'SUBJECT');
    currentVideo.value = video;

    if (video.videoUrl == null || video.videoUrl!.isEmpty) {
      videoPlayerError.value = 'Video URL missing';
      AppLogger.error('Video URL is null or empty', tag: 'SUBJECT');
      return;
    }

    // Log the actual URL being loaded
    AppLogger.info('Video URL: ${video.videoUrl}', tag: 'SUBJECT');

    _initializeVideoPlayer(video.videoUrl!);
  }

  Future<void> _initializeVideoPlayer(String videoUrl) async {
    try {
      await _disposeVideoPlayer();

      AppLogger.info('Initializing video player: $videoUrl', tag: 'SUBJECT');
      isVideoInitialized.value = false;
      videoPlayerError.value = '';

      // Parse and validate URL
      final uri = Uri.parse(videoUrl);
      AppLogger.info('Parsed URI: ${uri.toString()}', tag: 'SUBJECT');
      AppLogger.info('URI Scheme: ${uri.scheme}', tag: 'SUBJECT');
      AppLogger.info('URI Host: ${uri.host}', tag: 'SUBJECT');

      final controller = VideoPlayerController.networkUrl(
        uri,
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true,
          allowBackgroundPlayback: false,
        ),
        httpHeaders: {
          'Accept': '*/*',
          'Connection': 'keep-alive',
        },
      );

      videoPlayerController.value = controller;

      // Add timeout for initialization
      await controller.initialize().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Video initialization timeout');
        },
      );

      if (!controller.value.isInitialized) {
        throw Exception('Video controller failed to initialize');
      }

      isVideoInitialized.value = true;

      // Check if video has valid duration
      if (controller.value.duration == Duration.zero) {
        AppLogger.warning('Video has zero duration', tag: 'SUBJECT');
      }

      // Auto-play on initialization
      await controller.play();
      isVideoPlaying.value = true;

      controller.addListener(_videoPlayerListener);

      AppLogger.success(
        'Video player initialized successfully. Duration: ${controller.value.duration}',
        tag: 'SUBJECT',
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Video initialization failed',
        tag: 'SUBJECT',
        error: e,
        stackTrace: stackTrace,
      );

      String errorMessage = 'Unable to play this video.';
      
      if (e.toString().contains('timeout')) {
        errorMessage = 'Video loading timeout. Please check your connection.';
      } else if (e.toString().contains('Source error')) {
        errorMessage = 'Video file not found or corrupted.';
      } else if (e.toString().contains('NetworkError')) {
        errorMessage = 'Network error. Please check your internet connection.';
      }

      videoPlayerError.value = errorMessage;
      isVideoInitialized.value = false;
    }
  }

  void _videoPlayerListener() {
    final controller = videoPlayerController.value;
    if (controller != null) {
      isVideoPlaying.value = controller.value.isPlaying;

      // Log errors from video player
      if (controller.value.hasError) {
        AppLogger.error(
          'Video playback error: ${controller.value.errorDescription}',
          tag: 'SUBJECT',
        );
        videoPlayerError.value = 'Playback error occurred';
      }

      // Check if video ended
      if (controller.value.position >= controller.value.duration) {
        isVideoPlaying.value = false;
        AppLogger.info('Video playback completed', tag: 'SUBJECT');
      }
    }
  }

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
      await controller.pause();
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
