import '../datasources/auth_remote_datasource.dart';
import '../dto/auth_dto.dart';
import 'auth_mock_data.dart';

/// Mock implementation of [AuthRemoteDataSource].
/// Same interface as the API; returns mock data so code uses it identically.
class AuthMockRemoteDataSource implements AuthRemoteDataSource {
  @override
  Future<LoginResponseDto> login(String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return LoginResponseDto.fromJson(loginResponseJson);
  }

  @override
  Future<LoginResponseDto> refresh(String refreshToken) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return LoginResponseDto.fromJson(loginResponseJson);
  }

  @override
  Future<void> requestPasswordReset(String email) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }

  @override
  Future<LoginResponseDto> socialLogin(String provider, String idToken) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return LoginResponseDto.fromJson(socialLoginResponseJson);
  }
}
