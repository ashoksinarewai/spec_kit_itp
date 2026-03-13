import 'package:flutter_test/flutter_test.dart';

import 'package:spec_kit_itp/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:spec_kit_itp/features/dashboard/domain/entities/task.dart';

void main() {
  group('DashboardRepositoryImpl', () {
    late DashboardRepositoryImpl repo;

    setUp(() {
      repo = DashboardRepositoryImpl();
    });

    test('getDashboardData returns profile, metrics, tasks', () async {
      final data = await repo.getDashboardData();

      expect(data.profile.id, isNotEmpty);
      expect(data.profile.displayName, isNotEmpty);
      expect(data.timeMetrics.activeTime, isNotNull);
      expect(data.tasks, isNotEmpty);
    });

    test('searchTasks filters by query', () async {
      final results = await repo.searchTasks('Backend');
      expect(results.every((t) =>
          t.projectName.toLowerCase().contains('backend') ||
          t.description.toLowerCase().contains('backend')), isTrue);
    });

    test('searchTasks with empty query returns all matching status', () async {
      final results = await repo.searchTasks('', status: TaskStatus.new_);
      expect(results.every((t) => t.status == TaskStatus.new_), isTrue);
    });

    test('filterTasksByStatus returns only matching status', () async {
      final results =
          await repo.filterTasksByStatus(TaskStatus.inProgress);
      expect(results.every((t) => t.status == TaskStatus.inProgress),
          isTrue);
    });

    test('completeActiveTask clears active task', () async {
      final before = await repo.getDashboardData();
      expect(before.activeTask, isNotNull);

      await repo.completeActiveTask(before.activeTask!.id);

      final after = await repo.getDashboardData();
      expect(after.activeTask, isNull);
    });

    test('startTask sets task as active', () async {
      final before = await repo.getDashboardData();
      final toStart = before.tasks.firstWhere(
        (t) => !t.isActive,
        orElse: () => before.tasks.first,
      );

      final started = await repo.startTask(toStart.id);

      expect(started.isActive, isTrue);
      final after = await repo.getDashboardData();
      expect(after.activeTask?.id, toStart.id);
    });

    test('pauseActiveTask throws if task not active', () async {
      expect(
        () => repo.pauseActiveTask('non-existent-id'),
        throwsA(isA<StateError>()),
      );
    });
  });
}
