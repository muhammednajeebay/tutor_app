import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:tutor_app/features/subject/controllers/subject_controller.dart';
import 'package:tutor_app/utils/const/app_colors.dart';

/// Custom video player widget with controls
class VideoPlayerWidget extends GetView<SubjectController> {
  const VideoPlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final videoController = controller.videoPlayerController.value;
      final isInitialized = controller.isVideoInitialized.value;
      final hasError = controller.videoPlayerError.value.isNotEmpty;

      // Show error state if video failed to load
      if (hasError) {
        return _buildErrorState();
      }

      if (videoController == null || !isInitialized) {
        return _buildLoadingState();
      }

      return AspectRatio(
        aspectRatio: videoController.value.aspectRatio,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Video player
            VideoPlayer(videoController),

            // Play/Pause overlay
            _buildPlayPauseOverlay(),

            // Bottom controls
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBottomControls(videoController),
            ),
          ],
        ),
      );
    });
  }

  /// Loading state
  Widget _buildLoadingState() {
    return Container(
      height: 250,
      color: AppColors.black,
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.white),
      ),
    );
  }

  /// Error state
  Widget _buildErrorState() {
    return Container(
      height: 250,
      color: AppColors.grey900,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: AppColors.white, size: 48),
            const SizedBox(height: 16),
            Text(
              'Unable to load video',
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.videoPlayerError.value,
              style: const TextStyle(color: AppColors.grey400, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Play/Pause overlay
  Widget _buildPlayPauseOverlay() {
    return Obx(() {
      final isPlaying = controller.isVideoPlaying.value;

      return GestureDetector(
        onTap: controller.togglePlayPause,
        child: Container(
          color: Colors.transparent,
          child: Center(
            child: AnimatedOpacity(
              opacity: isPlaying ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  color: AppColors.white,
                  size: 48,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  /// Bottom controls with progress bar and time
  Widget _buildBottomControls(VideoPlayerController videoController) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black.withOpacity(0.7), Colors.transparent],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Progress bar
          VideoProgressIndicator(
            videoController,
            allowScrubbing: true,
            colors: VideoProgressColors(
              playedColor: AppColors.white,
              bufferedColor: AppColors.grey400,
              backgroundColor: AppColors.grey600,
            ),
          ),
          const SizedBox(height: 4),
          // Time display
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() {
                final position = videoController.value.position;
                return Text(
                  _formatDuration(position),
                  style: const TextStyle(color: AppColors.white, fontSize: 12),
                );
              }),
              Obx(() {
                final duration = videoController.value.duration;
                return Text(
                  _formatDuration(duration),
                  style: const TextStyle(color: AppColors.white, fontSize: 12),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  /// Format duration to mm:ss
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
