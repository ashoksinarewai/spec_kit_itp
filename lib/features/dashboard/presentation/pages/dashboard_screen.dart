import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodels/dashboard_providers.dart';
import '../viewmodels/dashboard_viewmodel.dart';
import '../widgets/error_state_widget.dart';
import '../widgets/header_widget.dart';
import '../widgets/loading_state_widget.dart';
import '../widgets/time_metrics_widget.dart';

/// Main dashboard screen: header, time metrics, active task area, task list.
/// Consumes [dashboardProvider] for loading/error/data; uses [dashboardViewModelProvider] for actions.
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Load data when screen mounts (provider fetches on first watch).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dashboardProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboardAsync = ref.watch(dashboardProvider);
    final vm = ref.watch(dashboardViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: RefreshIndicator(
        onRefresh: () => vm.loadDashboard(),
        child: dashboardAsync.when(
          data: (data) => _buildContent(context, data, vm),
          loading: () => const LoadingStateWidget(),
          error: (err, _) => ErrorStateWidget(
            message: err.toString(),
            onRetry: () => ref.invalidate(dashboardProvider),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    dynamic data,
    DashboardViewModel vm,
  ) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HeaderWidget(profile: data.profile),
          const SizedBox(height: 16),
          TimeMetricsWidget(timeMetrics: data.timeMetrics),
          const SizedBox(height: 16),
          // Placeholder for ActiveTaskCard (Phase 2).
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Active task area (Phase 2)',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 16),
          // Placeholder for TaskListWidget (Phase 3).
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Task list (Phase 3)',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
