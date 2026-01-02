import 'package:get/get.dart';
import 'package:tutor_app/core/utils/logger.dart';
import 'package:tutor_app/data/models/home_model.dart';
import 'package:tutor_app/data/repositories/home_repository.dart';

/// Controller for home screen
class HomeController extends GetxController {
  final HomeRepository _repository;

  HomeController({required HomeRepository repository})
    : _repository = repository;

  // State
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final Rx<HomeModel?> homeData = Rx<HomeModel?>(null);
  final selectedBannerIndex = 0.obs;
  final selectedCategoryIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    AppLogger.info('HomeController initialized', tag: 'HOME');
    fetchHomeData();
  }

  /// Fetch home data from repository
  Future<void> fetchHomeData({bool forceRefresh = false}) async {
    try {
      AppLogger.info('Fetching home data...', tag: 'HOME');

      if (!forceRefresh) {
        isLoading.value = true;
        hasError.value = false;
      }

      final data = await _repository.getHomeData(forceRefresh: forceRefresh);
      homeData.value = data;

      AppLogger.success('Home data loaded successfully', tag: 'HOME');
      AppLogger.debug(
        'Loaded ${data.heroBanners?.length ?? 0} banners, '
        '${data.popularCourses?.length ?? 0} course categories',
        tag: 'HOME',
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to load home data',
        tag: 'HOME',
        error: e,
        stackTrace: stackTrace,
      );
      hasError.value = true;
      errorMessage.value = 'Failed to load data. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh data (for pull-to-refresh)
  Future<void> refreshData() async {
    AppLogger.info('Refreshing home data...', tag: 'HOME');
    await fetchHomeData(forceRefresh: true);
  }

  /// Select banner by index
  void selectBanner(int index) {
    AppLogger.debug('Banner selected: $index', tag: 'HOME');
    selectedBannerIndex.value = index;
  }

  /// Select course category by index
  void selectCourseCategory(int index) {
    AppLogger.debug('Course category selected: $index', tag: 'HOME');
    selectedCategoryIndex.value = index;
  }

  /// Get selected category courses
  List<HeroBanner> get selectedCategoryCourses {
    if (homeData.value == null ||
        homeData.value!.popularCourses == null ||
        homeData.value!.popularCourses!.isEmpty) {
      return [];
    }

    if (selectedCategoryIndex.value >= homeData.value!.popularCourses!.length) {
      return [];
    }

    return homeData
            .value!
            .popularCourses![selectedCategoryIndex.value]
            .courses ??
        [];
  }

  @override
  void onClose() {
    AppLogger.info('HomeController disposed', tag: 'HOME');
    super.onClose();
  }
}
