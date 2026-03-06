import '/features/auth/data/supabase_auth/auth_util.dart';
import '/features/browse/domain/models/category_model.dart';
import '/features/browse/domain/models/condition_model.dart';
import '/core/constants/app_constants.dart';
import '/core/theme/app_colors.dart';
import '/core/router/app_router.dart';
import '/core/utils/json_utils.dart' show getJsonField;
import '/custom_code/actions/index.dart' as actions;
import '/core/utils/data_converters.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
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
  final scaffoldKey = GlobalKey<ScaffoldState>();

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
          'p_user_id': currentUserUid,
        },
      );
      getPaymentMethods = await actions.getSavedPaymentMethods();
      if (!mounted) return;
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: AppColors.backgroundPrimary,
        body: SafeArea(
          top: true,
          child: Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
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
                    color: Color(0xFFAFAFB4),
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
