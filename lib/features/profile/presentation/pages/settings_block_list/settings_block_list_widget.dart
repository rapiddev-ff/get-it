import '/core/widgets/app_loading_indicator.dart';
import '/backend/supabase/supabase.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/dismiss_keyboard.dart';
import '/custom_code/actions/index.dart' as actions;
import '/features/profile/presentation/pages/settings_blocked_user_item/settings_blocked_user_item_widget.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import '/core/providers/current_user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingsBlockListWidget extends ConsumerStatefulWidget {
  const SettingsBlockListWidget({super.key});

  static String routeName = 'settingsBlockList';
  static String routePath = 'settingsBlockList';

  @override
  ConsumerState<SettingsBlockListWidget> createState() =>
      _SettingsBlockListWidgetState();
}

class _SettingsBlockListWidgetState
    extends ConsumerState<SettingsBlockListWidget> {
  late final TextEditingController textController;
  late final FocusNode textFieldFocusNode;

  /// Combined blocked user data: blocked_users row + user_profiles data.
  List<_BlockedUserInfo>? _blockedUsers;
  bool _isLoading = true;
  String? _unblockingId;

  @override
  void initState() {
    super.initState();

    textController = TextEditingController();
    textFieldFocusNode = FocusNode();
    _loadBlockedUsers();
  }

  @override
  void dispose() {
    textFieldFocusNode.dispose();
    textController.dispose();
    super.dispose();
  }

  Future<void> _loadBlockedUsers() async {
    setState(() => _isLoading = true);
    try {
      final rows = await BlockedUsersTable().queryRows(
        queryFn: (q) =>
            q.eqOrNull('blocker_id', ref.read(currentUserIdProvider)),
      );

      if (rows.isEmpty) {
        if (mounted)
          setState(() {
            _blockedUsers = [];
            _isLoading = false;
          });
        return;
      }

      // Fetch profiles for all blocked user IDs
      final blockedIds = rows.map((r) => r.blockedId).toList();
      final profiles = await UserProfilesTable().queryRows(
        queryFn: (q) => q.inFilterOrNull('user_id', blockedIds),
      );

      final profileMap = <String, UserProfilesRow>{};
      for (final p in profiles) {
        profileMap[p.userId] = p;
      }

      final result = rows.map((row) {
        final profile = profileMap[row.blockedId];
        return _BlockedUserInfo(
          id: row.id,
          blockedId: row.blockedId,
          username: profile?.username ?? 'Unknown',
          avatarUrl: profile?.avatarUrl ?? '',
          blockedAt: row.createdAt,
        );
      }).toList();

      if (mounted)
        setState(() {
          _blockedUsers = result;
          _isLoading = false;
        });
    } catch (e) {
      if (mounted)
        setState(() {
          _blockedUsers = [];
          _isLoading = false;
        });
    }
  }

  Future<void> _unblockUser(_BlockedUserInfo user) async {
    setState(() => _unblockingId = user.id);
    try {
      await BlockedUsersTable().delete(
        matchingRows: (rows) => rows.eqOrNull('id', user.id),
      );
      if (!mounted) return;
      _blockedUsers?.removeWhere((u) => u.id == user.id);
      setState(() => _unblockingId = null);
      await actions.toastificationshow(
        context,
        'Unblocked',
        '@${user.username} has been unblocked.',
        'success',
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _unblockingId = null);
      await actions.toastificationshow(
        context,
        'Error',
        'Failed to unblock user.',
        'error',
      );
    }
  }

  List<_BlockedUserInfo> get _filteredUsers {
    final all = _blockedUsers ?? [];
    final query = textController.text.toLowerCase();
    if (query.isEmpty) return all;
    return all.where((u) => u.username.toLowerCase().contains(query)).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: SizedBox(
            width: 50.0,
            height: 50.0,
            child: AppLoadingIndicator(),
          ),
        ),
      );
    }

    final blockedUsers = _filteredUsers;

    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.backgroundSecondary,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 24.0,
            ),
            onPressed: () async {
              context.pop();
            },
          ),
          title: Text(
            'Block List',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w500, color: Colors.white, height: 1.5),
          ),
        ),
        body: SafeArea(
          child: (_blockedUsers?.isEmpty ?? true) &&
                  textController.text.isEmpty
              ? _buildEmptyState()
              : _buildBlockedList(blockedUsers),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.block,
                  size: 64.0,
                  color: AppColors.textSecondary,
                ),
                SizedBox(height: 16.0),
                Text(
                  'No blocked users',
                  style: Theme.of(context).textTheme.titleMedium!,
                ),
              ],
            ),
          ),
        ),
        _buildAboutBlockingCard(),
        SizedBox(height: 24.0),
      ],
    );
  }

  Widget _buildBlockedList(List<_BlockedUserInfo> blockedUsers) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Blocked Users',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.w500, height: 1.5),
            ),
            Text(
              'Manage who can contact and buy from you',
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(height: 1.5),
            ),
            Padding(
              padding: EdgeInsets.only(top: 24.0),
              child: Container(
                width: double.infinity,
                child: TextFormField(
                  controller: textController,
                  focusNode: textFieldFocusNode,
                  onChanged: (_) => EasyDebounce.debounce(
                    'textController',
                    Duration(milliseconds: 100),
                    () => setState(() {}),
                  ),
                  autofocus: false,
                  obscureText: false,
                  decoration: InputDecoration(
                    isDense: false,
                    hintText: 'Search blocked users...',
                    hintStyle: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(fontSize: 15.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.neutral700,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.secondary,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.error,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.error,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 24.0,
                    ),
                  ),
                  style: Theme.of(context).textTheme.bodyMedium!,
                  cursorColor: AppColors.textPrimary,
                  enableInteractiveSelection: true,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: blockedUsers.isEmpty
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text(
                          'No matching blocked users',
                          style: Theme.of(context).textTheme.labelMedium!,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.zero,
                      primary: false,
                      shrinkWrap: true,
                      itemCount: blockedUsers.length,
                      separatorBuilder: (_, __) => SizedBox(height: 16.0),
                      itemBuilder: (context, index) {
                        final user = blockedUsers[index];
                        return SettingsBlockedUserItemWidget(
                          key: Key('blocked_${user.id}'),
                          username: user.username,
                          avatarUrl: user.avatarUrl,
                          blockedAt: user.blockedAt,
                          isUnblocking: _unblockingId == user.id,
                          onUnblock: () => _unblockUser(user),
                        );
                      },
                    ),
            ),
            Divider(
              height: 48.0,
              thickness: 2.0,
              color: AppColors.surfaceDark,
            ),
            _buildAboutBlockingCard(),
          ].addToStart(SizedBox(height: 28.0)),
        ),
      ),
    );
  }

  Widget _buildAboutBlockingCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline,
                color: AppColors.primary,
                size: 24.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About Blocking',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.w500, height: 1.5),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Blocked users cannot send you messages, view your full profile, or purchase items from you. They won\'t be notified that they\'ve been blocked.',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
            ].divide(SizedBox(width: 12.0)),
          ),
        ),
      ),
    );
  }
}

/// Internal data class for combining blocked_users + user_profiles data.
class _BlockedUserInfo {
  final String id;
  final String blockedId;
  final String username;
  final String avatarUrl;
  final DateTime? blockedAt;

  _BlockedUserInfo({
    required this.id,
    required this.blockedId,
    required this.username,
    required this.avatarUrl,
    required this.blockedAt,
  });
}
