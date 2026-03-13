import '../repositories/dashboard_repository.dart';

/// Use case: mark the active task complete.
class CompleteActiveTaskUseCase {
  const CompleteActiveTaskUseCase(this._repository);

  final DashboardRepository _repository;

  Future<void> call(String taskId) => _repository.completeActiveTask(taskId);
}
