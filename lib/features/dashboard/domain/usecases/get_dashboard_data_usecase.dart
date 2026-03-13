import '../entities/dashboard_data.dart';
import '../repositories/dashboard_repository.dart';

/// Use case: fetch combined dashboard data (profile, metrics, active task, tasks).
class GetDashboardDataUseCase {
  const GetDashboardDataUseCase(this._repository);

  final DashboardRepository _repository;

  Future<DashboardData> call() => _repository.getDashboardData();
}
