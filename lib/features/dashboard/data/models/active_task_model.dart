import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/active_task.dart';

import 'task_model.dart';

part 'active_task_model.g.dart';

@JsonSerializable()
class ActiveTaskModel {
  const ActiveTaskModel({
    required this.id,
    required this.projectName,
    required this.description,
    required this.status,
    required this.isBillable,
    this.elapsedSeconds,
    this.isActive = true,
    this.startedAt,
    this.completedAt,
    this.isPaused = false,
  });

  final String id;
  final String projectName;
  final String description;
  final String status;
  final bool isBillable;
  final int? elapsedSeconds;
  final bool isActive;
  final String? startedAt;
  final String? completedAt;
  final bool isPaused;

  factory ActiveTaskModel.fromJson(Map<String, dynamic> json) =>
      _$ActiveTaskModelFromJson(json);
  Map<String, dynamic> toJson() => _$ActiveTaskModelToJson(this);

  ActiveTask toEntity() {
    return ActiveTask(
      id: id,
      projectName: projectName,
      description: description,
      status: TaskModel.parseStatus(status),
      isBillable: isBillable,
      elapsedTime:
          elapsedSeconds != null ? Duration(seconds: elapsedSeconds!) : null,
      startedAt: startedAt != null ? DateTime.tryParse(startedAt!) : null,
      completedAt:
          completedAt != null ? DateTime.tryParse(completedAt!) : null,
      isPaused: isPaused,
    );
  }
}
