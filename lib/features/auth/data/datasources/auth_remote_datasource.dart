import '../../../../core/network/api_client.dart';
import '../dto/auth_dto.dart';

/// Remote auth API: login, refresh, forgot-password, social per contracts/auth-api.md.
class AuthRemoteDataSource {
  AuthRemoteDataSource(this._client);

  final ApiClient _client;

  static const _loginPath = '/auth/login';
  static const _refreshPath = '/auth/refresh';
  static const _forgotPasswordPath = '/auth/forgot-password';
  static const _socialPath = '/auth/social';

  Future<LoginResponseDto> login(String email, String password) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      _loginPath,
      data: {'email': email, 'password': password},
    );
    return LoginResponseDto.fromJson(response.data!);
  }

  Future<LoginResponseDto> refresh(String refreshToken) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      _refreshPath,
      data: {'refreshToken': refreshToken},
    );
    return LoginResponseDto.fromJson(response.data!);
  }

  Future<void> requestPasswordReset(String email) async {
    await _client.dio.post(
      _forgotPasswordPath,
      data: {'email': email},
    );
  }

  Future<LoginResponseDto> socialLogin(String provider, String idToken) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      _socialPath,
      data: {'provider': provider, 'idToken': idToken},
    );
    return LoginResponseDto.fromJson(response.data!);
  }
}
