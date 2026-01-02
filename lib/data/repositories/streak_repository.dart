import '../models/streak_model.dart';
import '../services/api_service.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';

/// Repository for streak screen data
class StreakRepository {
  final ApiService _apiService;

  StreakRepository(this._apiService);

  /// Fetches streak data
  /// Returns Either<Failure, StreakModel>
  Future<Either<Failure, StreakModel>> getStreakData() async {
    try {
      final result = await _apiService.getStreakData();
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnexpectedFailure('Unexpected error: ${e.toString()}'));
    }
  }
}
