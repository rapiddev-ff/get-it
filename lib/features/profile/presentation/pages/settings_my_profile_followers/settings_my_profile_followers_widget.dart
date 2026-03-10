import '/features/home/presentation/widgets/components/follower_item_widget.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/dismiss_keyboard.dart';
import '/backend/supabase/supabase.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import '/core/providers/current_user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:toastification/toastification.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'settings_my_profile_followers_model.dart';
export 'settings_my_profile_followers_model.dart';

class SettingsMyProfileFollowersWidget extends ConsumerStatefulWidget {
  const SettingsMyProfileFollowersWidget({super.key});

  static String routeName = 'settingsMyProfileFollowers';
  static String routePath = 'settingsMyProfileFollowers';

  @override
  ConsumerState<SettingsMyProfileFollowersWidget> createState() =>
      _SettingsMyProfileFollowersWidgetState();
}

class _SettingsMyProfileFollowersWidgetState
    extends ConsumerState<SettingsMyProfileFollowersWidget> {
  late SettingsMyProfileFollowersModel _model;

  final ScrollController _followersScrollController = ScrollController();
  final ScrollController _followingScrollController = ScrollController();
  bool _initialLoadDone = false;

  @override
  void initState() {
    super.initState();
    _model = SettingsMyProfileFollowersModel();

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();
    _model.textFieldFocusNode1!.addListener(() => setState(() {}));
    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();
    _model.textFieldFocusNode2!.addListener(() => setState(() {}));

    _followersScrollController.addListener(_onFollowersScroll);
    _followingScrollController.addListener(_onFollowingScroll);

    _loadInitial();
  }

  Future<void> _loadInitial() async {
    await Future.wait([_loadFollowers(), _loadFollowing()]);
    if (mounted) {
      setState(() {
        _initialLoadDone = true;
      });
    }
  }

  @override
  void dispose() {
    _model.dispose();
    _followersScrollController.dispose();
    _followingScrollController.dispose();
    super.dispose();
  }

  void _onFollowersScroll() {
    if (_followersScrollController.position.pixels >=
            _followersScrollController.position.maxScrollExtent - 200 &&
        !_model.isLoadingFollowers &&
        _model.hasMoreFollowers) {
      _loadFollowers(loadMore: true);
    }
  }

  void _onFollowingScroll() {
    if (_followingScrollController.position.pixels >=
            _followingScrollController.position.maxScrollExtent - 200 &&
        !_model.isLoadingFollowing &&
        _model.hasMoreFollowing) {
      _loadFollowing(loadMore: true);
    }
  }

  Future<void> _loadFollowers({bool loadMore = false}) async {
    if (_model.isLoadingFollowers) return;

    setState(() {
      _model.isLoadingFollowers = true;
    });

    final offset = loadMore ? _model.followers.length : 0;
    final search = _model.textController1?.text.trim() ?? '';

    try {
      final response = await SupaFlow.client.rpc(
        'get_followers',
        params: {
          'p_user_id': ref.read(currentUserIdProvider),
          'p_search': search,
          'p_limit': SettingsMyProfileFollowersModel.pageSize,
          'p_offset': offset,
        },
      );

      if (response != null) {
        final totalCount = (response['total_count'] as num?)?.toInt() ?? 0;
        final items = (response['items'] as List?)
                ?.map((e) => FollowUser.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [];

        setState(() {
          if (loadMore) {
            _model.followers.addAll(items);
          } else {
            _model.followers = items;
          }
          _model.followersTotalCount = totalCount;
          _model.hasMoreFollowers = _model.followers.length < totalCount;
        });
      }
    } catch (_) {
      // silently fail
    } finally {
      if (mounted) {
        setState(() {
          _model.isLoadingFollowers = false;
        });
      }
    }
  }

  Future<void> _loadFollowing({bool loadMore = false}) async {
    if (_model.isLoadingFollowing) return;

    setState(() {
      _model.isLoadingFollowing = true;
    });

    final offset = loadMore ? _model.following.length : 0;
    final search = _model.textController2?.text.trim() ?? '';

    try {
      final response = await SupaFlow.client.rpc(
        'get_following',
        params: {
          'p_user_id': ref.read(currentUserIdProvider),
          'p_search': search,
          'p_limit': SettingsMyProfileFollowersModel.pageSize,
          'p_offset': offset,
        },
      );

      if (response != null) {
        final totalCount = (response['total_count'] as num?)?.toInt() ?? 0;
        final items = (response['items'] as List?)
                ?.map((e) => FollowUser.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [];

        setState(() {
          if (loadMore) {
            _model.following.addAll(items);
          } else {
            _model.following = items;
          }
          _model.followingTotalCount = totalCount;
          _model.hasMoreFollowing = _model.following.length < totalCount;
        });
      }
    } catch (_) {
      // silently fail
    } finally {
      if (mounted) {
        setState(() {
          _model.isLoadingFollowing = false;
        });
      }
    }
  }

  void _onFollowersSearchChanged() {
    EasyDebounce.debounce(
      'followers_search',
      Duration(milliseconds: 400),
      () => _loadFollowers(),
    );
    setState(() {});
  }

  void _onFollowingSearchChanged() {
    EasyDebounce.debounce(
      'following_search',
      Duration(milliseconds: 400),
      () => _loadFollowing(),
    );
    setState(() {});
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      final val = count / 1000000;
      return val == val.truncateToDouble()
          ? '${val.toInt()}M'
          : '${val.toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      final val = count / 1000;
      return val == val.truncateToDouble()
          ? '${val.toInt()}k'
          : '${val.toStringAsFixed(1)}k';
    }
    return count.toString();
  }

  InputDecoration _searchDecoration({required String hintText}) {
    return InputDecoration(
      isDense: false,
      hintText: hintText,
      hintStyle: GoogleFonts.inter(
        fontWeight: FontWeight.normal,
        fontSize: 15.0,
        color: AppColors.textSecondary,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.neutral700, width: 1.0),
        borderRadius: BorderRadius.circular(4.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.secondary, width: 1.0),
        borderRadius: BorderRadius.circular(4.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.error, width: 1.0),
        borderRadius: BorderRadius.circular(4.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.error, width: 1.0),
        borderRadius: BorderRadius.circular(4.0),
      ),
      prefixIcon: Icon(
        Icons.search,
        color: Colors.white,
        size: 24.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            'My Profile',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              _buildTabBar(),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: _model.state == 'Followers'
                      ? _buildFollowersTab()
                      : _buildFollowingTab(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    final followersLabel =
        '${_formatCount(_model.followersTotalCount)} Followers';
    final followingLabel =
        '${_formatCount(_model.followingTotalCount)} Following';

    return Container(
      width: double.infinity,
      height: 53.0,
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  _model.state = 'Followers';
                  setState(() {});
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        followersLabel,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.normal,
                          color: _model.state == 'Followers'
                              ? AppColors.textPrimary
                              : Color(0xFFAFAFB4),
                          height: 2.0,
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: (_model.state == 'Followers' ? 1 : 0).toDouble(),
                      child: Container(
                        width: double.infinity,
                        height: 2.0,
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  _model.state = 'Following';
                  setState(() {});
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        followingLabel,
                        style: GoogleFonts.inter(
                          color: _model.state == 'Following'
                              ? AppColors.textPrimary
                              : Color(0xFFAFAFB4),
                          height: 2.0,
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: (_model.state == 'Following' ? 1 : 0).toDouble(),
                      child: Container(
                        width: double.infinity,
                        height: 2.0,
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Followers tab ──────────────────────────────────────────────

  Widget _buildFollowersTab() {
    // Initial loading
    if (!_initialLoadDone && _model.isLoadingFollowers) {
      return Center(
        child: CircularProgressIndicator(color: AppColors.secondary),
      );
    }

    // True empty — no followers at all (no search active)
    final searchText = _model.textController1?.text.trim() ?? '';
    if (_model.followersTotalCount == 0 && searchText.isEmpty) {
      return _buildEmptyState(
        icon: Icons.people_outline,
        title: 'No followers yet',
        subtitle: "When people follow you, they'll show up here.",
        buttons: [
          _buildGradientButton('Share Profile', () {
            _shareProfile();
          }),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 28.0),
        Container(
          width: double.infinity,
          child: TextFormField(
            controller: _model.textController1,
            focusNode: _model.textFieldFocusNode1,
            onChanged: (_) => _onFollowersSearchChanged(),
            autofocus: false,
            obscureText: false,
            decoration: _searchDecoration(hintText: 'Search'),
            style: GoogleFonts.inter(color: AppColors.textPrimary),
            cursorColor: AppColors.textPrimary,
            enableInteractiveSelection: true,
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: _buildFollowersList(),
          ),
        ),
      ],
    );
  }

  Widget _buildFollowersList() {
    if (_model.isLoadingFollowers && _model.followers.isEmpty) {
      return Center(
        child: CircularProgressIndicator(color: AppColors.secondary),
      );
    }

    // Search active but no results
    final searchText = _model.textController1?.text.trim() ?? '';
    if (_model.followers.isEmpty && searchText.isNotEmpty) {
      return _buildNoMatchesState(searchText, () {
        _model.textController1?.clear();
        _loadFollowers();
      });
    }

    return ListView.separated(
      controller: _followersScrollController,
      padding: EdgeInsets.zero,
      itemCount: _model.followers.length + (_model.hasMoreFollowers ? 1 : 0),
      separatorBuilder: (_, __) => SizedBox(height: 16.0),
      itemBuilder: (context, index) {
        if (index >= _model.followers.length) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: CircularProgressIndicator(color: AppColors.secondary),
            ),
          );
        }

        final user = _model.followers[index];
        return FollowerItemWidget(
          userId: user.userId,
          username: user.username,
          avatarUrl: user.avatarUrl,
          onTap: () {
            // Navigate to user profile
          },
          onMessageTap: () {
            // Navigate to messages
          },
        );
      },
    );
  }

  // ── Following tab ──────────────────────────────────────────────

  Widget _buildFollowingTab() {
    // Initial loading
    if (!_initialLoadDone && _model.isLoadingFollowing) {
      return Center(
        child: CircularProgressIndicator(color: AppColors.secondary),
      );
    }

    // True empty — not following anyone (no search active)
    final searchText = _model.textController2?.text.trim() ?? '';
    if (_model.followingTotalCount == 0 && searchText.isEmpty) {
      return _buildEmptyState(
        icon: Icons.people_outline,
        title: "You're not following anyone yet",
        subtitle: 'Follow sellers you like to keep up with new listings.',
        buttons: [
          _buildGradientButton('Discover Sellers', () {
            context.goNamed('homePage');
          }),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 28.0),
        Container(
          width: double.infinity,
          child: TextFormField(
            controller: _model.textController2,
            focusNode: _model.textFieldFocusNode2,
            onChanged: (_) => _onFollowingSearchChanged(),
            autofocus: false,
            obscureText: false,
            decoration: _searchDecoration(hintText: 'Search'),
            style: GoogleFonts.inter(color: AppColors.textPrimary),
            cursorColor: AppColors.textPrimary,
            enableInteractiveSelection: true,
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: _buildFollowingList(),
          ),
        ),
      ],
    );
  }

  Widget _buildFollowingList() {
    if (_model.isLoadingFollowing && _model.following.isEmpty) {
      return Center(
        child: CircularProgressIndicator(color: AppColors.secondary),
      );
    }

    // Search active but no results
    final searchText = _model.textController2?.text.trim() ?? '';
    if (_model.following.isEmpty && searchText.isNotEmpty) {
      return _buildNoMatchesState(searchText, () {
        _model.textController2?.clear();
        _loadFollowing();
      });
    }

    return ListView.separated(
      controller: _followingScrollController,
      padding: EdgeInsets.zero,
      itemCount: _model.following.length + (_model.hasMoreFollowing ? 1 : 0),
      separatorBuilder: (_, __) => SizedBox(height: 16.0),
      itemBuilder: (context, index) {
        if (index >= _model.following.length) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: CircularProgressIndicator(color: AppColors.secondary),
            ),
          );
        }

        final user = _model.following[index];
        return FollowerItemWidget(
          userId: user.userId,
          username: user.username,
          avatarUrl: user.avatarUrl,
          onTap: () {
            // Navigate to user profile
          },
          onMessageTap: () {
            // Navigate to messages
          },
        );
      },
    );
  }

  void _shareProfile() {
    final displayName = ref.read(authProvider).username;
    final username =
        displayName.isNotEmpty ? displayName : ref.read(currentUserIdProvider);
    final profileLink = 'Check out my profile on Get It: @$username';
    Clipboard.setData(ClipboardData(text: profileLink));
    toastification.show(
      context: context,
      title: Text('Profile link copied to clipboard'),
      type: ToastificationType.success,
      autoCloseDuration: Duration(seconds: 3),
    );
  }

  // ── Shared empty / no-match states ─────────────────────────────

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Widget> buttons,
  }) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 64.0,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: 24.0),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium!,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.0),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.labelMedium!,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: buttons.divide(SizedBox(width: 12.0)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoMatchesState(String query, VoidCallback onClear) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off,
              size: 64.0,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: 24.0),
            Text(
              'No matches',
              style: Theme.of(context).textTheme.titleMedium!,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.0),
            Text(
              'We couldn\'t find anyone matching "$query".',
              style: Theme.of(context).textTheme.labelMedium!,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.0),
            _buildGradientButton('Clear Search', onClear),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientButton(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
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
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Text(
            label,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
