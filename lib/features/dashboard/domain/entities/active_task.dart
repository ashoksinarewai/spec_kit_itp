import 'task.dart';

/// Domain entity: currently active task with pause state.
/// Extends [Task] with [isPaused] flag.
class ActiveTask extends Task {
  const ActiveTask({
    required super.id,
    required super.projectName,
    required super.description,
    required super.status,
    required super.isBillable,
    super.elapsedTime,
    super.startedAt,
    super.completedAt,
    this.isPaused = false,
  }) : super(isActive: true);

  final bool isPaused;

  @override
  ActiveTask copyWith({
    String? id,
    String? projectName,
    String? description,
    TaskStatus? status,
    bool? isBillable,
    Duration? elapsedTime,
    bool? isActive,
    DateTime? startedAt,
    DateTime? completedAt,
    bool? isPaused,
  }) {
    return ActiveTask(
      id: id ?? this.id,
      projectName: projectName ?? this.projectName,
      description: description ?? this.description,
      status: status ?? this.status,
      isBillable: isBillable ?? this.isBillable,
      elapsedTime: elapsedTime ?? this.elapsedTime,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      isPaused: isPaused ?? this.isPaused,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActiveTask &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          isPaused == other.isPaused;

  @override
  int get hashCode => Object.hash(id, isPaused);
}
