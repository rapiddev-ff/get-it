import '/features/auth/data/supabase_auth/auth_util.dart';
import '/features/browse/domain/models/category_model.dart';
import '/features/browse/domain/models/condition_model.dart';
import '/core/constants/app_constants.dart';
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
import 'package:flutter_animate/flutter_animate.dart';
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

  static String routeName = 'checkData';
  static String routePath = 'checkData';

  @override
  ConsumerState<CheckDataWidget> createState() => _CheckDataWidgetState();
}

class _CheckDataWidgetState extends ConsumerState<CheckDataWidget>
    with TickerProviderStateMixin {
  // State fields inlined from CheckDataModel.
  dynamic getAppInitialData;
  dynamic getPaymentMethods;

  @override
  void initState() {
    super.initState();

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
                      color: Color(0x338E6CFF),
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
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    'We\'re so happy to see you back!\nYour account was previously deactivated.\nPlease confirm you would like to reactivate your account again!',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(height: 1.5),
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

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                Spacer(),
                Text(
                  AppConstants.appName,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 48.0,
                    letterSpacing: 0.0,
                    height: 1.0,
                  ),
                ).animate().fade(duration: 600.ms),
                Text(
                  'Snap.Catalog. Organize',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.italic,
                    color: AppColors.textSecondary,
                    fontSize: 18.0,
                    letterSpacing: 0.0,
                  ),
                ).animate().fade(duration: 600.ms),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
