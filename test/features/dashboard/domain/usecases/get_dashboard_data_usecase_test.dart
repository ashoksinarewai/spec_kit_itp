import 'package:flutter_test/flutter_test.dart';

import 'package:spec_kit_itp/features/dashboard/domain/entities/dashboard_data.dart';
import 'package:spec_kit_itp/features/dashboard/domain/entities/employee_profile.dart';
import 'package:spec_kit_itp/features/dashboard/domain/entities/task.dart';
import 'package:spec_kit_itp/features/dashboard/domain/entities/time_metrics.dart';
import 'package:spec_kit_itp/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:spec_kit_itp/features/dashboard/domain/usecases/get_dashboard_data_usecase.dart';

void main() {
  group('GetDashboardDataUseCase', () {
    late GetDashboardDataUseCase useCase;
    late MockDashboardRepository mockRepo;

    setUp(() {
      mockRepo = MockDashboardRepository();
      useCase = GetDashboardDataUseCase(mockRepo);
    });

    test('call() returns DashboardData from repository', () async {
      final data = DashboardData(
        profile: const EmployeeProfile(
          id: '1',
          displayName: 'Test',
          role: 'Dev',
          onlineStatus: OnlineStatus.online,
          avatarUrl: null,
        ),
        timeMetrics: TimeMetrics(
          clockInTime: null,
          activeTime: Duration.zero,
          totalTimeAtWork: Duration.zero,
          clockOutTime: null,
        ),
        activeTask: null,
        tasks: [],
      );
      mockRepo.getDashboardDataResult = data;

      final result = await useCase.call();

      expect(result, data);
      expect(mockRepo.getDashboardDataCallCount, 1);
    });

    test('call() propagates repository errors', () async {
      mockRepo.getDashboardDataThrows = Exception('network error');

      expect(() => useCase.call(), throwsA(isA<Exception>()));
      expect(mockRepo.getDashboardDataCallCount, 1);
    });
  });
}

class MockDashboardRepository implements DashboardRepository {
  int getDashboardDataCallCount = 0;
  DashboardData? getDashboardDataResult;
  Object? getDashboardDataThrows;

  @override
  Future<DashboardData> getDashboardData() async {
    getDashboardDataCallCount++;
    if (getDashboardDataThrows != null) throw getDashboardDataThrows!;
    return getDashboardDataResult!;
  }

  @override
  Future<void> pauseActiveTask(String taskId) async {}

  @override
  Future<void> completeActiveTask(String taskId) async {}

  @override
  Future<Task> startTask(String taskId) async {
    throw UnimplementedError();
  }

  @override
  Future<List<Task>> searchTasks(String query,
      {TaskStatus? status, int limit = 20, int offset = 0}) async {
    return [];
  }

  @override
  Future<List<Task>> filterTasksByStatus(TaskStatus status,
      {int limit = 20, int offset = 0}) async {
    return [];
  }
}
