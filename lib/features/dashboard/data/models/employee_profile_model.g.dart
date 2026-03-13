// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeProfileModel _$EmployeeProfileModelFromJson(
        Map<String, dynamic> json) =>
    EmployeeProfileModel(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      role: json['role'] as String,
      onlineStatus: json['onlineStatus'] as String,
      avatarUrl: json['avatarUrl'] as String?,
    );

Map<String, dynamic> _$EmployeeProfileModelToJson(
        EmployeeProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'displayName': instance.displayName,
      'role': instance.role,
      'onlineStatus': instance.onlineStatus,
      'avatarUrl': instance.avatarUrl,
    };
