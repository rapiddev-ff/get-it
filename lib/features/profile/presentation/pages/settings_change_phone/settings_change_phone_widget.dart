import '/backend/api_requests/api_calls.dart';
import '/features/auth/presentation/pages/phone_verification_page2/phone_verification_page2_widget.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/keyboard_visibility_mixin.dart';
import '/core/widgets/app_text_field.dart';
import '/core/widgets/app_gradient_button.dart';
import '/core/utils/list_extensions.dart';
import '/custom_code/actions/index.dart' as actions;
import '/core/utils/form_validators.dart';
import '/core/widgets/dismiss_keyboard.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'settings_change_phone_model.dart';

class SettingsChangePhoneWidget extends StatefulWidget {
  const SettingsChangePhoneWidget({
    super.key,
    required this.isOnboarding,
  });

  final bool? isOnboarding;

  static String routeName = 'settingsChangePhone';
  static String routePath = 'settingsChangePhone';

  @override
  State<SettingsChangePhoneWidget> createState() =>
      _SettingsChangePhoneWidgetState();
}

class _SettingsChangePhoneWidgetState extends State<SettingsChangePhoneWidget>
    with KeyboardVisibilityMixin {
  late SettingsChangePhoneModel _model;

  @override
  void initState() {
    super.initState();
    _model = SettingsChangePhoneModel();

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    _model.textFieldFocusNode!.addListener(() => setState(() {}));
    _model.textFieldMask = MaskTextInputFormatter(mask: '+# (###) ###-##-##');
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
            'Edit Phone Number',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
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
                          'Phone Number',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                            height: 1.4,
                          ),
                        ),
                      ),
                      Container(
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
                          decoration: appInputDecoration('Your phone number'),
                          style: GoogleFonts.inter(),
                          keyboardType: TextInputType.number,
                          cursorColor: AppColors.textPrimary,
                          enableInteractiveSelection: true,
                          inputFormatters: [_model.textFieldMask],
                        ),
                      ),
                      if ((FormValidators.phoneValidationResult(
                                      _model.textController!.text) !=
                                  null &&
                              FormValidators.phoneValidationResult(
                                      _model.textController!.text) !=
                                  '') &&
                          (_model.textController!.text != ''))
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 4.0, 0.0, 0.0),
                          child: Text(
                            FormValidators.phoneValidationResult(
                                    _model.textController!.text) ??
                                'N/A',
                            style: GoogleFonts.inter(
                              color: AppColors.error,
                              fontSize: 12.0,
                            ),
                          ).animate().fade(duration: 600.ms),
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
                        text: 'Send',
                        enabled: (_model.textController!.text != '') &&
                            (FormValidators.phoneValidationResult(
                                        _model.textController!.text) ==
                                    null ||
                                FormValidators.phoneValidationResult(
                                        _model.textController!.text) ==
                                    ''),
                        onPressed: () async {
                          _model.apiResultzpe =
                              await SupabaseRPCGroup.checkphoneexistsCall.call(
                            userId: _model.textController!.text,
                          );

                          if (_model.apiResultzpe?.jsonBody == true) {
                            await actions.toastificationshow(
                              context,
                              'Error',
                              'This number already registered',
                              'error',
                            );
                          } else {
                            await TwillioGroup.sendVerificationCall.call(
                              to: FormValidators.formatPhoneNumber(
                                  _model.textController!.text),
                            );

                            if (Navigator.of(context).canPop()) {
                              context.pop();
                            }
                            context.pushNamed(
                              PhoneVerificationPage2Widget.routeName,
                              queryParameters: {
                                'phoneNumber': FormValidators.formatPhoneNumber(
                                    _model.textController!.text),
                                'isOnborading': widget.isOnboarding.toString(),
                              },
                            );
                          }

                          setState(() {});
                        },
                      ),
                    ]
                        .divide(SizedBox(height: 40.0))
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
