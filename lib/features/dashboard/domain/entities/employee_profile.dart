/// Domain entity: employee profile (display name, role, online status).
/// No Flutter/platform imports.
class EmployeeProfile {
  const EmployeeProfile({
    required this.id,
    required this.displayName,
    required this.role,
    required this.onlineStatus,
    this.avatarUrl,
  });

  final String id;
  final String displayName;
  final String role;
  final OnlineStatus onlineStatus;
  final String? avatarUrl;

  EmployeeProfile copyWith({
    String? id,
    String? displayName,
    String? role,
    OnlineStatus? onlineStatus,
    String? avatarUrl,
  }) {
    return EmployeeProfile(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      onlineStatus: onlineStatus ?? this.onlineStatus,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmployeeProfile &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          displayName == other.displayName &&
          role == other.role &&
          onlineStatus == other.onlineStatus &&
          avatarUrl == other.avatarUrl;

  @override
  int get hashCode =>
      Object.hash(id, displayName, role, onlineStatus, avatarUrl);
}

enum OnlineStatus { online, offline, away, doNotDisturb }
