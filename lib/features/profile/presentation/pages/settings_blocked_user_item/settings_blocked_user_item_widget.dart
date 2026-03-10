import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/core/utils/date_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsBlockedUserItemWidget extends StatelessWidget {
  const SettingsBlockedUserItemWidget({
    super.key,
    required this.username,
    required this.avatarUrl,
    required this.blockedAt,
    required this.onUnblock,
    this.isUnblocking = false,
  });

  final String username;
  final String avatarUrl;
  final DateTime? blockedAt;
  final VoidCallback onUnblock;
  final bool isUnblocking;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              child: avatarUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: avatarUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Icon(
                        Icons.person,
                        color: AppColors.textSecondary,
                        size: 24.0,
                      ),
                      errorWidget: (_, __, ___) => Icon(
                        Icons.person,
                        color: AppColors.textSecondary,
                        size: 24.0,
                      ),
                    )
                  : Icon(
                      Icons.person,
                      color: AppColors.textSecondary,
                      size: 24.0,
                    ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '@$username',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),
                  ),
                  if (blockedAt != null)
                    Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Text(
                        'Blocked ${dateTimeFormat("yMMMd", blockedAt!)}',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.normal,
                          fontSize: 14.0,
                          color: Color(0xFFAFAFB4),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            GestureDetector(
              onTap: isUnblocking ? null : onUnblock,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF7D56FF), Color(0xFF6187F1)],
                    stops: [0.0, 1.0],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
                  child: isUnblocking
                      ? SizedBox(
                          width: 16.0,
                          height: 16.0,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            color: Colors.white,
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.unlock,
                              color: AppColors.textPrimary,
                              size: 16.0,
                            ),
                            Text(
                              'Unblock',
                              style: Theme.of(context).textTheme.bodyMedium!,
                            ),
                          ].divide(SizedBox(width: 8.0)),
                        ),
                ),
              ),
            ),
          ].divide(SizedBox(width: 12.0)),
        ),
      ),
    );
  }
}
