// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActiveTaskModel _$ActiveTaskModelFromJson(Map<String, dynamic> json) =>
    ActiveTaskModel(
      id: json['id'] as String,
      projectName: json['projectName'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      isBillable: json['isBillable'] as bool,
      elapsedSeconds: (json['elapsedSeconds'] as num?)?.toInt(),
      isActive: json['isActive'] as bool? ?? true,
      startedAt: json['startedAt'] as String?,
      completedAt: json['completedAt'] as String?,
      isPaused: json['isPaused'] as bool? ?? false,
    );

Map<String, dynamic> _$ActiveTaskModelToJson(ActiveTaskModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'projectName': instance.projectName,
      'description': instance.description,
      'status': instance.status,
      'isBillable': instance.isBillable,
      'elapsedSeconds': instance.elapsedSeconds,
      'isActive': instance.isActive,
      'startedAt': instance.startedAt,
      'completedAt': instance.completedAt,
      'isPaused': instance.isPaused,
    };
