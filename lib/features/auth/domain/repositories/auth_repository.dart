import '../entities/auth_session.dart';
import '../entities/credentials.dart';

/// Port for authentication: login, refresh, forgot password, social, logout.
/// Implemented in data layer; domain depends only on this interface.
abstract class AuthRepository {
  Future<AuthSession> login(Credentials credentials, {required bool rememberMe});
  Future<AuthSession?> refreshSession();
  Future<void> requestPasswordReset(String email);
  Future<AuthSession> socialLogin(String provider, String idToken);
  Future<void> logout();
  Future<AuthSession?> getCurrentSession();
}
