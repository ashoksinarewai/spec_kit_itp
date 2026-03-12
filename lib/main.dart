import 'package:flutter/material.dart';

import 'core/auth/auth_bootstrap.dart';
import 'core/storage/secure_storage_impl.dart';
import 'features/auth/data/datasources/auth_local_datasource.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/dashboard_placeholder_screen.dart';
import 'features/auth/presentation/login/login_screen.dart';

import 'core/network/api_client.dart';

void main() {
  runApp(const InTimeProApp());
}

class InTimeProApp extends StatelessWidget {
  const InTimeProApp({super.key});

  @override
  Widget build(BuildContext context) {
    const baseUrl = String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'https://api.example.com',
    );
    final secureStorage = SecureStorageImpl();
    final localDataSource = AuthLocalDataSource(secureStorage);
    final apiClient = ApiClient(baseUrl: baseUrl);
    final remoteDataSource = AuthRemoteDataSource(apiClient);
    final AuthRepository authRepository =
        AuthRepositoryImpl(remoteDataSource, localDataSource);

    return AuthBootstrap(
      repository: authRepository,
      buildLogin: () => LoginScreen(authRepository: authRepository),
      buildDashboard: (session) =>
          DashboardPlaceholderScreen(session: session),
    );
  }
}
