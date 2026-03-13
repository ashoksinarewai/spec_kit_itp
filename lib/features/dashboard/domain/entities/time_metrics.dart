/// Domain entity: today's time metrics (clock-in, active time, total at work).
/// No Flutter/platform imports.
class TimeMetrics {
  const TimeMetrics({
    this.clockInTime,
    required this.activeTime,
    required this.totalTimeAtWork,
    this.clockOutTime,
  });

  final DateTime? clockInTime;
  final Duration activeTime;
  final Duration totalTimeAtWork;
  final DateTime? clockOutTime;

  TimeMetrics copyWith({
    DateTime? clockInTime,
    Duration? activeTime,
    Duration? totalTimeAtWork,
    DateTime? clockOutTime,
  }) {
    return TimeMetrics(
      clockInTime: clockInTime ?? this.clockInTime,
      activeTime: activeTime ?? this.activeTime,
      totalTimeAtWork: totalTimeAtWork ?? this.totalTimeAtWork,
      clockOutTime: clockOutTime ?? this.clockOutTime,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeMetrics &&
          runtimeType == other.runtimeType &&
          clockInTime == other.clockInTime &&
          activeTime == other.activeTime &&
          totalTimeAtWork == other.totalTimeAtWork &&
          clockOutTime == other.clockOutTime;

  @override
  int get hashCode =>
      Object.hash(clockInTime, activeTime, totalTimeAtWork, clockOutTime);
}
