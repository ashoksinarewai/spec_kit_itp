import 'active_task.dart';
import 'employee_profile.dart';
import 'task.dart';
import 'time_metrics.dart';

/// Aggregate returned by [DashboardRepository.getDashboardData].
/// Holds profile, metrics, active task, and task list.
class DashboardData {
  const DashboardData({
    required this.profile,
    required this.timeMetrics,
    this.activeTask,
    required this.tasks,
  });

  final EmployeeProfile profile;
  final TimeMetrics timeMetrics;
  final ActiveTask? activeTask;
  final List<Task> tasks;

  DashboardData copyWith({
    EmployeeProfile? profile,
    TimeMetrics? timeMetrics,
    ActiveTask? activeTask,
    List<Task>? tasks,
  }) {
    return DashboardData(
      profile: profile ?? this.profile,
      timeMetrics: timeMetrics ?? this.timeMetrics,
      activeTask: activeTask ?? this.activeTask,
      tasks: tasks ?? this.tasks,
    );
  }
}
