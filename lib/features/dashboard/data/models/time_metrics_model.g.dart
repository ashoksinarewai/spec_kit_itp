// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_metrics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeMetricsModel _$TimeMetricsModelFromJson(Map<String, dynamic> json) =>
    TimeMetricsModel(
      clockInTime: json['clockInTime'] as String?,
      activeTimeSeconds: (json['activeTimeSeconds'] as num).toInt(),
      totalTimeAtWorkSeconds: (json['totalTimeAtWorkSeconds'] as num).toInt(),
      clockOutTime: json['clockOutTime'] as String?,
    );

Map<String, dynamic> _$TimeMetricsModelToJson(TimeMetricsModel instance) =>
    <String, dynamic>{
      'clockInTime': instance.clockInTime,
      'activeTimeSeconds': instance.activeTimeSeconds,
      'totalTimeAtWorkSeconds': instance.totalTimeAtWorkSeconds,
      'clockOutTime': instance.clockOutTime,
    };
