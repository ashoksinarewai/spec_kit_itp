/// Mock auth data aligned with [contracts/auth-api.md] and [data-model.md].
/// Use for tests, fake datasources, or offline/demo flows.
library;

import '../dto/auth_dto.dart';

// ---------------------------------------------------------------------------
// Raw JSON (matches API success response shapes from auth-api.md)
// ---------------------------------------------------------------------------

/// Login / refresh / social success response as raw JSON.
Map<String, dynamic> get loginResponseJson => {
      'accessToken': 'mock_access_token_${DateTime.now().millisecondsSinceEpoch}',
      'refreshToken': 'mock_refresh_token_abc123',
      'expiresIn': 3600,
      'user': userJson,
    };

/// User object as in API response (id, email, displayName optional).
Map<String, dynamic> get userJson => {
      'id': 'user-mock-001',
      'email': 'employee@company.com',
      'displayName': 'Jane Doe',
    };

/// Login response without refresh token (e.g. when Remember Me is off).
Map<String, dynamic> get loginResponseNoRefreshJson => {
      'accessToken': 'mock_access_token_no_refresh',
      'expiresIn': 900,
      'user': userJson,
    };

/// User with no displayName (optional per contract).
Map<String, dynamic> get userMinimalJson => {
      'id': 'user-mock-002',
      'email': 'minimal@company.com',
    };

/// Social login success — same shape as login (per auth-api §4).
Map<String, dynamic> get socialLoginResponseJson => {
      'accessToken': 'mock_social_access_token',
      'refreshToken': 'mock_social_refresh_token',
      'expiresIn': 7200,
      'user': {
        'id': 'user-google-001',
        'email': 'jane@gmail.com',
        'displayName': 'Jane (Google)',
      },
    };

// ---------------------------------------------------------------------------
// DTO instances (for repositories, use cases, or UI tests)
// ---------------------------------------------------------------------------

UserDto get mockUserDto => const UserDto(
      id: 'user-mock-001',
      email: 'employee@company.com',
      displayName: 'Jane Doe',
    );

UserDto get mockUserMinimalDto => const UserDto(
      id: 'user-mock-002',
      email: 'minimal@company.com',
      displayName: null,
    );

LoginResponseDto get mockLoginResponseDto => LoginResponseDto(
      accessToken: 'mock_access_token_${DateTime.now().millisecondsSinceEpoch}',
      refreshToken: 'mock_refresh_token_abc123',
      expiresIn: 3600,
      user: mockUserDto,
    );

LoginResponseDto get mockLoginResponseNoRefreshDto => LoginResponseDto(
      accessToken: 'mock_access_token_no_refresh',
      refreshToken: null,
      expiresIn: 900,
      user: mockUserDto,
    );

LoginResponseDto get mockSocialLoginResponseDto => const LoginResponseDto(
      accessToken: 'mock_social_access_token',
      refreshToken: 'mock_social_refresh_token',
      expiresIn: 7200,
      user: UserDto(
        id: 'user-google-001',
        email: 'jane@gmail.com',
        displayName: 'Jane (Google)',
      ),
    );
