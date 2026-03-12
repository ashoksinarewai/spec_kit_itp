import '../../../../core/network/api_client.dart';
import '../dto/auth_dto.dart';

/// Contract for remote auth: same interface for API and mock (per contracts/auth-api.md).
abstract class AuthRemoteDataSource {
  Future<LoginResponseDto> login(String email, String password);
  Future<LoginResponseDto> refresh(String refreshToken);
  Future<void> requestPasswordReset(String email);
  Future<LoginResponseDto> socialLogin(String provider, String idToken);
}

/// Live implementation: calls backend REST API.
class ApiAuthRemoteDataSource implements AuthRemoteDataSource {
  ApiAuthRemoteDataSource(this._client);

  final ApiClient _client;

  static const _loginPath = '/auth/login';
  static const _refreshPath = '/auth/refresh';
  static const _forgotPasswordPath = '/auth/forgot-password';
  static const _socialPath = '/auth/social';

  @override
  Future<LoginResponseDto> login(String email, String password) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      _loginPath,
      data: {'email': email, 'password': password},
    );
    return LoginResponseDto.fromJson(response.data!);
  }

  @override
  Future<LoginResponseDto> refresh(String refreshToken) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      _refreshPath,
      data: {'refreshToken': refreshToken},
    );
    return LoginResponseDto.fromJson(response.data!);
  }

  @override
  Future<void> requestPasswordReset(String email) async {
    await _client.dio.post(
      _forgotPasswordPath,
      data: {'email': email},
    );
  }

  @override
  Future<LoginResponseDto> socialLogin(String provider, String idToken) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      _socialPath,
      data: {'provider': provider, 'idToken': idToken},
    );
    return LoginResponseDto.fromJson(response.data!);
  }
}
