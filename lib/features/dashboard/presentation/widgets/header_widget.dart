import 'package:flutter/material.dart';

import '../../domain/entities/employee_profile.dart';

/// Displays user profile: name, role, online status with indicator.
class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key, this.profile});

  final EmployeeProfile? profile;

  @override
  Widget build(BuildContext context) {
    if (profile == null) {
      return _buildSkeleton(context);
    }
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: theme.colorScheme.primaryContainer,
            backgroundImage: profile!.avatarUrl != null
                ? NetworkImage(profile!.avatarUrl!)
                : null,
            child: profile!.avatarUrl == null
                ? Text(
                    profile!.displayName.isNotEmpty
                        ? profile!.displayName[0].toUpperCase()
                        : '?',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  profile!.displayName,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (profile!.role.isNotEmpty)
                  Text(
                    profile!.role,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _statusColor(profile!.onlineStatus),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _statusLabel(profile!.onlineStatus),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: _statusColor(profile!.onlineStatus),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeleton(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 20,
                  width: 160,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 14,
                  width: 100,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Color _statusColor(OnlineStatus status) {
    return switch (status) {
      OnlineStatus.online => Colors.green,
      OnlineStatus.offline => Colors.grey,
      OnlineStatus.away => Colors.orange,
      OnlineStatus.doNotDisturb => Colors.red,
    };
  }

  static String _statusLabel(OnlineStatus status) {
    return switch (status) {
      OnlineStatus.online => 'Online',
      OnlineStatus.offline => 'Offline',
      OnlineStatus.away => 'Away',
      OnlineStatus.doNotDisturb => 'Do not disturb',
    };
  }
}
