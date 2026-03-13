import 'package:flutter/material.dart';

import '../../../../core/extensions/duration_extension.dart';
import '../../domain/entities/time_metrics.dart';

/// Displays today's time metrics: clock-in, active time, total time at work.
class TimeMetricsWidget extends StatelessWidget {
  const TimeMetricsWidget({super.key, this.timeMetrics});

  final TimeMetrics? timeMetrics;

  @override
  Widget build(BuildContext context) {
    if (timeMetrics == null) {
      return _buildSkeleton(context);
    }
    final theme = Theme.of(context);
    final m = timeMetrics!;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Today's time",
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _MetricChip(
                    label: 'Clock in',
                    value: m.clockInTime != null
                        ? _formatTime(m.clockInTime!)
                        : '—',
                    icon: Icons.login,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MetricChip(
                    label: 'Active time',
                    value: m.activeTime.formattedHHMM,
                    icon: Icons.timer,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _MetricChip(
                    label: 'Total at work',
                    value: m.totalTimeAtWork.formattedHHMM,
                    icon: Icons.schedule,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MetricChip(
                    label: 'Clock out',
                    value: m.clockOutTime != null
                        ? _formatTime(m.clockOutTime!)
                        : '—',
                    icon: Icons.logout,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeleton(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 14,
              width: 80,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: List.generate(
                4,
                (_) => Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 48,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatTime(DateTime dt) {
    final h = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final am = dt.hour < 12;
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m ${am ? 'am' : 'pm'}';
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: theme.colorScheme.primary),
            const SizedBox(width: 4),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
