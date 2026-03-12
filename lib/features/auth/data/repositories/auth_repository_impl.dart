import 'package:dio/dio.dart';

import '../../domain/entities/auth_session.dart';
import '../../domain/entities/credentials.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../mappers/auth_mapper.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remote, this._local);

  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  @override
  Future<AuthSession> login(Credentials credentials, {required bool rememberMe}) async {
    final dto = await _remote.login(credentials.email, credentials.password);
    final session = AuthMapper.toAuthSession(dto);
    await _local.saveTokens(
      accessToken: dto.accessToken,
      refreshToken: dto.refreshToken,
    );
    await _local.setRememberMe(rememberMe);
    return session;
  }

  @override
  Future<AuthSession?> refreshSession() async {
    final refreshToken = await _local.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) return null;
    try {
      final dto = await _remote.refresh(refreshToken);
      final session = AuthMapper.toAuthSession(dto);
      await _local.saveTokens(
        accessToken: dto.accessToken,
        refreshToken: dto.refreshToken,
      );
      return session;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) await _local.clearAll();
      rethrow;
    }
  }

  @override
  Future<void> requestPasswordReset(String email) async {
    await _remote.requestPasswordReset(email);
  }

  @override
  Future<AuthSession> socialLogin(String provider, String idToken) async {
    final dto = await _remote.socialLogin(provider, idToken);
    final session = AuthMapper.toAuthSession(dto);
    await _local.saveTokens(
      accessToken: dto.accessToken,
      refreshToken: dto.refreshToken,
    );
    return session;
  }

  @override
  Future<void> logout() async {
    await _local.clearAll();
  }

  @override
  Future<AuthSession?> getCurrentSession() async {
    final accessToken = await _local.getAccessToken();
    if (accessToken != null && accessToken.isNotEmpty) {
      final refreshToken = await _local.getRefreshToken();
      if (refreshToken != null) {
        try {
          return await refreshSession();
        } catch (_) {
          return null;
        }
      }
      // If we only have access token, we could decode and return session;
      // for now we require refresh to restore full session.
    }
    return null;
  }
}
