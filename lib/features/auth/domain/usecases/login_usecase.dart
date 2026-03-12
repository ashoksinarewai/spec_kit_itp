import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../entities/auth_session.dart';
import '../entities/credentials.dart';
import '../repositories/auth_repository.dart';

/// Validates credentials (non-empty), calls AuthRepository.login, returns session or throws.
class LoginUseCase {
  LoginUseCase(this._repository);

  final AuthRepository _repository;

  /// Returns [AuthSession] on success. Throws [AuthFailure] on validation or API error.
  Future<AuthSession> execute(Credentials credentials, {required bool rememberMe}) async {
    if (!credentials.isNotEmpty) {
      throw const AuthFailure('Email and password are required.');
    }
    try {
      return await _repository.login(credentials, rememberMe: rememberMe);
    } on DioException catch (e) {
      throw AuthFailure(ApiClient.mapErrorToUserMessage(e));
    }
  }
}

class AuthFailure implements Exception {
  const AuthFailure(this.message);
  final String message;
}
