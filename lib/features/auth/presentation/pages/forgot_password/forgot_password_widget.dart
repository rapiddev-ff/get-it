import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '/core/constants/app_constants.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/keyboard_visibility_mixin.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/app_gradient_button.dart';
import '/core/widgets/app_text_field.dart';
import '/core/widgets/dismiss_keyboard.dart';
import '/custom_code/actions/index.dart' as actions;
import '/features/auth/presentation/pages/forgot_password_step2/forgot_password_step2_widget.dart';

class ForgotPasswordWidget extends StatefulWidget {
  const ForgotPasswordWidget({super.key});

  static const String routeName = 'forgotPassword';
  static const String routePath = 'forgotPassword';

  @override
  State<ForgotPasswordWidget> createState() => _ForgotPasswordWidgetState();
}

class _ForgotPasswordWidgetState extends State<ForgotPasswordWidget>
    with KeyboardVisibilityMixin {
  late final TextEditingController textController;
  late final FocusNode textFieldFocusNode;
  dynamic _requestPasswordReset;
  bool _isLoading = false;

  static final _emailRegExp =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  @override
  void initState() {
    super.initState();

    textController = TextEditingController();
    textFieldFocusNode = FocusNode();  }

  @override
  void dispose() {
    EasyDebounce.cancelAll();
    textFieldFocusNode.dispose();
    textController.dispose();
    super.dispose();
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
            AppConstants.appName,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Colors.white,
                  fontSize: 22.0,
                  fontWeight: FontWeight.normal,
                ),
          ),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'Reset Your Password',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 24.0),
                          child: Text(
                            'Enter your email address and we\'ll send you a secure link to create a new password.',
                            style: Theme.of(context).textTheme.bodyLarge!,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 4.0),
                              child: Text(
                                'Email',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        fontWeight: FontWeight.w500,
                                        height: 1.4),
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
                                decoration:
                                    appInputDecoration('Your email address'),
                                style: appTextFieldStyle,
                                keyboardType: TextInputType.emailAddress,
                                cursorColor: AppColors.textPrimary,
                                enableInteractiveSelection: true,
                                validator: null,
                              ),
                            ),
                          ],
                        ),
                      ].addToStart(SizedBox(height: 24.0)),
                    ),
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
                        text: 'Next',
                        borderRadius: 8.0,
                        isLoading: _isLoading,
                        onPressed: _isLoading
                            ? null
                            : () async {
                                final email =
                                    textController.text.trim();
                                if (email.isEmpty ||
                                    !_emailRegExp.hasMatch(email)) {
                                  await actions.toastificationshow(
                                    context,
                                    'Error!',
                                    'Please enter a valid email address',
                                    'error',
                                  );
                                  return;
                                }
                                setState(() => _isLoading = true);
                                try {
                                  _requestPasswordReset =
                                      await actions.requestPasswordReset(
                                    email,
                                  );
                                  if (!mounted) return;
                                  if ((_requestPasswordReset is Map)
                                      ? _requestPasswordReset['success']
                                      : null) {
                                    context.pushNamed(
                                      ForgotPasswordStep2Widget.routeName,
                                      queryParameters: {
                                        'email': textController.text,
                                      },
                                    );
                                  } else {
                                    await actions.toastificationshow(
                                      context,
                                      'Error!',
                                      ((_requestPasswordReset is Map)
                                              ? _requestPasswordReset[
                                                  'message']
                                              : null)
                                          .toString(),
                                      'error',
                                    );
                                  }
                                } finally {
                                  if (mounted) {
                                    setState(() => _isLoading = false);
                                  }
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
                      duration: 600.ms),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
