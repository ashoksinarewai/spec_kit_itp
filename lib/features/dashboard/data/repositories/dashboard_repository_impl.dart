import '../../domain/entities/active_task.dart';
import '../../domain/entities/dashboard_data.dart';
import '../../domain/entities/employee_profile.dart';
import '../../domain/entities/task.dart';
import '../../domain/entities/time_metrics.dart';
import '../../domain/repositories/dashboard_repository.dart';

/// Dashboard repository implementation with mock data initially.
/// TODO: Replace mock with real API client and SQLite caching.
class DashboardRepositoryImpl implements DashboardRepository {
  DashboardRepositoryImpl({
    Object? authService,
    Object? apiClient,
  })  : _authService = authService,
        _apiClient = apiClient {
    // Constructor injects auth service and API client for future use.
    // Mock: ignore for now; real impl will inject token into API calls.
  }

  // Ignored in mock; used when real API is wired for Bearer token injection.
  // ignore: unused_field
  final Object? _authService;
  // ignore: unused_field
  final Object? _apiClient;

  // In-memory mock state for task actions (T006).
  String? _activeTaskId = 'task123';
  bool _activeTaskPaused = false;
  final List<Task> _mockTasks = _buildMockTaskList();

  static List<Task> _buildMockTaskList() {
    final now = DateTime.now();
    return [
      Task(
        id: 'task123',
        projectName: 'Mobile App Redesign',
        description: 'Update home screen UI',
        status: TaskStatus.inProgress,
        isBillable: true,
        elapsedTime: const Duration(hours: 4, minutes: 15),
        isActive: true,
        startedAt: now.subtract(const Duration(hours: 4, minutes: 15)),
        completedAt: null,
      ),
      const Task(
        id: 'task124',
        projectName: 'Backend API',
        description: 'Fix user endpoint',
        status: TaskStatus.new_,
        isBillable: false,
        elapsedTime: null,
        isActive: false,
        startedAt: null,
        completedAt: null,
      ),
      const Task(
        id: 'task125',
        projectName: 'Documentation',
        description: 'Update API docs',
        status: TaskStatus.new_,
        isBillable: true,
        elapsedTime: null,
        isActive: false,
        startedAt: null,
        completedAt: null,
      ),
    ];
  }

  @override
  Future<DashboardData> getDashboardData() async {
    _log('getDashboardData()');
    // TODO: Real API: GET /api/v1/dashboard with Bearer token from _authService.
    const profile = EmployeeProfile(
      id: 'emp123',
      displayName: 'John Doe',
      role: 'Frontend Developer',
      onlineStatus: OnlineStatus.online,
      avatarUrl: null,
    );
    final timeMetrics = TimeMetrics(
      clockInTime: DateTime.now().subtract(const Duration(hours: 3)),
      activeTime: const Duration(hours: 2, minutes: 17),
      totalTimeAtWork: const Duration(hours: 3, minutes: 9),
      clockOutTime: null,
    );
    ActiveTask? activeTask;
    if (_activeTaskId != null) {
      Task? t;
      try {
        t = _mockTasks.firstWhere((e) => e.id == _activeTaskId);
      } catch (_) {
        t = null;
      }
      if (t != null && t.isActive) {
        activeTask = ActiveTask(
          id: t.id,
          projectName: t.projectName,
          description: t.description,
          status: t.status,
          isBillable: t.isBillable,
          elapsedTime: t.elapsedTime,
          startedAt: t.startedAt,
          completedAt: t.completedAt,
          isPaused: _activeTaskPaused,
        );
      }
    }
    return DashboardData(
      profile: profile,
      timeMetrics: timeMetrics,
      activeTask: activeTask,
      tasks: List.from(_mockTasks),
    );
  }

  @override
  Future<void> pauseActiveTask(String taskId) async {
    _log('pauseActiveTask($taskId)');
    if (_activeTaskId != taskId) throw StateError('Task not active: $taskId');
    _activeTaskPaused = true;
    // TODO: Real API: POST /api/v1/tasks/$taskId/pause with Bearer token.
  }

  @override
  Future<void> completeActiveTask(String taskId) async {
    _log('completeActiveTask($taskId)');
    final idx = _mockTasks.indexWhere((t) => t.id == taskId);
    if (idx < 0) throw StateError('Task not found: $taskId');
    final t = _mockTasks[idx];
    final updated = t.copyWith(
      status: TaskStatus.complete,
      isActive: false,
      completedAt: DateTime.now(),
    );
    _mockTasks[idx] = updated;
    if (_activeTaskId == taskId) _activeTaskId = null;
    // TODO: Real API: POST /api/v1/tasks/$taskId/complete with Bearer token.
  }

  @override
  Future<Task> startTask(String taskId) async {
    _log('startTask($taskId)');
    final idx = _mockTasks.indexWhere((t) => t.id == taskId);
    if (idx < 0) throw StateError('Task not found: $taskId');
    final now = DateTime.now();
    for (var i = 0; i < _mockTasks.length; i++) {
      final t = _mockTasks[i];
      if (t.id == taskId) {
        _mockTasks[i] = t.copyWith(
          status: TaskStatus.inProgress,
          isActive: true,
          startedAt: now,
          elapsedTime: t.elapsedTime ?? Duration.zero,
        );
        _activeTaskId = taskId;
        _activeTaskPaused = false;
        return _mockTasks[i];
      }
      if (t.isActive) {
        _mockTasks[i] = t.copyWith(isActive: false);
      }
    }
    return _mockTasks.firstWhere((t) => t.id == taskId);
  }

  @override
  Future<List<Task>> searchTasks(
    String query, {
    TaskStatus? status,
    int limit = 20,
    int offset = 0,
  }) async {
    _log('searchTasks($query, status: $status, limit: $limit, offset: $offset)');
    final list = _mockTasks.where((t) {
      final match = query.isEmpty ||
          t.projectName.toLowerCase().contains(query.toLowerCase()) ||
          t.description.toLowerCase().contains(query.toLowerCase());
      if (!match) return false;
      if (status != null && t.status != status) return false;
      return true;
    }).toList();
    return list.skip(offset).take(limit).toList();
  }

  @override
  Future<List<Task>> filterTasksByStatus(
    TaskStatus status, {
    int limit = 20,
    int offset = 0,
  }) async {
    _log('filterTasksByStatus($status, limit: $limit, offset: $offset)');
    final list = _mockTasks.where((t) => t.status == status).toList();
    return list.skip(offset).take(limit).toList();
  }

  void _log(String message) {
    // Per constitution §14: structured logging. Replace with logger when available.
    // ignore: avoid_print
    print('[DashboardRepository] $message');
  }
}
