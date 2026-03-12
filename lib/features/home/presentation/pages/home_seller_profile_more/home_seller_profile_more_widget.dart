import '/custom_code/actions/index.dart' as actions;
import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/core/providers/current_user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeSellerProfileMoreWidget extends ConsumerStatefulWidget {
  const HomeSellerProfileMoreWidget({
    super.key,
    required this.userId,
    required this.username,
    required this.isFollowing,
    this.isOwnProfile = false,
    this.onFollowChanged,
    this.onBlocked,
  });

  final String userId;
  final String username;
  final bool isFollowing;
  final bool isOwnProfile;
  final ValueChanged<bool>? onFollowChanged;
  final VoidCallback? onBlocked;

  @override
  ConsumerState<HomeSellerProfileMoreWidget> createState() =>
      _HomeSellerProfileMoreWidgetState();
}

class _HomeSellerProfileMoreWidgetState
    extends ConsumerState<HomeSellerProfileMoreWidget> {
  bool _loading = false;

  Future<void> _shareProfile() async {
    final shareUrl = 'https://getitapp.com/u/${widget.username}';
    await Clipboard.setData(ClipboardData(text: shareUrl));
    if (!mounted) return;
    Navigator.of(context).pop();
    actions.toastificationshow(
        context, 'Copied', 'Profile link copied to clipboard', 'success');
  }

  Future<void> _toggleFollow() async {
    if (_loading) return;
    setState(() => _loading = true);

    try {
      final currentUserId = ref.read(currentUserIdProvider);
      final client = Supabase.instance.client;

      if (widget.isFollowing) {
        // Unfollow
        await client
            .from('follows')
            .delete()
            .eq('follower_id', currentUserId)
            .eq('following_id', widget.userId);
        if (!mounted) return;
        widget.onFollowChanged?.call(false);
        Navigator.of(context).pop();
        actions.toastificationshow(
            context, 'Unfollowed', 'You unfollowed ${widget.username}', 'info');
      } else {
        // Follow
        await client.from('follows').insert({
          'follower_id': currentUserId,
          'following_id': widget.userId,
        });
        if (!mounted) return;
        widget.onFollowChanged?.call(true);
        Navigator.of(context).pop();
        actions.toastificationshow(context, 'Following',
            'You are now following ${widget.username}', 'success');
      }
    } catch (_) {
      if (!mounted) return;
      Navigator.of(context).pop();
      actions.toastificationshow(
          context, 'Error', 'Something went wrong', 'error');
    }
  }

  Future<void> _blockUser() async {
    if (_loading) return;
    setState(() => _loading = true);

    try {
      await actions.callRpc(
        context,
        'block_user',
        <String, String>{
          'p_blocked_id': widget.userId,
        },
      );
      if (!mounted) return;
      widget.onBlocked?.call();
      Navigator.of(context).pop();
      actions.toastificationshow(
          context, 'Blocked', 'User has been blocked', 'success');
    } catch (_) {
      if (!mounted) return;
      Navigator.of(context).pop();
      actions.toastificationshow(
          context, 'Error', 'Something went wrong', 'error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium!;

    return Container(
      width: 203.0,
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Share Profile (always visible)
            InkWell(
              onTap: _shareProfile,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: FaIcon(
                      FontAwesomeIcons.share,
                      color: AppColors.textPrimary,
                      size: 20.0,
                    ),
                  ),
                  Text('Share Profile', style: textStyle),
                ].divide(SizedBox(width: 16.0)),
              ),
            ),
            // Follow / Unfollow (hidden for own profile)
            if (!widget.isOwnProfile) ...[
              Divider(
                height: 1.0,
                thickness: 1.0,
                color: AppColors.neutral800,
              ),
              InkWell(
                onTap: _toggleFollow,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Icon(
                        Icons.person_add_alt,
                        color: AppColors.textPrimary,
                        size: 20.0,
                      ),
                    ),
                    Text(
                      widget.isFollowing ? 'Unfollow User' : 'Follow User',
                      style: textStyle,
                    ),
                  ].divide(SizedBox(width: 16.0)),
                ),
              ),
              Divider(
                height: 1.0,
                thickness: 1.0,
                color: AppColors.neutral800,
              ),
              // Block User
              InkWell(
                onTap: _blockUser,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Icon(
                        Icons.block_sharp,
                        color: AppColors.textPrimary,
                        size: 20.0,
                      ),
                    ),
                    Text('Block User', style: textStyle),
                  ].divide(SizedBox(width: 16.0)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
