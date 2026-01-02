import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:tutor_app/core/widgets/empty_widget.dart';
import 'package:tutor_app/core/widgets/error_widget.dart';
import 'package:tutor_app/core/widgets/loading_widget.dart';
import 'package:tutor_app/features/subject/controllers/subject_controller.dart';
import 'package:tutor_app/features/subject/widgets/video_list_section.dart';
import 'package:tutor_app/features/subject/widgets/video_player_widget.dart';
import 'package:tutor_app/utils/const/app_colors.dart';
import 'package:tutor_app/utils/const/app_sizes.dart';

/// Subject screen showing video player and video list
class SubjectScreen extends GetView<SubjectController> {
  const SubjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        // Loading state
        if (controller.isLoading.value) {
          return const LoadingWidget();
        }

        // Error state
        if (controller.hasError.value) {
          return ErrorStateWidget(
            message: controller.errorMessage.value,
            onRetry: () => controller.fetchVideoDetails(forceRefresh: true),
          );
        }

        // Success state
        final videoDetails = controller.videoDetails.value;
        if (videoDetails == null ||
            videoDetails.videos == null ||
            videoDetails.videos!.videos == null ||
            videoDetails.videos!.videos!.isEmpty) {
          return const EmptyStateWidget(message: 'No videos available');
        }

        final videos = videoDetails.videos!.videos!;
        final title = videoDetails.videos!.title ?? 'Videos';

        // Main content with pull-to-refresh
        return RefreshIndicator(
          onRefresh: controller.refreshData,
          color: AppColors.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Video player section
                Obx(() {
                  final currentVideo = controller.currentVideo.value;
                  if (currentVideo == null) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Video player
                      const VideoPlayerWidget(),

                      const Gap(AppSizes.marginM),

                      // Video info and download button
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.paddingM,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Video title
                            Text(
                              currentVideo.title ?? '',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),

                            const Gap(AppSizes.marginS),

                            // Video description
                            Text(
                              currentVideo.description ?? '',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),

                            const Gap(AppSizes.marginM),

                            // Download button
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.grey100,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.download,
                                color: AppColors.textPrimary,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Gap(AppSizes.marginL),
                    ],
                  );
                }),

                // Video list section
                VideoListSection(
                  title: title,
                  videos: videos,
                  onVideoTap: controller.selectVideo,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
