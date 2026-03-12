import '../../../../core/storage/secure_storage.dart';

/// Keys for auth data in secure storage (no plain-text tokens in logs).
abstract class AuthStorageKeys {
  static const accessToken = 'auth_access_token';
  static const refreshToken = 'auth_refresh_token';
  static const rememberMe = 'auth_remember_me';
}

/// Local auth state: tokens and rememberMe via SecureStorage.
class AuthLocalDataSource {
  AuthLocalDataSource(this._storage);

  final SecureStorage _storage;

  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await _storage.write(AuthStorageKeys.accessToken, accessToken);
    if (refreshToken != null) {
      await _storage.write(AuthStorageKeys.refreshToken, refreshToken);
    }
  }

  Future<void> setRememberMe(bool value) async {
    await _storage.write(AuthStorageKeys.rememberMe, value ? 'true' : 'false');
  }

  Future<String?> getAccessToken() => _storage.read(AuthStorageKeys.accessToken);
  Future<String?> getRefreshToken() => _storage.read(AuthStorageKeys.refreshToken);

  Future<bool> getRememberMe() async {
    final v = await _storage.read(AuthStorageKeys.rememberMe);
    return v == 'true';
  }

  Future<void> clearAll() => _storage.deleteAll();
}
