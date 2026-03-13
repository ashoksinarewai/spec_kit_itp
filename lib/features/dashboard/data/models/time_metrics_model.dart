import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/time_metrics.dart';

part 'time_metrics_model.g.dart';

@JsonSerializable()
class TimeMetricsModel {
  const TimeMetricsModel({
    this.clockInTime,
    required this.activeTimeSeconds,
    required this.totalTimeAtWorkSeconds,
    this.clockOutTime,
  });

  final String? clockInTime;
  final int activeTimeSeconds;
  final int totalTimeAtWorkSeconds;
  final String? clockOutTime;

  factory TimeMetricsModel.fromJson(Map<String, dynamic> json) =>
      _$TimeMetricsModelFromJson(json);
  Map<String, dynamic> toJson() => _$TimeMetricsModelToJson(this);

  TimeMetrics toEntity() {
    return TimeMetrics(
      clockInTime: clockInTime != null ? DateTime.tryParse(clockInTime!) : null,
      activeTime: Duration(seconds: activeTimeSeconds),
      totalTimeAtWork: Duration(seconds: totalTimeAtWorkSeconds),
      clockOutTime:
          clockOutTime != null ? DateTime.tryParse(clockOutTime!) : null,
    );
  }
}
