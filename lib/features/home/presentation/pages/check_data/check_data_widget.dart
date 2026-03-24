import '/backend/supabase/supabase.dart';
import '/features/auth/data/supabase_auth/auth_util.dart';
import '/features/auth/domain/models/user_settings_model.dart';
import '/features/browse/domain/models/category_model.dart';
import '/features/browse/domain/models/condition_model.dart';
import '/core/theme/app_colors.dart';
import '/core/router/app_router.dart';
import '/core/widgets/app_gradient_button.dart';
import '/core/widgets/dismiss_keyboard.dart';
import '/core/utils/json_utils.dart' show getJsonField;
import '/custom_code/actions/index.dart' as actions;
import '/core/utils/data_converters.dart' as functions;
import '/features/auth/presentation/pages/welcome/welcome_widget.dart';
import '/features/auth/presentation/pages/sign_in/sign_in_widget.dart';
import '/features/auth/presentation/pages/phone_verification_page/phone_verification_page_widget.dart';
import '/features/auth/presentation/pages/additional_info/additional_info_widget.dart';
import '/features/home/presentation/pages/home_page/home_page_widget.dart';
import 'package:flutter/material.dart';
import '/core/providers/current_user_provider.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import '/features/browse/presentation/providers/browse_provider.dart';

class CheckDataWidget extends ConsumerStatefulWidget {
  const CheckDataWidget({
    super.key,
    bool? fromSignIn,
  }) : this.fromSignIn = fromSignIn ?? false;

  final bool fromSignIn;

  static const String routeName = 'checkData';
  static const String routePath = 'checkData';

  @override
  ConsumerState<CheckDataWidget> createState() => _CheckDataWidgetState();
}

class _CheckDataWidgetState extends ConsumerState<CheckDataWidget>
    with TickerProviderStateMixin {
  // State fields inlined from CheckDataModel.
  dynamic getAppInitialData;
  dynamic getPaymentMethods;

  late final AnimationController _logoController;
  late final AnimationController _itController;
  late final AnimationController _taglineController;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _itFade;
  late final Animation<double> _taglineReveal;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _itController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _taglineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _logoScale = Tween<double>(begin: 2.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutCubic),
    );
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOut),
    );
    _itFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _itController, curve: Curves.easeOut),
    );
    _taglineReveal = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _taglineController, curve: Curves.easeOut),
    );

    _startLogoAnimation();

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final widgetRef = ref;
      await Future.delayed(
        Duration(
          milliseconds: 1500,
        ),
      );
      if (!mounted) return;
      getAppInitialData = await actions.callRpc(
        context,
        'get_app_initial_data',
        <String, String>{
          'p_user_id': ref.read(currentUserIdProvider),
        },
      );
      getPaymentMethods = await actions.getSavedPaymentMethods();
      if (!mounted) return;
      if (getAppInitialData == null) {
        // RPC failed — sign out and send back to welcome
        await authManager.signOut();
        if (!mounted) return;
        context.goNamed(WelcomeWidget.routeName);
        return;
      }
      final userData = functions.convertUserToDataType(
          getAppInitialData!, getPaymentMethods);
      widgetRef.read(authProvider.notifier).setUser(userData);

      // Reset daily budget if it hasn't been reset today
      final settings = userData.userSettings;
      if (settings != null &&
          settings.swipePaymentEnabled &&
          settings.dailyBudget > 0 &&
          settings.dailyBudgetUsed > 0) {
        final now = DateTime.now().toUtc();
        final todayStart = DateTime.utc(now.year, now.month, now.day);
        final resetAt = settings.budgetResetAt;
        if (resetAt == null || resetAt.toUtc().isBefore(todayStart)) {
          widgetRef.read(authProvider.notifier).updateUser(
                (e) => e.copyWith(
                  userSettings:
                      (e.userSettings ?? const UserSettings()).copyWith(
                    dailyBudgetUsed: 0.0,
                    budgetResetAt: now,
                  ),
                ),
              );
          await UserSettingsTable().update(
            data: {
              'daily_budget_used': 0,
              'budget_reset_at': now.toIso8601String(),
            },
            matchingRows: (rows) =>
                rows.eqOrNull('user_id', userData.userId),
          );
        }
      }

      await widgetRef.read(categoriesProvider.notifier).set(
            functions
                .convertCategoriesToDataType(
                    getJsonField(
                      getAppInitialData,
                      r'''$.categories''',
                      true,
                    )!,
                    getJsonField(
                      getAppInitialData,
                      r'''$.subcategories''',
                      true,
                    )!)!
                .toList()
                .cast<Category>(),
          );
      await widgetRef.read(conditionsProvider.notifier).set(
            functions
                .convertConditionsToDataType(getJsonField(
                  getAppInitialData,
                  r'''$.conditions''',
                  true,
                )!)!
                .toList()
                .cast<Condition>(),
          );
      if (!mounted) return;
      setState(() {});
      AppStateNotifier.instance.initialDataLoaded = true;

      // Deleted user — sign out and send to welcome screen
      if (userData.deletedAt != null) {
        await authManager.signOut();
        if (!mounted) return;
        context.goNamed(WelcomeWidget.routeName);
        return;
      }

      // Deactivated user — show reactivation dialog
      if (userData.isDeactivated) {
        if (!mounted) return;
        final shouldReactivate = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) => Dialog(
            backgroundColor: AppColors.backgroundSecondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(dialogContext, false),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(14.0),
                      child: Icon(
                        Icons.waving_hand_rounded,
                        color: AppColors.primary,
                        size: 24.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Reactivate My Account',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.white),
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    'We\'re so happy to see you back!\nYour account was previously deactivated.\nPlease confirm you would like to reactivate your account again!',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(height: 1.5),
                  ),
                  SizedBox(height: 24.0),
                  AppGradientButton(
                    text: 'Reactivate My Account',
                    height: 52.0,
                    borderRadius: 8.0,
                    onPressed: () => Navigator.pop(dialogContext, true),
                  ),
                ],
              ),
            ),
          ),
        );

        if (!mounted) return;
        if (shouldReactivate == true) {
          final result = await actions.reactivateAccount();
          if (!mounted) return;
          if (result['success'] == true) {
            widgetRef.read(authProvider.notifier).updateUser(
                  (e) => e.copyWith(isDeactivated: false),
                );
          } else {
            await authManager.signOut();
            if (!mounted) return;
            context.goNamed(SignInWidget.routeName);
            return;
          }
        } else {
          await authManager.signOut();
          if (!mounted) return;
          context.goNamed(SignInWidget.routeName);
          return;
        }
      }

      if (userData.phoneVerified == false) {
        context.goNamed(
          PhoneVerificationPageWidget.routeName,
          queryParameters: {
            'isOnboarding': 'true',
          },
          extra: <String, dynamic>{
            kTransitionInfoKey: TransitionInfo(
              hasTransition: true,
              transitionType: PageTransitionType.fade,
              duration: Duration(milliseconds: 0),
            ),
          },
        );
      } else if (userData.firstName == '') {
        context.goNamed(
          AdditionalInfoWidget.routeName,
          extra: <String, dynamic>{
            kTransitionInfoKey: TransitionInfo(
              hasTransition: true,
              transitionType: PageTransitionType.fade,
              duration: Duration(milliseconds: 0),
            ),
          },
        );
      } else {
        context.goNamed(
          HomePageWidget.routeName,
          extra: <String, dynamic>{
            kTransitionInfoKey: TransitionInfo(
              hasTransition: true,
              transitionType: PageTransitionType.fade,
              duration: Duration(milliseconds: 0),
            ),
          },
        );
      }
    });
  }

  Future<void> _startLogoAnimation() async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    _itController.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    _taglineController.forward();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _itController.dispose();
    _taglineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                const Spacer(),
                _buildLogo(),
                const SizedBox(height: 12.0),
                _buildTagline(),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return AnimatedBuilder(
      animation: Listenable.merge([_logoController, _itController]),
      builder: (context, _) {
        return FadeTransition(
          opacity: _logoFade,
          child: ScaleTransition(
            scale: _logoScale,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // "Get" with 3D shadow
                Stack(
                  children: [
                    // Filled 3D extrusion — multiple shadow layers
                    for (int i = 7; i >= 1; i--)
                      Transform.translate(
                        offset: Offset(i.toDouble(), i.toDouble()),
                        child: Text(
                          'Get',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w900,
                            fontSize: 72.0,
                            height: 1.0,
                            color: const Color(0xFF1A0D4E),
                          ),
                        ),
                      ),
                    Text(
                      'Get',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w900,
                        fontSize: 72.0,
                        height: 1.0,
                        color: AppColors.brandPurple,
                      ),
                    ),
                  ],
                ),
                // "it" overlapping the top-right of "Get"
                Positioned(
                  right: -16,
                  top: -4,
                  child: FadeTransition(
                    opacity: _itFade,
                    child: Text(
                      'it',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w800,
                        fontSize: 28.0,
                        height: 1.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTagline() {
    const words = ['Snap.', 'Catalog.', 'Organize'];
    return AnimatedBuilder(
      animation: _taglineController,
      builder: (context, _) {
        final progress = _taglineReveal.value;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(words.length, (i) {
            final wordStart = i / words.length;
            final wordEnd = (i + 1) / words.length;
            final wordProgress =
                ((progress - wordStart) / (wordEnd - wordStart)).clamp(0.0, 1.0);
            return Opacity(
              opacity: wordProgress,
              child: Padding(
                padding: EdgeInsets.only(left: i > 0 ? 6.0 : 0.0),
                child: Text(
                  words[i],
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w400,
                    fontSize: 16.0,
                    color: Colors.white70,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
