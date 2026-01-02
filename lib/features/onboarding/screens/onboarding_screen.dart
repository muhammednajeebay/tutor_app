import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:tutor_app/core/services/storage_service.dart';
import 'package:tutor_app/core/widgets/primary_button.dart';
import 'package:tutor_app/core/widgets/text_button_custom.dart';
import 'package:tutor_app/features/onboarding/models/onboarding_model.dart';
import 'package:tutor_app/features/onboarding/widgets/page_indicator.dart';
import 'package:tutor_app/utils/const/app_colors.dart';
import 'package:tutor_app/utils/const/app_sizes.dart';
import 'package:tutor_app/utils/const/app_strings.dart';
import 'package:tutor_app/utils/const/app_textstyles.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingModel> _pages = const [
    OnboardingModel(
      title: AppStrings.onboardingTitle1,
      description: AppStrings.onboardingDesc1,
      imagePath: 'assets/images/onboarding_1.png',
    ),
    OnboardingModel(
      title: AppStrings.onboardingTitle2,
      description: AppStrings.onboardingDesc2,
      imagePath: 'assets/images/onboardng_2.png',
    ),
  ];

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(
          milliseconds: OnboardingConstants.pageTransitionDuration,
        ),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _skipOnboarding() {
    _finishOnboarding();
  }

  void _finishOnboarding() async {
    // Save onboarding completion
    await StorageService().setOnboardingComplete(true);

    // Navigate to home screen using GetX
    if (mounted) {
      Get.offAllNamed('/home');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      body: Center(
        child: Container(
          decoration: const BoxDecoration(color: AppColors.primary),
          clipBehavior: Clip.antiAlias,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return _OnboardingPage(
                page: _pages[index],
                currentPage: _currentPage,
                pageCount: _pages.length,
                onNext: _nextPage,
                onSkip: _skipOnboarding,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final OnboardingModel page;
  final int currentPage;
  final int pageCount;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const _OnboardingPage({
    required this.page,
    required this.currentPage,
    required this.pageCount,
    required this.onNext,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        // Image area
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: screenHeight * OnboardingConstants.imageAreaHeightRatio,
          child: Center(
            child: Image.asset(
              page.imagePath,
              fit: BoxFit.contain,
              height: screenHeight * OnboardingConstants.imageHeightRatio,
            ),
          ),
        ),

        // Content area
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: screenHeight * OnboardingConstants.contentAreaHeightRatio,
          child: Container(
            padding: const EdgeInsets.only(
              top: OnboardingConstants.containerTopPadding,
            ),
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(
                  OnboardingConstants.containerBorderRadius,
                ),
                topRight: Radius.circular(
                  OnboardingConstants.containerBorderRadius,
                ),
              ),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Circular icon with logo
                Positioned(
                  top: OnboardingConstants.iconTopOffset,
                  left: screenWidth / 2 - OnboardingConstants.iconCenterOffset,
                  child: Container(
                    width: OnboardingConstants.iconSize,
                    height: OnboardingConstants.iconSize,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.white,
                        width: OnboardingConstants.iconBorderWidth,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(
                        OnboardingConstants.iconPadding,
                      ),
                      child: SvgPicture.asset(
                        'assets/svg/logo.svg',
                        width: OnboardingConstants.logoSize,
                        height: OnboardingConstants.logoSize,
                        colorFilter: const ColorFilter.mode(
                          AppColors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),

                // Content
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: OnboardingConstants.contentHorizontalPadding,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        page.title,
                        style: AppTextStyles.h2.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: OnboardingConstants.titleFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Gap(OnboardingConstants.titleDescriptionGap),
                      Text(
                        page.description,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: OnboardingConstants.descriptionFontSize,
                          height: OnboardingConstants.descriptionLineHeight,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Gap(OnboardingConstants.descriptionIndicatorGap),
                      PageIndicator(
                        currentPage: currentPage,
                        pageCount: pageCount,
                      ),
                      const Gap(OnboardingConstants.indicatorButtonGap),
                      PrimaryButton(
                        text: AppStrings.next,
                        onPressed: onNext,
                        width: double.infinity,
                        height: OnboardingConstants.buttonHeight,
                      ),
                      const Gap(OnboardingConstants.buttonSkipGap),
                      TextButtonCustom(
                        text: AppStrings.skip,
                        onPressed: onSkip,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
