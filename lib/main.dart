import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutor_app/core/network/api_client.dart';
import 'package:tutor_app/core/services/storage_service.dart';
import 'package:tutor_app/core/theme/app_theme.dart';
import 'package:tutor_app/data/repositories/home_repository.dart';
import 'package:tutor_app/data/repositories/video_repository.dart';
import 'package:tutor_app/data/services/api_service.dart';
import 'package:tutor_app/data/services/home_api_service.dart';
import 'package:tutor_app/features/home/controllers/home_controller.dart';
import 'package:tutor_app/data/repositories/streak_repository.dart';
import 'package:tutor_app/features/streaks/controllers/streaks_controller.dart';
import 'package:tutor_app/features/streaks/screens/streaks_screen.dart';
import 'package:tutor_app/features/subject/controllers/subject_controller.dart';
import 'package:tutor_app/features/navigation/main_navigation_screen.dart';
import 'package:tutor_app/features/onboarding/screens/onboarding_screen.dart';
import 'package:tutor_app/features/subject/screens/subject_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetStorage
  await StorageService.init();

  // Register dependencies
  _registerDependencies();

  runApp(const MyApp());
}

void _registerDependencies() {
  // Register ApiClient
  Get.lazyPut<ApiClient>(() => ApiClient());

  // Register ApiService
  Get.lazyPut<ApiService>(() => ApiService(Get.find<ApiClient>()));

  // Register HomeController
  Get.lazyPut<HomeController>(
    () => HomeController(
      repository: HomeRepositoryImpl(HomeApiService(Get.find<ApiClient>())),
    ),
  );

  // Register SubjectController
  Get.lazyPut<SubjectController>(
    () => SubjectController(
      repository: VideoRepositoryImpl(Get.find<ApiService>()),
    ),
  );

  // Register StreaksController
  Get.lazyPut<StreaksController>(
    () => StreaksController(
      repository: StreakRepositoryImpl(Get.find<ApiService>()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if onboarding is complete
    final isOnboardingComplete = StorageService().isOnboardingComplete();

    return GetMaterialApp(
      title: 'Tutor App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: isOnboardingComplete
          ? const MainNavigationScreen()
          : const OnboardingScreen(),
      // Define named routes
      getPages: [
        GetPage(name: '/home', page: () => const MainNavigationScreen()),
        GetPage(name: '/onboarding', page: () => const OnboardingScreen()),
        GetPage(name: '/subject', page: () => const SubjectScreen()),
        GetPage(name: '/streaks', page: () => const StreaksScreen()),
      ],
    );
  }
}
