import 'package:flutter/material.dart';

import '../../domain/repositories/auth_repository.dart';

/// Login screen: email, password (masked), Remember Me, Submit.
/// Full UI and error mapping in Phase 3; this is a minimal placeholder for bootstrap.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key, required this.authRepository});

  final AuthRepository authRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: const Center(child: Text('Login screen (wire form in Phase 3)')),
    );
  }
}
