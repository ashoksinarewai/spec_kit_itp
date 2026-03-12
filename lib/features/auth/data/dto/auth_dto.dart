/// Login/refresh/social response from backend (per contracts/auth-api.md).
class LoginResponseDto {
  const LoginResponseDto({
    required this.accessToken,
    required this.user,
    this.refreshToken,
    this.expiresIn,
  });

  final String accessToken;
  final String? refreshToken;
  final int? expiresIn;
  final UserDto user;

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) {
    return LoginResponseDto(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String?,
      expiresIn: json['expiresIn'] as int?,
      user: UserDto.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}

class UserDto {
  const UserDto({
    required this.id,
    required this.email,
    this.displayName,
  });

  final String id;
  final String email;
  final String? displayName;

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
    );
  }
}
