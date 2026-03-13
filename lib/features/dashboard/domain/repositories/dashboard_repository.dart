import '../entities/dashboard_data.dart';
import '../entities/task.dart';

/// Port for dashboard data and task actions.
/// Implemented in data layer; domain depends only on this interface.
abstract class DashboardRepository {
  /// Returns profile, metrics, active task, and task list.
  /// Throws on network/auth errors.
  Future<DashboardData> getDashboardData();

  /// Pauses the active task. Throws if task not found or not active.
  Future<void> pauseActiveTask(String taskId);

  /// Marks the active task complete. Throws if task not found or not active.
  Future<void> completeActiveTask(String taskId);

  /// Starts or resumes a task; returns the task. Throws if task not found.
  Future<Task> startTask(String taskId);

  /// Search tasks by query with optional status filter and pagination.
  Future<List<Task>> searchTasks(
    String query, {
    TaskStatus? status,
    int limit = 20,
    int offset = 0,
  });

  /// Filter tasks by status with pagination.
  Future<List<Task>> filterTasksByStatus(
    TaskStatus status, {
    int limit = 20,
    int offset = 0,
  });
}
