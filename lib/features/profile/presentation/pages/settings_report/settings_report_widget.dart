import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '/features/auth/data/supabase_auth/auth_util.dart';
import '/backend/supabase/database/tables/support_reports.dart';
import '/custom_code/actions/index.dart' as actions;
import '/core/theme/app_colors.dart';
import '/core/utils/keyboard_visibility_mixin.dart';
import '/core/widgets/app_text_field.dart';
import '/core/widgets/app_gradient_button.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/dismiss_keyboard.dart';
import 'settings_report_model.dart';
export 'settings_report_model.dart';

class SettingsReportWidget extends StatefulWidget {
  const SettingsReportWidget({super.key});

  static String routeName = 'settingsReport';
  static String routePath = 'settingsReport';

  @override
  State<SettingsReportWidget> createState() => _SettingsReportWidgetState();
}

class _SettingsReportWidgetState extends State<SettingsReportWidget>
    with KeyboardVisibilityMixin {
  late SettingsReportModel _model;

  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _model = SettingsReportModel();

    _model.textController ??= TextEditingController();
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
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(119.0),
          child: AppBar(
            backgroundColor: AppColors.backgroundSecondary,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              title: Padding(
                padding: EdgeInsets.only(bottom: 14.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_back_rounded,
                                color: Colors.white,
                                size: 24.0,
                              ),
                              onPressed: () async {
                                context.pop();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Text(
                        'How Can We Help You?',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 28.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              expandedTitleScale: 1.0,
            ),
          ),
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(left: 16.0, top: 32.0, right: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Please tell us about the issue you are having and we will respond within 3-5 business days.',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.normal,
                            fontSize: 16.0,
                            color: AppColors.textPrimary,
                            height: 1.5,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 24.0),
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
                            textInputAction: TextInputAction.done,
                            obscureText: false,
                            decoration: appInputDecoration(
                                'Please give us as much detail about the problem you are experiencing.'),
                            style: GoogleFonts.inter(
                              fontSize: 14.0,
                            ),
                            maxLines: null,
                            minLines: 5,
                            maxLength: 1000,
                            buildCounter: (context,
                                    {required currentLength,
                                    required isFocused,
                                    maxLength}) =>
                                null,
                            keyboardType: TextInputType.multiline,
                            cursorColor: AppColors.textPrimary,
                            enableInteractiveSelection: true,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${_model.textController?.text.length ?? 0}/1000',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.normal,
                                fontSize: 14.0,
                                color: AppColors.textSecondary,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (!isKeyboardShowing(context))
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      AppGradientButton(
                        text: 'Send',
                        enabled:
                            _model.textController!.text.trim().isNotEmpty &&
                                !_isSending,
                        isLoading: _isSending,
                        onPressed: () async {
                          setState(() => _isSending = true);
                          try {
                            await SupportReportsTable().insert({
                              'user_id': currentUserUid,
                              'message': _model.textController!.text.trim(),
                            });
                            if (!mounted) return;
                            context.pop();
                            await actions.toastificationshow(
                              context,
                              'Report Sent',
                              'We\'ll get back to you within 3-5 business days.',
                              'success',
                            );
                          } catch (e) {
                            if (!mounted) return;
                            await actions.toastificationshow(
                              context,
                              'Error',
                              'Failed to send report. Please try again.',
                              'error',
                            );
                          } finally {
                            if (mounted) setState(() => _isSending = false);
                          }
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: AppOutlineButton(
                          text: 'Cancel',
                          onPressed: () async {
                            context.pop();
                          },
                        ),
                      ),
                    ].addToEnd(SizedBox(height: 32.0)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
