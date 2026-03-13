import 'package:flutter_test/flutter_test.dart';

import 'package:spec_kit_itp/features/dashboard/domain/entities/dashboard_data.dart';
import 'package:spec_kit_itp/features/dashboard/domain/entities/task.dart';
import 'package:spec_kit_itp/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:spec_kit_itp/features/dashboard/domain/usecases/pause_active_task_usecase.dart';

void main() {
  group('PauseActiveTaskUseCase', () {
    late PauseActiveTaskUseCase useCase;
    late MockDashboardRepository mockRepo;

    setUp(() {
      mockRepo = MockDashboardRepository();
      useCase = PauseActiveTaskUseCase(mockRepo);
    });

    test('call(taskId) invokes repository.pauseActiveTask', () async {
      await useCase.call('task-1');

      expect(mockRepo.pauseActiveTaskCallCount, 1);
      expect(mockRepo.lastPauseTaskId, 'task-1');
    });

    test('call(taskId) propagates repository errors', () async {
      mockRepo.pauseActiveTaskThrows = StateError('Task not active');

      expect(() => useCase.call('task-1'), throwsA(isA<StateError>()));
    });
  });
}

class MockDashboardRepository implements DashboardRepository {
  int pauseActiveTaskCallCount = 0;
  String? lastPauseTaskId;
  Object? pauseActiveTaskThrows;

  @override
  Future<void> pauseActiveTask(String taskId) async {
    pauseActiveTaskCallCount++;
    lastPauseTaskId = taskId;
    if (pauseActiveTaskThrows != null) throw pauseActiveTaskThrows!;
  }

  @override
  Future<DashboardData> getDashboardData() async =>
      throw UnimplementedError();

  @override
  Future<void> completeActiveTask(String taskId) async {}

  @override
  Future<Task> startTask(String taskId) async =>
      throw UnimplementedError();

  @override
  Future<List<Task>> searchTasks(String query,
      {TaskStatus? status, int limit = 20, int offset = 0}) async =>
      [];

  @override
  Future<List<Task>> filterTasksByStatus(TaskStatus status,
      {int limit = 20, int offset = 0}) async =>
      [];
}
