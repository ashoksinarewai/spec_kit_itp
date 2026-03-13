import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/entities/active_task.dart';
import '../../domain/entities/dashboard_data.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/usecases/complete_active_task_usecase.dart';
import '../../domain/usecases/get_dashboard_data_usecase.dart';
import '../../domain/usecases/pause_active_task_usecase.dart';
import '../../domain/usecases/start_task_usecase.dart';
import '../../../../../core/constants/dashboard_constants.dart';

/// Provides [DashboardRepository]. Override in tests.
final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepositoryImpl();
});

final getDashboardDataUseCaseProvider = Provider<GetDashboardDataUseCase>((ref) {
  return GetDashboardDataUseCase(ref.watch(dashboardRepositoryProvider));
});

final pauseActiveTaskUseCaseProvider = Provider<PauseActiveTaskUseCase>((ref) {
  return PauseActiveTaskUseCase(ref.watch(dashboardRepositoryProvider));
});

final completeActiveTaskUseCaseProvider =
    Provider<CompleteActiveTaskUseCase>((ref) {
  return CompleteActiveTaskUseCase(ref.watch(dashboardRepositoryProvider));
});

final startTaskUseCaseProvider = Provider<StartTaskUseCase>((ref) {
  return StartTaskUseCase(ref.watch(dashboardRepositoryProvider));
});

/// Dashboard data (profile, metrics, active task, tasks). Auto-disposes when unused.
final dashboardProvider =
    FutureProvider.autoDispose<DashboardData>((ref) async {
  final useCase = ref.watch(getDashboardDataUseCaseProvider);
  return useCase.call();
});

/// Filter state: selected status and search query.
class TaskFilterState {
  const TaskFilterState({
    this.status,
    this.searchQuery = '',
  });

  final TaskStatus? status;
  final String searchQuery;

  TaskFilterState copyWith({TaskStatus? status, String? searchQuery}) {
    return TaskFilterState(
      status: status ?? this.status,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class TaskFilterNotifier extends AutoDisposeNotifier<TaskFilterState> {
  @override
  TaskFilterState build() => const TaskFilterState();

  void setStatus(TaskStatus? status) {
    state = state.copyWith(status: status);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }
}

final taskFilterProvider =
    AutoDisposeNotifierProvider<TaskFilterNotifier, TaskFilterState>(
  TaskFilterNotifier.new,
);

/// Filtered task list derived from dashboard data and filter state.
final filteredTasksProvider = Provider.autoDispose<List<Task>>((ref) {
  final dashboardAsync = ref.watch(dashboardProvider);
  final filter = ref.watch(taskFilterProvider);

  return dashboardAsync.when(
    data: (data) {
      var list = data.tasks;
      if (filter.searchQuery.isNotEmpty) {
        final q = filter.searchQuery.toLowerCase();
        list = list
            .where(
              (t) =>
                  t.projectName.toLowerCase().contains(q) ||
                  t.description.toLowerCase().contains(q),
            )
            .toList();
      }
      if (filter.status != null) {
        list = list.where((t) => t.status == filter.status).toList();
      }
      return list;
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

/// Emits elapsed [Duration] every [kDashboardTimerIntervalMs] ms while an active task exists.
/// Starts from active task's [ActiveTask.startedAt] and accounts for [ActiveTask.isPaused].
final activeTaskTimerProvider =
    StreamProvider.autoDispose<Duration>((ref) async* {
  final dashboardAsync = ref.watch(dashboardProvider);
  final data = dashboardAsync.valueOrNull;
  final activeTask = data?.activeTask;
  if (activeTask == null || activeTask.isPaused) return;

  final startedAt = activeTask.startedAt ?? DateTime.now();
  final initialElapsed = activeTask.elapsedTime ?? Duration.zero;

  await for (
    final _ in Stream.periodic(
      const Duration(milliseconds: kDashboardTimerIntervalMs),
    ),
  )
  {
    final dashboardAgain = ref.read(dashboardProvider).valueOrNull;
    final currentActive = dashboardAgain?.activeTask;
    if (currentActive == null || currentActive.id != activeTask.id) return;
    if (currentActive.isPaused) continue;

    final now = DateTime.now();
    final elapsed = initialElapsed +
        Duration(milliseconds: now.difference(startedAt).inMilliseconds);
    yield elapsed;
  }
});

/// Refreshes dashboard after an action; call after pause/complete/start.
void _invalidateDashboard(Ref ref) {
  ref.invalidate(dashboardProvider);
}

/// Pause active task and refresh dashboard.
final pauseActiveTaskProvider =
    Provider.autoDispose<Future<void> Function(String taskId)>((ref) {
  return (String taskId) async {
    final useCase = ref.read(pauseActiveTaskUseCaseProvider);
    await useCase.call(taskId);
    _invalidateDashboard(ref);
  };
});

/// Complete active task and refresh dashboard.
final completeActiveTaskProvider =
    Provider.autoDispose<Future<void> Function(String taskId)>((ref) {
  return (String taskId) async {
    final useCase = ref.read(completeActiveTaskUseCaseProvider);
    await useCase.call(taskId);
    _invalidateDashboard(ref);
  };
});

/// Start task and refresh dashboard.
final startTaskProvider =
    Provider.autoDispose<Future<Task> Function(String taskId)>((ref) {
  return (String taskId) async {
    final useCase = ref.read(startTaskUseCaseProvider);
    final task = await useCase.call(taskId);
    _invalidateDashboard(ref);
    return task;
  };
});
