import '../models/active_task_model.dart';
import '../models/employee_profile_model.dart';
import '../models/task_model.dart';
import '../models/time_metrics_model.dart';
import '../../domain/entities/active_task.dart';
import '../../domain/entities/dashboard_data.dart';
import '../../domain/entities/employee_profile.dart';
import '../../domain/entities/task.dart';
import '../../domain/entities/time_metrics.dart';

/// Bidirectional mapping between dashboard DTOs and domain entities.
class DashboardMapper {
  const DashboardMapper();

  EmployeeProfile toEmployeeProfile(EmployeeProfileModel model) {
    return model.toEntity();
  }

  EmployeeProfileModel toEmployeeProfileModel(EmployeeProfile entity) {
    return EmployeeProfileModel(
      id: entity.id,
      displayName: entity.displayName,
      role: entity.role,
      onlineStatus: _onlineStatusToString(entity.onlineStatus),
      avatarUrl: entity.avatarUrl,
    );
  }

  TimeMetrics toTimeMetrics(TimeMetricsModel model) {
    return model.toEntity();
  }

  TimeMetricsModel toTimeMetricsModel(TimeMetrics entity) {
    return TimeMetricsModel(
      clockInTime: entity.clockInTime?.toIso8601String(),
      activeTimeSeconds: entity.activeTime.inSeconds,
      totalTimeAtWorkSeconds: entity.totalTimeAtWork.inSeconds,
      clockOutTime: entity.clockOutTime?.toIso8601String(),
    );
  }

  /// Maps TaskModel to Task or ActiveTask when [isActive] is true.
  Task toTask(TaskModel model) {
    if (model.isActive) {
      return toActiveTask(_taskModelToActiveTaskModel(model));
    }
    return model.toEntity();
  }

  ActiveTask toActiveTask(ActiveTaskModel model) {
    return model.toEntity();
  }

  TaskModel toTaskModel(Task entity) {
    return TaskModel(
      id: entity.id,
      projectName: entity.projectName,
      description: entity.description,
      status: _taskStatusToString(entity.status),
      isBillable: entity.isBillable,
      elapsedSeconds: entity.elapsedTime?.inSeconds,
      isActive: entity.isActive,
      startedAt: entity.startedAt?.toIso8601String(),
      completedAt: entity.completedAt?.toIso8601String(),
    );
  }

  ActiveTaskModel toActiveTaskModel(ActiveTask entity) {
    return ActiveTaskModel(
      id: entity.id,
      projectName: entity.projectName,
      description: entity.description,
      status: _taskStatusToString(entity.status),
      isBillable: entity.isBillable,
      elapsedSeconds: entity.elapsedTime?.inSeconds,
      isActive: true,
      startedAt: entity.startedAt?.toIso8601String(),
      completedAt: entity.completedAt?.toIso8601String(),
      isPaused: entity.isPaused,
    );
  }

  DashboardData toDashboardData({
    required EmployeeProfileModel profileModel,
    required TimeMetricsModel timeMetricsModel,
    ActiveTaskModel? activeTaskModel,
    required List<TaskModel> taskModels,
  }) {
    final profile = toEmployeeProfile(profileModel);
    final timeMetrics = toTimeMetrics(timeMetricsModel);
    final ActiveTask? activeTask = activeTaskModel != null
        ? toActiveTask(activeTaskModel)
        : null;
    final tasks = taskModels.map((m) => toTask(m)).toList();
    return DashboardData(
      profile: profile,
      timeMetrics: timeMetrics,
      activeTask: activeTask,
      tasks: tasks,
    );
  }

  static ActiveTaskModel _taskModelToActiveTaskModel(TaskModel m) {
    return ActiveTaskModel(
      id: m.id,
      projectName: m.projectName,
      description: m.description,
      status: m.status,
      isBillable: m.isBillable,
      elapsedSeconds: m.elapsedSeconds,
      isActive: true,
      startedAt: m.startedAt,
      completedAt: m.completedAt,
      isPaused: false,
    );
  }

  static String _onlineStatusToString(OnlineStatus status) {
    return switch (status) {
      OnlineStatus.online => 'online',
      OnlineStatus.offline => 'offline',
      OnlineStatus.away => 'away',
      OnlineStatus.doNotDisturb => 'do_not_disturb',
    };
  }

  static String _taskStatusToString(TaskStatus status) {
    return switch (status) {
      TaskStatus.new_ => 'new',
      TaskStatus.inProgress => 'in_progress',
      TaskStatus.overdue => 'overdue',
      TaskStatus.complete => 'complete',
    };
  }
}
