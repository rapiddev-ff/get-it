import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import 'package:flutter/material.dart';

class FollowerItemWidget extends StatelessWidget {
  const FollowerItemWidget({
    super.key,
    required this.userId,
    required this.username,
    this.avatarUrl,
    this.onMessageTap,
    this.onTap,
  });

  final String userId;
  final String username;
  final String? avatarUrl;
  final VoidCallback? onMessageTap;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 40.0,
                height: 40.0,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: avatarUrl != null && avatarUrl!.isNotEmpty
                    ? Image.network(
                        avatarUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _defaultAvatar(),
                      )
                    : _defaultAvatar(),
              ),
              Expanded(
                child: Text(
                  '@$username',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              GestureDetector(
                onTap: onMessageTap,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.brandPurple, AppColors.brandBlue],
                      stops: [0.0, 1.0],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                    child: Text(
                      'Message',
                      style: Theme.of(context).textTheme.bodyMedium!,
                    ),
                  ),
                ),
              ),
            ].divide(SizedBox(width: 12.0)),
          ),
        ),
      ),
    );
  }

  Widget _defaultAvatar() {
    return Container(
      color: AppColors.neutral700,
      child: Icon(
        Icons.person,
        color: AppColors.textSecondary,
        size: 24.0,
      ),
    );
  }
}
