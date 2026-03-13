/// Domain entity: a task (project, description, status, timing).
/// No Flutter/platform imports.
class Task {
  const Task({
    required this.id,
    required this.projectName,
    required this.description,
    required this.status,
    required this.isBillable,
    this.elapsedTime,
    required this.isActive,
    this.startedAt,
    this.completedAt,
  });

  final String id;
  final String projectName;
  final String description;
  final TaskStatus status;
  final bool isBillable;
  final Duration? elapsedTime;
  final bool isActive;
  final DateTime? startedAt;
  final DateTime? completedAt;

  Task copyWith({
    String? id,
    String? projectName,
    String? description,
    TaskStatus? status,
    bool? isBillable,
    Duration? elapsedTime,
    bool? isActive,
    DateTime? startedAt,
    DateTime? completedAt,
  }) {
    return Task(
      id: id ?? this.id,
      projectName: projectName ?? this.projectName,
      description: description ?? this.description,
      status: status ?? this.status,
      isBillable: isBillable ?? this.isBillable,
      elapsedTime: elapsedTime ?? this.elapsedTime,
      isActive: isActive ?? this.isActive,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          projectName == other.projectName &&
          description == other.description &&
          status == other.status &&
          isBillable == other.isBillable &&
          elapsedTime == other.elapsedTime &&
          isActive == other.isActive &&
          startedAt == other.startedAt &&
          completedAt == other.completedAt;

  @override
  int get hashCode => Object.hash(
        id,
        projectName,
        description,
        status,
        isBillable,
        elapsedTime,
        isActive,
        startedAt,
        completedAt,
      );
}

enum TaskStatus { new_, inProgress, overdue, complete }
