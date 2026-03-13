import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/active_task.dart';
import '../../domain/entities/dashboard_data.dart';
import '../../domain/entities/task.dart';
import 'dashboard_providers.dart';

/// ViewModel for dashboard screen: exposes dashboard state and actions.
/// State is derived from [dashboardProvider]; actions invalidate/refresh as needed.
class DashboardViewModel {
  DashboardViewModel(this._ref);

  final Ref _ref;

  AsyncValue<DashboardData> get dashboardAsync =>
      _ref.watch(dashboardProvider);

  List<Task> get filteredTasks => _ref.watch(filteredTasksProvider);

  TaskFilterState get filterState => _ref.watch(taskFilterProvider);

  bool get hasActiveTask {
    final data = _ref.read(dashboardProvider).valueOrNull;
    return data?.activeTask != null;
  }

  ActiveTask? get activeTask {
    final data = _ref.read(dashboardProvider).valueOrNull;
    return data?.activeTask;
  }

  /// Refreshes dashboard data.
  Future<void> loadDashboard() async {
    _ref.invalidate(dashboardProvider);
    await _ref.read(dashboardProvider.future);
  }

  void setFilterStatus(TaskStatus? status) {
    _ref.read(taskFilterProvider.notifier).setStatus(status);
  }

  void setSearchQuery(String query) {
    _ref.read(taskFilterProvider.notifier).setSearchQuery(query);
  }

  Future<void> pauseActiveTask(String taskId) async {
    await _ref.read(pauseActiveTaskProvider)(taskId);
  }

  Future<void> completeActiveTask(String taskId) async {
    await _ref.read(completeActiveTaskProvider)(taskId);
  }

  Future<Task> startTask(String taskId) async {
    return _ref.read(startTaskProvider)(taskId);
  }
}

final dashboardViewModelProvider =
    Provider.autoDispose<DashboardViewModel>((ref) {
  return DashboardViewModel(ref);
});
