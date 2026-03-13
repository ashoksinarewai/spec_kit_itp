import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/employee_profile.dart';

part 'employee_profile_model.g.dart';

@JsonSerializable()
class EmployeeProfileModel {
  const EmployeeProfileModel({
    required this.id,
    required this.displayName,
    required this.role,
    required this.onlineStatus,
    this.avatarUrl,
  });

  final String id;
  final String displayName;
  final String role;
  final String onlineStatus;
  final String? avatarUrl;

  factory EmployeeProfileModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeeProfileModelFromJson(json);
  Map<String, dynamic> toJson() => _$EmployeeProfileModelToJson(this);

  EmployeeProfile toEntity() {
    return EmployeeProfile(
      id: id,
      displayName: displayName,
      role: role,
      onlineStatus: _parseOnlineStatus(onlineStatus),
      avatarUrl: avatarUrl,
    );
  }

  static OnlineStatus _parseOnlineStatus(String value) {
    return switch (value.toLowerCase()) {
      'online' => OnlineStatus.online,
      'offline' => OnlineStatus.offline,
      'away' => OnlineStatus.away,
      'do_not_disturb' => OnlineStatus.doNotDisturb,
      _ => OnlineStatus.offline,
    };
  }
}
