import '/core/widgets/app_loading_indicator.dart';
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
import 'package:page_transition/page_transition.dart';
import '/core/router/app_router.dart';

class FollowUser {
  final String userId;
  final String username;
  final String? avatarUrl;
  final String? firstName;
  final String? lastName;
  final DateTime? followedAt;

  FollowUser({
    required this.userId,
    required this.username,
    this.avatarUrl,
    this.firstName,
    this.lastName,
    this.followedAt,
  });

  factory FollowUser.fromJson(Map<String, dynamic> json) {
    return FollowUser(
      userId: json['user_id']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      avatarUrl: json['avatar_url']?.toString(),
      firstName: json['first_name']?.toString(),
      lastName: json['last_name']?.toString(),
      followedAt: json['followed_at'] != null
          ? DateTime.tryParse(json['followed_at'].toString())
          : null,
    );
  }
}

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
  // Local state fields
  String _tabState = 'Followers';
  static const int _pageSize = 20;

  // Search controllers
  late final TextEditingController textController1;
  late final FocusNode textFieldFocusNode1;
  late final TextEditingController textController2;
  late final FocusNode textFieldFocusNode2;

  // Followers state
  List<FollowUser> followers = [];
  int followersTotalCount = 0;
  bool isLoadingFollowers = false;
  bool hasMoreFollowers = true;

  // Following state
  List<FollowUser> following = [];
  int followingTotalCount = 0;
  bool isLoadingFollowing = false;
  bool hasMoreFollowing = true;

  final ScrollController _followersScrollController = ScrollController();
  final ScrollController _followingScrollController = ScrollController();
  bool _initialLoadDone = false;

  @override
  void initState() {
    super.initState();

    textController1 = TextEditingController();
    textFieldFocusNode1 = FocusNode();
    textController2 = TextEditingController();
    textFieldFocusNode2 = FocusNode();

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
    textFieldFocusNode1.dispose();
    textController1.dispose();
    textFieldFocusNode2.dispose();
    textController2.dispose();
    _followersScrollController.dispose();
    _followingScrollController.dispose();
    super.dispose();
  }

  void _onFollowersScroll() {
    if (_followersScrollController.position.pixels >=
            _followersScrollController.position.maxScrollExtent - 200 &&
        !isLoadingFollowers &&
        hasMoreFollowers) {
      _loadFollowers(loadMore: true);
    }
  }

  void _onFollowingScroll() {
    if (_followingScrollController.position.pixels >=
            _followingScrollController.position.maxScrollExtent - 200 &&
        !isLoadingFollowing &&
        hasMoreFollowing) {
      _loadFollowing(loadMore: true);
    }
  }

  Future<void> _loadFollowers({bool loadMore = false}) async {
    if (isLoadingFollowers) return;

    setState(() {
      isLoadingFollowers = true;
    });

    final offset = loadMore ? followers.length : 0;
    final search = textController1.text.trim();

    try {
      final response = await SupaFlow.client.rpc(
        'get_followers',
        params: {
          'p_user_id': ref.read(currentUserIdProvider),
          'p_search': search,
          'p_limit': _pageSize,
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
            followers.addAll(items);
          } else {
            followers = items;
          }
          followersTotalCount = totalCount;
          hasMoreFollowers = followers.length < totalCount;
        });
      }
    } catch (_) {
      // silently fail
    } finally {
      if (mounted) {
        setState(() {
          isLoadingFollowers = false;
        });
      }
    }
  }

  Future<void> _loadFollowing({bool loadMore = false}) async {
    if (isLoadingFollowing) return;

    setState(() {
      isLoadingFollowing = true;
    });

    final offset = loadMore ? following.length : 0;
    final search = textController2.text.trim();

    try {
      final response = await SupaFlow.client.rpc(
        'get_following',
        params: {
          'p_user_id': ref.read(currentUserIdProvider),
          'p_search': search,
          'p_limit': _pageSize,
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
            following.addAll(items);
          } else {
            following = items;
          }
          followingTotalCount = totalCount;
          hasMoreFollowing = following.length < totalCount;
        });
      }
    } catch (_) {
      // silently fail
    } finally {
      if (mounted) {
        setState(() {
          isLoadingFollowing = false;
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
      hintStyle:
          Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 15.0),
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
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              _buildTabBar(),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: _tabState == 'Followers'
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
    final followersLabel = '${_formatCount(followersTotalCount)} Followers';
    final followingLabel = '${_formatCount(followingTotalCount)} Following';

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
                  _tabState = 'Followers';
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
                          color: _tabState == 'Followers'
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                          height: 2.0,
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: (_tabState == 'Followers' ? 1 : 0).toDouble(),
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
                  _tabState = 'Following';
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
                          color: _tabState == 'Following'
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                          height: 2.0,
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: (_tabState == 'Following' ? 1 : 0).toDouble(),
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
    if (!_initialLoadDone && isLoadingFollowers) {
      return Center(
        child: AppLoadingIndicator(),
      );
    }

    // True empty — no followers at all (no search active)
    final searchText = textController1.text.trim();
    if (followersTotalCount == 0 && searchText.isEmpty) {
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
            controller: textController1,
            focusNode: textFieldFocusNode1,
            onChanged: (_) => _onFollowersSearchChanged(),
            autofocus: false,
            obscureText: false,
            decoration: _searchDecoration(hintText: 'Search'),
            style: Theme.of(context).textTheme.bodyMedium!,
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
    if (isLoadingFollowers && followers.isEmpty) {
      return Center(
        child: AppLoadingIndicator(),
      );
    }

    // Search active but no results
    final searchText = textController1.text.trim();
    if (followers.isEmpty && searchText.isNotEmpty) {
      return _buildNoMatchesState(searchText, () {
        textController1.clear();
        _loadFollowers();
      });
    }

    return ListView.separated(
      controller: _followersScrollController,
      padding: EdgeInsets.zero,
      itemCount: followers.length + (hasMoreFollowers ? 1 : 0),
      separatorBuilder: (_, __) => SizedBox(height: 16.0),
      itemBuilder: (context, index) {
        if (index >= followers.length) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: AppLoadingIndicator(),
            ),
          );
        }

        final user = followers[index];
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
    if (!_initialLoadDone && isLoadingFollowing) {
      return Center(
        child: AppLoadingIndicator(),
      );
    }

    // True empty — not following anyone (no search active)
    final searchText = textController2.text.trim();
    if (followingTotalCount == 0 && searchText.isEmpty) {
      return _buildEmptyState(
        icon: Icons.people_outline,
        title: "You're not following anyone yet",
        subtitle: 'Follow sellers you like to keep up with new listings.',
        buttons: [
          _buildGradientButton('Discover Sellers', () {
            context.goNamed(
              'homePage',
              extra: <String, dynamic>{
                kTransitionInfoKey: TransitionInfo(
                  hasTransition: true,
                  transitionType: PageTransitionType.fade,
                  duration: Duration(milliseconds: 0),
                ),
              },
            );
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
            controller: textController2,
            focusNode: textFieldFocusNode2,
            onChanged: (_) => _onFollowingSearchChanged(),
            autofocus: false,
            obscureText: false,
            decoration: _searchDecoration(hintText: 'Search'),
            style: Theme.of(context).textTheme.bodyMedium!,
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
    if (isLoadingFollowing && following.isEmpty) {
      return Center(
        child: AppLoadingIndicator(),
      );
    }

    // Search active but no results
    final searchText = textController2.text.trim();
    if (following.isEmpty && searchText.isNotEmpty) {
      return _buildNoMatchesState(searchText, () {
        textController2.clear();
        _loadFollowing();
      });
    }

    return ListView.separated(
      controller: _followingScrollController,
      padding: EdgeInsets.zero,
      itemCount: following.length + (hasMoreFollowing ? 1 : 0),
      separatorBuilder: (_, __) => SizedBox(height: 16.0),
      itemBuilder: (context, index) {
        if (index >= following.length) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: AppLoadingIndicator(),
            ),
          );
        }

        final user = following[index];
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
            colors: [AppColors.brandPurple, AppColors.brandBlue],
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
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
