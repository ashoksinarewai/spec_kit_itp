import '../../domain/entities/auth_session.dart';
import '../../domain/entities/user.dart';
import '../dto/auth_dto.dart';

/// Map auth DTOs to domain entities.
class AuthMapper {
  static User toUser(UserDto dto) {
    return User(
      id: dto.id,
      email: dto.email,
      displayName: dto.displayName,
    );
  }

  static AuthSession toAuthSession(LoginResponseDto dto) {
    final expiresAt = dto.expiresIn != null
        ? DateTime.now().add(Duration(seconds: dto.expiresIn!))
        : null;
    return AuthSession(
      accessToken: dto.accessToken,
      refreshToken: dto.refreshToken,
      expiresAt: expiresAt,
      user: toUser(dto.user),
    );
  }
}
