import 'package:flutter/material.dart';

import '../../features/auth/domain/entities/auth_session.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';

/// On launch: restore session via refresh token; if valid show [buildDashboard], else [buildLogin].
/// On 401 from refresh: clear storage and show login (caller can show "Session expired").
class AuthBootstrap extends StatelessWidget {
  const AuthBootstrap({
    super.key,
    required this.repository,
    required this.buildLogin,
    required this.buildDashboard,
  });

  final AuthRepository repository;
  final Widget Function() buildLogin;
  final Widget Function(AuthSession session) buildDashboard;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AuthSession?>(
      future: repository.getCurrentSession(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }
        final session = snapshot.data;
        if (session != null) {
          return MaterialApp(
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
              useMaterial3: true,
            ),
            home: buildDashboard(session),
          );
        }
        return MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          home: buildLogin(),
        );
      },
    );
  }
}
