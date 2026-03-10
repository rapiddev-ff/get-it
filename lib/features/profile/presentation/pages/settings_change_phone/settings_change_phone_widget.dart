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
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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
  late final FocusNode textFieldFocusNode;
  late final TextEditingController textController;
  late final MaskTextInputFormatter textFieldMask;
  ApiCallResponse? apiResultzpe;

  @override
  void initState() {
    super.initState();

    textController = TextEditingController();
    textFieldFocusNode = FocusNode();    textFieldMask = MaskTextInputFormatter(mask: '+# (###) ###-##-##');
  }

  @override
  void dispose() {
    textFieldFocusNode.dispose();
    textController.dispose();
    super.dispose();
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
            onPressed: () {
              context.pop();
            },
          ),
          title: Text(
            'Edit Phone Number',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w500, color: Colors.white, height: 1.5),
          ),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          'Phone Number',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  fontWeight: FontWeight.w500, height: 1.4),
                        ),
                      ),
                      Container(
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
                          enabled: true,
                          obscureText: false,
                          decoration: appInputDecoration('Your phone number'),
                          style: Theme.of(context).textTheme.bodyMedium!,
                          keyboardType: TextInputType.number,
                          cursorColor: AppColors.textPrimary,
                          enableInteractiveSelection: true,
                          inputFormatters: [textFieldMask],
                        ),
                      ),
                      if ((FormValidators.phoneValidationResult(
                                      textController.text) !=
                                  null &&
                              FormValidators.phoneValidationResult(
                                      textController.text) !=
                                  '') &&
                          (textController.text != ''))
                        Padding(
                          padding: EdgeInsets.only(top: 4.0),
                          child: Text(
                            FormValidators.phoneValidationResult(
                                    textController.text) ??
                                'N/A',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: AppColors.error),
                          ).animate().fade(duration: 600.ms),
                        ),
                    ].addToStart(SizedBox(height: 24.0)),
                  ),
                ),
              ),
              if (!isKeyboardShowing(context))
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppGradientButton(
                        text: 'Send',
                        enabled: (textController.text != '') &&
                            (FormValidators.phoneValidationResult(
                                        textController.text) ==
                                    null ||
                                FormValidators.phoneValidationResult(
                                        textController.text) ==
                                    ''),
                        onPressed: () async {
                          apiResultzpe =
                              await SupabaseRPCGroup.checkphoneexistsCall.call(
                            userId: textController.text,
                          );

                          if (apiResultzpe?.jsonBody == true) {
                            await actions.toastificationshow(
                              context,
                              'Error',
                              'This number already registered',
                              'error',
                            );
                          } else {
                            await TwillioGroup.sendVerificationCall.call(
                              to: FormValidators.formatPhoneNumber(
                                  textController.text),
                            );

                            if (!mounted) return;
                            if (Navigator.of(context).canPop()) {
                              context.pop();
                            }
                            context.pushNamed(
                              PhoneVerificationPage2Widget.routeName,
                              queryParameters: {
                                'phoneNumber': FormValidators.formatPhoneNumber(
                                    textController.text),
                                'isOnborading': widget.isOnboarding.toString(),
                              },
                            );
                          }
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
