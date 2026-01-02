import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:tutor_app/core/widgets/empty_widget.dart';
import 'package:tutor_app/core/widgets/error_widget.dart';
import 'package:tutor_app/core/widgets/loading_widget.dart';
import 'package:tutor_app/features/home/controllers/home_controller.dart';
import 'package:tutor_app/features/home/widgets/active_course_card.dart';
import 'package:tutor_app/features/home/widgets/community_card.dart';
import 'package:tutor_app/features/home/widgets/course_category_tabs.dart';
import 'package:tutor_app/features/home/widgets/course_grid.dart';
import 'package:tutor_app/features/home/widgets/header_card.dart';
import 'package:tutor_app/features/home/widgets/hero_banner_carousel.dart';
import 'package:tutor_app/features/home/widgets/live_session_card.dart';
import 'package:tutor_app/features/home/widgets/support_section.dart';
import 'package:tutor_app/features/home/widgets/testimonial_carousel.dart';
import 'package:tutor_app/utils/const/app_colors.dart';
import 'package:tutor_app/utils/const/app_sizes.dart';
import 'package:tutor_app/utils/const/app_textstyles.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Obx(() {
        // Loading state
        if (controller.isLoading.value) {
          return const LoadingWidget();
        }

        // Error state
        if (controller.hasError.value) {
          return ErrorStateWidget(
            message: controller.errorMessage.value,
            onRetry: () => controller.fetchHomeData(forceRefresh: true),
          );
        }

        // Success state
        final homeData = controller.homeData.value;
        if (homeData == null) {
          return const EmptyStateWidget(message: 'No data available');
        }

        // Main content with pull-to-refresh
        return RefreshIndicator(
          onRefresh: controller.refreshData,
          color: AppColors.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderCard(homeData: homeData),

                const Gap(10),

                // Hero Banner Carousel
                if (homeData.heroBanners != null &&
                    homeData.heroBanners!.isNotEmpty)
                  HeroBannerCarousel(banners: homeData.heroBanners!),

                const Gap(AppSizes.marginL),

                // Active Courses Section
                if (homeData.activeCourse != null) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingM,
                    ),
                    child: Text('Active Courses', style: AppTextStyles.h4),
                  ),
                  const Gap(AppSizes.marginS),
                  ActiveCourseCard(course: homeData.activeCourse!),
                  const Gap(AppSizes.marginL),
                ],

                // Popular Courses Section
                if (homeData.popularCourses != null &&
                    homeData.popularCourses!.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingM,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Popular Courses', style: AppTextStyles.h4),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'View all',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(AppSizes.marginS),
                  CourseCategoryTabs(
                    categories: homeData.popularCourses!,
                    selectedIndex: controller.selectedCategoryIndex.value,
                    onCategorySelected: controller.selectCourseCategory,
                  ),
                  const Gap(AppSizes.paddingM),
                  CourseGrid(courses: controller.selectedCategoryCourses),
                  const Gap(AppSizes.marginL),
                ],

                // Live Session Section
                if (homeData.liveSession != null) ...[
                  LiveSessionCard(session: homeData.liveSession!),
                  const Gap(AppSizes.marginL),
                ],

                // Community Section
                if (homeData.community != null) ...[
                  CommunityCard(community: homeData.community!),
                  const Gap(AppSizes.marginL),
                ],

                // Testimonials Section
                if (homeData.testimonials != null &&
                    homeData.testimonials!.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingM,
                    ),
                    child: Text(
                      'What Learners Are Saying',
                      style: AppTextStyles.h4,
                    ),
                  ),
                  const Gap(AppSizes.marginS),
                  TestimonialCarousel(testimonials: homeData.testimonials!),
                  const Gap(AppSizes.marginL),
                ],

                // Support Section
                if (homeData.support != null) ...[
                  SupportSection(support: homeData.support!),
                  const Gap(AppSizes.marginXL),
                ],
              ],
            ),
          ),
        );
      }),
    );
  }
}
