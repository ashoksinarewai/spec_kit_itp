import '../repositories/dashboard_repository.dart';

/// Use case: pause the active task.
class PauseActiveTaskUseCase {
  const PauseActiveTaskUseCase(this._repository);

  final DashboardRepository _repository;

  Future<void> call(String taskId) => _repository.pauseActiveTask(taskId);
}
