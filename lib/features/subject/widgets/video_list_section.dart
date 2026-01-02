import 'package:flutter/material.dart';
import 'package:tutor_app/data/models/video_details_model.dart';
import 'package:tutor_app/features/subject/widgets/video_list_item.dart';
import 'package:tutor_app/utils/const/app_colors.dart';
import 'package:tutor_app/utils/const/app_sizes.dart';

/// Video list section with title and items
class VideoListSection extends StatelessWidget {
  final String title;
  final List<Video> videos;
  final Function(Video) onVideoTap;

  const VideoListSection({
    super.key,
    required this.title,
    required this.videos,
    required this.onVideoTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFE0F2F2), // Light teal background
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSizes.radiusXXL),
          topRight: Radius.circular(AppSizes.radiusXXL),
        ),
      ),
      padding: const EdgeInsets.all(AppSizes.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: AppSizes.marginL),

          // Video list
          ...videos.asMap().entries.map((entry) {
            final index = entry.key;
            final video = entry.value;
            final isLast = index == videos.length - 1;

            return VideoListItem(
              video: video,
              isLast: isLast,
              onTap: () => onVideoTap(video),
            );
          }).toList(),
        ],
      ),
    );
  }
}
