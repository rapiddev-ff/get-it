import '/features/auth/data/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/features/auth/domain/models/user_settings_model.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/keyboard_visibility_mixin.dart';
import '/core/widgets/app_text_field.dart';
import '/core/widgets/app_gradient_button.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/dismiss_keyboard.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'settings_daily_budget_model.dart';

class SettingsDailyBudgetWidget extends ConsumerStatefulWidget {
  const SettingsDailyBudgetWidget({super.key});

  static String routeName = 'settingsDailyBudget';
  static String routePath = 'settingsDailyBudget';

  @override
  ConsumerState<SettingsDailyBudgetWidget> createState() =>
      _SettingsDailyBudgetWidgetState();
}

class _SettingsDailyBudgetWidgetState
    extends ConsumerState<SettingsDailyBudgetWidget>
    with KeyboardVisibilityMixin {
  late SettingsDailyBudgetModel _model;

  @override
  void initState() {
    super.initState();
    _model = SettingsDailyBudgetModel();

    final dailyBudget = ref.read(authProvider).userSettings?.dailyBudget;
    final formattedBudget = dailyBudget != null
        ? NumberFormat('#,##0.##', 'en_US').format(dailyBudget)
        : '0';

    _model.textController ??= TextEditingController(text: formattedBudget);
    _model.textFieldFocusNode ??= FocusNode();
    _model.textFieldFocusNode!.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        backgroundColor: AppColors.backgroundPrimary,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundSecondary,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 24.0,
            ),
            onPressed: () {
              context.pop();
            },
          ),
          title: Text(
            'Edit Daily Budget',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 4.0),
                        child: Text(
                          'Daily Budget',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                            fontSize: 24.0,
                            height: 1.4,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 4.0),
                        child: Text(
                          'Swipe Payment will stop when you reach this amount in a day.',
                          style: GoogleFonts.inter(
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 0.0),
                        child: Container(
                          width: double.infinity,
                          child: TextFormField(
                            controller: _model.textController,
                            focusNode: _model.textFieldFocusNode,
                            onChanged: (_) => EasyDebounce.debounce(
                              '_model.textController',
                              Duration(milliseconds: 100),
                              () => setState(() {}),
                            ),
                            autofocus: false,
                            enabled: true,
                            obscureText: false,
                            decoration:
                                appInputDecoration('Daily Budget').copyWith(
                              prefixText: '\$ ',
                              prefixStyle: GoogleFonts.inter(
                                fontWeight: FontWeight.normal,
                                fontSize: 16.0,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            style: GoogleFonts.inter(),
                            keyboardType: TextInputType.number,
                            cursorColor: AppColors.textPrimary,
                            enableInteractiveSelection: true,
                          ),
                        ),
                      ),
                    ].addToStart(SizedBox(height: 24.0)),
                  ),
                ),
              ),
              if (!isKeyboardShowing(context))
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppGradientButton(
                        text: 'Save Budget',
                        onPressed: () async {
                          await Future.wait([
                            Future(() async {
                              ref.read(authProvider.notifier).updateUser(
                                    (e) => e.copyWith(
                                      userSettings: (e.userSettings ??
                                              const UserSettings())
                                          .copyWith(
                                        dailyBudget: double.tryParse(
                                                _model.textController!.text) ??
                                            0.0,
                                      ),
                                    ),
                                  );
                              if (mounted) setState(() {});
                            }),
                            Future(() async {
                              await UserSettingsTable().update(
                                data: {
                                  'daily_budget': double.tryParse(
                                      _model.textController!.text),
                                },
                                matchingRows: (rows) => rows.eqOrNull(
                                  'user_id',
                                  currentUserUid,
                                ),
                              );
                            }),
                          ]);
                          if (!mounted) return;
                          context.pop();
                        },
                      ),
                      AppOutlineButton(
                        text: 'Cancel',
                        onPressed: () {
                          context.pop();
                        },
                      ),
                    ]
                        .divide(SizedBox(height: 16.0))
                        .addToStart(SizedBox(height: 24.0))
                        .addToEnd(SizedBox(height: 32.0)),
                  ).animate().move(
                        begin: Offset(0, 100),
                        end: Offset.zero,
                        duration: 600.ms,
                      ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
