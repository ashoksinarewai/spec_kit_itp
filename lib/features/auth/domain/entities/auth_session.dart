import 'user.dart';

/// Authenticated session: tokens and user. Persisted via secure storage when Remember Me.
class AuthSession {
  const AuthSession({
    required this.accessToken,
    required this.user,
    this.refreshToken,
    this.expiresAt,
  });

  final String accessToken;
  final String? refreshToken;
  final DateTime? expiresAt;
  final User user;
}
