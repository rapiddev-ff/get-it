import '/auth/supabase_auth/auth_util.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'check_data_model.dart';
export 'check_data_model.dart';

class CheckDataWidget extends StatefulWidget {
  const CheckDataWidget({
    super.key,
    bool? fromSignIn,
  }) : this.fromSignIn = fromSignIn ?? false;

  final bool fromSignIn;

  static String routeName = 'checkData';
  static String routePath = 'checkData';

  @override
  State<CheckDataWidget> createState() => _CheckDataWidgetState();
}

class _CheckDataWidgetState extends State<CheckDataWidget>
    with TickerProviderStateMixin {
  late CheckDataModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CheckDataModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(
        Duration(
          milliseconds: 1500,
        ),
      );
      _model.getAppInitialData = await actions.callRpc(
        context,
        'get_app_initial_data',
        <String, String>{
          'p_user_id': currentUserUid,
        },
      );
      _model.getPaymentMethods = await actions.getSavedPaymentMethods();
      FFAppState().userData = functions.convertUserToDataType(
          _model.getAppInitialData!, _model.getPaymentMethods);
      FFAppState().categories = functions
          .convertCategoriesToDataType(
              getJsonField(
                _model.getAppInitialData,
                r'''$.categories''',
                true,
              )!,
              getJsonField(
                _model.getAppInitialData,
                r'''$.subcategories''',
                true,
              )!)!
          .toList()
          .cast<CategoryStruct>();
      FFAppState().conditions = functions
          .convertConditionsToDataType(getJsonField(
            _model.getAppInitialData,
            r'''$.conditions''',
            true,
          )!)!
          .toList()
          .cast<ConditionStruct>();
      safeSetState(() {});
      if (FFAppState().userData.phoneVerified == false) {
        context.goNamed(
          PhoneVerificationPageWidget.routeName,
          queryParameters: {
            'isOnboarding': serializeParam(
              true,
              ParamType.bool,
            ),
          }.withoutNulls,
          extra: <String, dynamic>{
            '__transition_info__': TransitionInfo(
              hasTransition: true,
              transitionType: PageTransitionType.fade,
              duration: Duration(milliseconds: 0),
            ),
          },
        );
      } else if (FFAppState().userData.firstName == '') {
        context.goNamed(
          AdditionalInfoWidget.routeName,
          extra: <String, dynamic>{
            '__transition_info__': TransitionInfo(
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
            '__transition_info__': TransitionInfo(
              hasTransition: true,
              transitionType: PageTransitionType.fade,
              duration: Duration(milliseconds: 0),
            ),
          },
        );
      }
    });

    animationsMap.addAll({
      'textOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
      'textOnPageLoadAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Spacer(),
                Text(
                  FFAppConstants.appName,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                        fontSize: 48.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        lineHeight: 1.0,
                      ),
                ).animateOnPageLoad(animationsMap['textOnPageLoadAnimation1']!),
                Text(
                  'Snap.Catalog. Organize',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.inter(
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.italic,
                        ),
                        color: Color(0xFFAFAFB4),
                        fontSize: 18.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.italic,
                      ),
                ).animateOnPageLoad(animationsMap['textOnPageLoadAnimation2']!),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
