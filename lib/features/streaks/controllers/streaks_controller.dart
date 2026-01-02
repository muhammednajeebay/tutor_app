import 'package:get/get.dart';
import 'package:tutor_app/core/utils/logger.dart';
import 'package:tutor_app/data/models/streak_model.dart';
import 'package:tutor_app/data/repositories/streak_repository.dart';

class StreaksController extends GetxController {
  final StreakRepository _repository;

  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final Rx<StreakModel?> streakData = Rx<StreakModel?>(null);

  StreaksController({required StreakRepository repository})
    : _repository = repository;

  @override
  void onInit() {
    super.onInit();
    fetchStreakData();
  }

  Future<void> fetchStreakData({bool forceRefresh = false}) async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final data = await _repository.getStreakData(forceRefresh: forceRefresh);

      // Process data to fill gaps and ensure valid day numbers
      if (data.days != null && data.days!.isNotEmpty) {
        // Sort days by dayNumber
        final sortedDays = List<Day>.from(data.days!)
          ..sort((a, b) => (a.dayNumber ?? 0).compareTo(b.dayNumber ?? 0));

        // Remove days with invalid day number
        sortedDays.removeWhere((d) => d.dayNumber == null || d.dayNumber! <= 0);

        if (sortedDays.isNotEmpty) {
          final firstDay = sortedDays.first.dayNumber!;
          final lastDay = sortedDays.last.dayNumber!;

          final List<Day> completeDays = [];

          // Fill gaps
          for (int i = firstDay; i <= lastDay; i++) {
            final existingDay = sortedDays.firstWhereOrNull(
              (d) => d.dayNumber == i,
            );
            if (existingDay != null) {
              completeDays.add(existingDay);
            } else {
              // Add placeholder for missing day
              completeDays.add(
                Day(
                  id: -1, // Dummy ID
                  dayNumber: i,
                  label: '',
                  isCompleted: false,
                  isCurrent: false,
                  topic: null,
                ),
              );
            }
          }

          streakData.value = data.copyWith(days: completeDays);
        } else {
          streakData.value = data;
        }
      } else {
        streakData.value = data;
      }
    } catch (e, s) {
      AppLogger.error(
        'Failed to load streak data',
        tag: 'STREAKS',
        error: e,
        stackTrace: s,
      );
      hasError.value = true;
      errorMessage.value = 'Failed to load progress details';
    } finally {
      isLoading.value = false;
    }
  }

  void retry() {
    fetchStreakData(forceRefresh: true);
  }
}
