import 'package:flutter/material.dart';

import 'core/auth/auth_bootstrap.dart';
import 'core/network/api_client.dart';
import 'core/storage/secure_storage_impl.dart';
import 'features/auth/data/datasources/auth_local_datasource.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/mock/auth_mock_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/dashboard_placeholder_screen.dart';
import 'features/auth/presentation/login/login_screen.dart';

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
    const useMockAuth = bool.fromEnvironment(
      'USE_MOCK_AUTH',
      defaultValue: false,
    );
    final secureStorage = SecureStorageImpl();
    final localDataSource = AuthLocalDataSource(secureStorage);
    final AuthRemoteDataSource remoteDataSource = useMockAuth
        ? AuthMockRemoteDataSource()
        : ApiAuthRemoteDataSource(ApiClient(baseUrl: baseUrl));
    final AuthRepository authRepository =
        AuthRepositoryImpl(remoteDataSource, localDataSource);

    return AuthBootstrap(
      repository: authRepository,
      buildLogin: (onLoginSuccess) => LoginScreen(
        authRepository: authRepository,
        onLoginSuccess: onLoginSuccess,
      ),
      buildDashboard: (session) =>
          DashboardPlaceholderScreen(session: session),
    );
  }
}
