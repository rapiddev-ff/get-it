import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/custom_code/actions/index.dart' as actions;
import '/core/providers/current_user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '/features/messages/presentation/providers/messages_provider.dart';

class ChatMoreWidget extends ConsumerStatefulWidget {
  const ChatMoreWidget({
    super.key,
    required this.conversationId,
    required this.userId,
  });

  final String? conversationId;
  final String? userId;

  @override
  ConsumerState<ChatMoreWidget> createState() => _ChatMoreWidgetState();
}

class _ChatMoreWidgetState extends ConsumerState<ChatMoreWidget> {
  bool _loading = false;
  bool? _isFollowing;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _checkFollowStatus();
  }

  Future<void> _checkFollowStatus() async {
    if (widget.userId == null) return;
    try {
      final currentUserId = ref.read(currentUserIdProvider);
      final result = await Supabase.instance.client
          .from('follows')
          .select('id')
          .eq('follower_id', currentUserId)
          .eq('following_id', widget.userId!)
          .maybeSingle();
      if (!mounted) return;
      setState(() => _isFollowing = result != null);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isFollowing = false);
    }
  }

  Future<void> _toggleFollow() async {
    if (_loading || _isFollowing == null) return;
    setState(() => _loading = true);

    try {
      final currentUserId = ref.read(currentUserIdProvider);
      final client = Supabase.instance.client;

      if (_isFollowing!) {
        await client
            .from('follows')
            .delete()
            .eq('follower_id', currentUserId)
            .eq('following_id', widget.userId!);
        if (!mounted) return;
        Navigator.of(context).pop();
        actions.toastificationshow(
            context, 'Unfollowed', 'You unfollowed this user', 'info');
      } else {
        await client.from('follows').insert({
          'follower_id': currentUserId,
          'following_id': widget.userId,
        });
        if (!mounted) return;
        Navigator.of(context).pop();
        actions.toastificationshow(
            context, 'Following', 'You are now following this user', 'success');
      }
    } catch (_) {
      if (!mounted) return;
      Navigator.of(context).pop();
      actions.toastificationshow(
          context, 'Error', 'Something went wrong', 'error');
    }
  }

  Future<void> _deleteConversation() async {
    if (_isDeleting) return;
    setState(() => _isDeleting = true);

    try {
      await Supabase.instance.client.rpc(
        'delete_conversation',
        params: {'p_conversation_id': widget.conversationId!},
      );
      // Remove from local state so the list updates immediately
      final convs = ref.read(messagesProvider).conversations;
      final updated = convs
          .where((c) => c.id != widget.conversationId)
          .toList();
      ref.read(messagesProvider.notifier).setConversations(updated);
      if (!mounted) return;
      Navigator.of(context).pop();
      actions.toastificationshow(
          context, 'Deleted', 'Conversation deleted', 'success');
      if (!mounted) return;
      context.pop();
    } catch (_) {
      if (!mounted) return;
      Navigator.of(context).pop();
      actions.toastificationshow(
          context, 'Error', 'Could not delete conversation', 'error');
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
          'p_blocked_id': widget.userId!,
        },
      );
      if (!mounted) return;
      Navigator.of(context).pop();
      actions.toastificationshow(
          context, 'Blocked', 'User has been blocked', 'success');
      if (!mounted) return;
      context.pop();
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
        borderRadius: BorderRadius.circular(12.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: _toggleFollow,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Icon(
                      _isFollowing == true
                          ? Icons.person_remove_alt_1
                          : Icons.person_add_alt,
                      color: AppColors.textPrimary,
                      size: 20.0,
                    ),
                  ),
                  Text(
                    _isFollowing == true ? 'Unfollow User' : 'Follow User',
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
            InkWell(
              onTap: _deleteConversation,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Icon(
                      Icons.delete_outline,
                      color: AppColors.error,
                      size: 20.0,
                    ),
                  ),
                  Text('Delete Chat',
                      style: textStyle.copyWith(color: AppColors.error)),
                ].divide(SizedBox(width: 16.0)),
              ),
            ),
            Divider(
              height: 1.0,
              thickness: 1.0,
              color: AppColors.neutral800,
            ),
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
        ),
      ),
    );
  }
}
