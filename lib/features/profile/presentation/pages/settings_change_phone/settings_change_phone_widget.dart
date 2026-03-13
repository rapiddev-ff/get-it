import '/backend/supabase/supabase.dart';
import '/features/auth/presentation/pages/phone_verification_page2/phone_verification_page2_widget.dart';
import '/backend/api_requests/api_calls.dart';
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
  bool _isSending = false;
  bool _hasInteracted = false;

  @override
  void initState() {
    super.initState();

    textController = TextEditingController();
    textFieldFocusNode = FocusNode()
      ..addListener(() {
        if (!textFieldFocusNode.hasFocus && textController.text.isNotEmpty) {
          setState(() => _hasInteracted = true);
        }
      });
    textFieldMask = MaskTextInputFormatter(mask: '+# (###) ###-##-##');
  }

  @override
  void dispose() {
    textFieldFocusNode.dispose();
    textController.dispose();
    super.dispose();
  }

  bool get _isPhoneValid {
    final text = textController.text;
    final result = FormValidators.phoneValidationResult(text);
    return (result == null || result.isEmpty) && text.isNotEmpty;
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
                      Text(
                        'We\'ll send a verification code to this number.',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: AppColors.textSecondary),
                      ),
                      SizedBox(height: 8.0),
                      SizedBox(
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
                      if (_hasInteracted &&
                          FormValidators.phoneValidationResult(
                                      textController.text) !=
                                  null &&
                          textController.text != '')
                        Padding(
                          padding: EdgeInsets.only(top: 4.0),
                          child: Text(
                            FormValidators.phoneValidationResult(
                                    textController.text) ??
                                '',
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
                        enabled: _isPhoneValid && !_isSending,
                        isLoading: _isSending,
                        onPressed: !_isPhoneValid || _isSending
                            ? null
                            : () async {
                                setState(() => _isSending = true);
                                try {
                                  final formattedPhone =
                                      FormValidators.formatPhoneNumber(
                                          textController.text);

                                  // Check if phone already registered
                                  final exists = await SupaFlow.client
                                      .from('user_profiles')
                                      .select('user_id')
                                      .eq('phone', formattedPhone)
                                      .maybeSingle();

                                  if (!mounted) return;
                                  if (exists != null) {
                                    await actions.toastificationshow(
                                      context,
                                      'Error',
                                      'This number is already registered.',
                                      'error',
                                    );
                                    return;
                                  }

                                  final sendRes = await TwillioGroup
                                      .sendVerificationCall
                                      .call(to: formattedPhone);

                                  if (!mounted) return;
                                  if (!sendRes.succeeded) {
                                    final msg = sendRes.jsonBody is Map
                                        ? (sendRes.jsonBody['message'] ??
                                            sendRes.jsonBody['error'] ??
                                            'Failed to send verification code.')
                                        : 'Failed to send verification code.';
                                    await actions.toastificationshow(
                                      context,
                                      'Error',
                                      msg.toString(),
                                      'error',
                                    );
                                    return;
                                  }

                                  if (!mounted) return;
                                  if (Navigator.of(context).canPop()) {
                                    context.pop();
                                  }
                                  context.pushNamed(
                                    PhoneVerificationPage2Widget.routeName,
                                    queryParameters: {
                                      'phoneNumber': formattedPhone,
                                      'isOnborading':
                                          widget.isOnboarding.toString(),
                                    },
                                  );
                                } finally {
                                  if (mounted) {
                                    setState(() => _isSending = false);
                                  }
                                }
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
