import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutor_app/core/services/storage_service.dart';
import 'package:tutor_app/core/theme/app_theme.dart';
import 'package:tutor_app/features/home/screens/home_screen.dart';
import 'package:tutor_app/features/onboarding/screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetStorage
  await StorageService.init();

  runApp(const MyApp());
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
      // Show home if onboarding complete, otherwise show onboarding
      home: isOnboardingComplete
          ? const HomeScreen()
          : const OnboardingScreen(),
      // Define named routes
      getPages: [
        GetPage(name: '/home', page: () => const HomeScreen()),
        GetPage(name: '/onboarding', page: () => const OnboardingScreen()),
      ],
    );
  }
}
