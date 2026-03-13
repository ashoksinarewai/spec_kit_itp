import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/task.dart';

part 'task_model.g.dart';

@JsonSerializable()
class TaskModel {
  const TaskModel({
    required this.id,
    required this.projectName,
    required this.description,
    required this.status,
    required this.isBillable,
    this.elapsedSeconds,
    this.isActive = false,
    this.startedAt,
    this.completedAt,
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

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);
  Map<String, dynamic> toJson() => _$TaskModelToJson(this);

  Task toEntity() {
    return Task(
      id: id,
      projectName: projectName,
      description: description,
      status: TaskModel.parseStatus(status),
      isBillable: isBillable,
      elapsedTime:
          elapsedSeconds != null ? Duration(seconds: elapsedSeconds!) : null,
      isActive: isActive,
      startedAt: startedAt != null ? DateTime.tryParse(startedAt!) : null,
      completedAt:
          completedAt != null ? DateTime.tryParse(completedAt!) : null,
    );
  }

  static TaskStatus parseStatus(String value) {
    return switch (value.toLowerCase()) {
      'new' => TaskStatus.new_,
      'in_progress' => TaskStatus.inProgress,
      'inprogress' => TaskStatus.inProgress,
      'overdue' => TaskStatus.overdue,
      'complete' => TaskStatus.complete,
      'completed' => TaskStatus.complete,
      _ => TaskStatus.new_,
    };
  }
}
