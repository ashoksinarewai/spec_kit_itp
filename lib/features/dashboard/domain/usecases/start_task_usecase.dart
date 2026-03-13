import '../entities/task.dart';
import '../repositories/dashboard_repository.dart';

/// Use case: start or resume a task; returns the started task.
class StartTaskUseCase {
  const StartTaskUseCase(this._repository);

  final DashboardRepository _repository;

  Future<Task> call(String taskId) => _repository.startTask(taskId);
}
