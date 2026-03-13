import 'package:flutter_test/flutter_test.dart';

import 'package:spec_kit_itp/features/dashboard/data/mappers/dashboard_mapper.dart';
import 'package:spec_kit_itp/features/dashboard/data/models/active_task_model.dart';
import 'package:spec_kit_itp/features/dashboard/data/models/employee_profile_model.dart';
import 'package:spec_kit_itp/features/dashboard/data/models/task_model.dart';
import 'package:spec_kit_itp/features/dashboard/data/models/time_metrics_model.dart';
import 'package:spec_kit_itp/features/dashboard/domain/entities/active_task.dart';
import 'package:spec_kit_itp/features/dashboard/domain/entities/employee_profile.dart';
import 'package:spec_kit_itp/features/dashboard/domain/entities/task.dart';
import 'package:spec_kit_itp/features/dashboard/domain/entities/time_metrics.dart';

void main() {
  late DashboardMapper mapper;

  setUp(() {
    mapper = const DashboardMapper();
  });

  group('DashboardMapper', () {
    group('EmployeeProfile', () {
      test('toEmployeeProfile maps model to entity', () {
        const model = EmployeeProfileModel(
          id: 'e1',
          displayName: 'Jane',
          role: 'Designer',
          onlineStatus: 'online',
          avatarUrl: null,
        );
        final entity = mapper.toEmployeeProfile(model);
        expect(entity.id, 'e1');
        expect(entity.displayName, 'Jane');
        expect(entity.role, 'Designer');
        expect(entity.onlineStatus, OnlineStatus.online);
      });

      test('toEmployeeProfileModel round-trip', () {
        const entity = EmployeeProfile(
          id: 'e2',
          displayName: 'Bob',
          role: 'Dev',
          onlineStatus: OnlineStatus.offline,
          avatarUrl: null,
        );
        final model = mapper.toEmployeeProfileModel(entity);
        final back = mapper.toEmployeeProfile(model);
        expect(back.id, entity.id);
        expect(back.displayName, entity.displayName);
        expect(back.onlineStatus, entity.onlineStatus);
      });
    });

    group('TimeMetrics', () {
      test('toTimeMetrics maps model to entity', () {
        const model = TimeMetricsModel(
          clockInTime: null,
          activeTimeSeconds: 3600,
          totalTimeAtWorkSeconds: 7200,
          clockOutTime: null,
        );
        final entity = mapper.toTimeMetrics(model);
        expect(entity.activeTime.inSeconds, 3600);
        expect(entity.totalTimeAtWork.inSeconds, 7200);
      });

      test('toTimeMetricsModel round-trip', () {
        const entity = TimeMetrics(
          clockInTime: null,
          activeTime: Duration(hours: 1),
          totalTimeAtWork: Duration(hours: 2),
          clockOutTime: null,
        );
        final model = mapper.toTimeMetricsModel(entity);
        expect(model.activeTimeSeconds, 3600);
        expect(model.totalTimeAtWorkSeconds, 7200);
      });
    });

    group('Task', () {
      test('toTask maps inactive TaskModel to Task', () {
        const model = TaskModel(
          id: 't1',
          projectName: 'P1',
          description: 'D1',
          status: 'new',
          isBillable: false,
          elapsedSeconds: null,
          isActive: false,
          startedAt: null,
          completedAt: null,
        );
        final entity = mapper.toTask(model);
        expect(entity, isA<Task>());
        expect(entity.id, 't1');
        expect(entity.isActive, false);
      });

      test('toTask maps active TaskModel to ActiveTask', () {
        const model = TaskModel(
          id: 't2',
          projectName: 'P2',
          description: 'D2',
          status: 'in_progress',
          isBillable: true,
          elapsedSeconds: 300,
          isActive: true,
          startedAt: null,
          completedAt: null,
        );
        final entity = mapper.toTask(model);
        expect(entity, isA<ActiveTask>());
        expect(entity.id, 't2');
        expect(entity.isActive, true);
      });

      test('toActiveTask maps ActiveTaskModel to ActiveTask', () {
        const model = ActiveTaskModel(
          id: 't3',
          projectName: 'P3',
          description: 'D3',
          status: 'in_progress',
          isBillable: true,
          elapsedSeconds: 100,
          isActive: true,
          startedAt: null,
          completedAt: null,
          isPaused: true,
        );
        final entity = mapper.toActiveTask(model);
        expect(entity, isA<ActiveTask>());
        expect(entity.isPaused, true);
      });
    });
  });
}
