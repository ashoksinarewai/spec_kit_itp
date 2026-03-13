import 'package:flutter/material.dart';

/// Reusable skeleton loader for dashboard sections.
/// Can show full dashboard or partial (e.g. header only).
class LoadingStateWidget extends StatelessWidget {
  const LoadingStateWidget({
    super.key,
    this.showHeader = true,
    this.showMetrics = true,
    this.showActiveTask = true,
    this.showTaskList = true,
  });

  final bool showHeader;
  final bool showMetrics;
  final bool showActiveTask;
  final bool showTaskList;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.surfaceContainerHighest;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showHeader) _skeletonBlock(height: 80, color: color),
          if (showMetrics) _skeletonBlock(height: 140, color: color),
          if (showActiveTask) _skeletonBlock(height: 120, color: color),
          if (showTaskList) ...[
            _skeletonBlock(height: 48, color: color),
            _skeletonBlock(height: 72, color: color),
            _skeletonBlock(height: 72, color: color),
            _skeletonBlock(height: 72, color: color),
          ],
        ],
      ),
    );
  }

  static Widget _skeletonBlock({required double height, required Color color}) {
    return Container(
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
