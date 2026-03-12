import 'package:flutter/material.dart';

import '../domain/entities/auth_session.dart';

/// Placeholder until Dashboard feature exists. Post-login destination.
class DashboardPlaceholderScreen extends StatelessWidget {
  const DashboardPlaceholderScreen({super.key, this.session});

  final AuthSession? session;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Center(
        child: Text(
          session != null
              ? 'Welcome, ${session!.user.email}'
              : 'Dashboard (placeholder)',
        ),
      ),
    );
  }
}
