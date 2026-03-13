// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskModel _$TaskModelFromJson(Map<String, dynamic> json) => TaskModel(
      id: json['id'] as String,
      projectName: json['projectName'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      isBillable: json['isBillable'] as bool,
      elapsedSeconds: (json['elapsedSeconds'] as num?)?.toInt(),
      isActive: json['isActive'] as bool? ?? false,
      startedAt: json['startedAt'] as String?,
      completedAt: json['completedAt'] as String?,
    );

Map<String, dynamic> _$TaskModelToJson(TaskModel instance) => <String, dynamic>{
      'id': instance.id,
      'projectName': instance.projectName,
      'description': instance.description,
      'status': instance.status,
      'isBillable': instance.isBillable,
      'elapsedSeconds': instance.elapsedSeconds,
      'isActive': instance.isActive,
      'startedAt': instance.startedAt,
      'completedAt': instance.completedAt,
    };
