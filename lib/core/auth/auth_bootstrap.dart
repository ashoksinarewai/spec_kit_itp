import 'package:flutter/material.dart';

import '../../features/auth/domain/entities/auth_session.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';

/// On launch: restore session via refresh token; if valid show [buildDashboard], else [buildLogin].
/// On 401 from refresh: clear storage and show login (caller can show "Session expired").
/// When login succeeds, [buildLogin] receives [onLoginSuccess] and calls it with the new session.
class AuthBootstrap extends StatefulWidget {
  const AuthBootstrap({
    super.key,
    required this.repository,
    required this.buildLogin,
    required this.buildDashboard,
  });

  final AuthRepository repository;
  final Widget Function(void Function(AuthSession session) onLoginSuccess)
      buildLogin;
  final Widget Function(AuthSession session) buildDashboard;

  @override
  State<AuthBootstrap> createState() => _AuthBootstrapState();
}

class _AuthBootstrapState extends State<AuthBootstrap> {
  AuthSession? _session;

  @override
  Widget build(BuildContext context) {
    if (_session != null) {
      return MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: widget.buildDashboard(_session!),
      );
    }
    return FutureBuilder<AuthSession?>(
      future: widget.repository.getCurrentSession(),
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
            home: widget.buildDashboard(session),
          );
        }
        return MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          home: widget.buildLogin((session) {
            setState(() => _session = session);
          }),
        );
      },
    );
  }
}
