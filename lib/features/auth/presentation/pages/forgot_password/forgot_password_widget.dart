import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '/core/constants/app_constants.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/keyboard_visibility_mixin.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/app_gradient_button.dart';
import '/core/widgets/app_text_field.dart';
import '/core/widgets/dismiss_keyboard.dart';
import '/custom_code/actions/index.dart' as actions;
import '/features/auth/presentation/pages/forgot_password_step2/forgot_password_step2_widget.dart';
import 'forgot_password_model.dart';

export 'forgot_password_model.dart';

class ForgotPasswordWidget extends StatefulWidget {
  const ForgotPasswordWidget({super.key});

  static String routeName = 'forgotPassword';
  static String routePath = 'forgotPassword';

  @override
  State<ForgotPasswordWidget> createState() => _ForgotPasswordWidgetState();
}

class _ForgotPasswordWidgetState extends State<ForgotPasswordWidget>
    with KeyboardVisibilityMixin {
  late ForgotPasswordModel _model;

  static final _emailRegExp =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  @override
  void initState() {
    super.initState();
    _model = ForgotPasswordModel();

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
        appBar: AppBar(
          backgroundColor: AppColors.backgroundPrimary,
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
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 22.0,
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
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 8.0),
                          child: Text(
                            'Reset Your Password',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 24.0),
                          child: Text(
                            'Enter your email address and we\'ll send you a secure link to create a new password.',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.normal,
                              color: AppColors.textPrimary,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 4.0),
                              child: Text(
                                'Email',
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
                                decoration:
                                    appInputDecoration('Your email address'),
                                style: appTextFieldStyle,
                                keyboardType: TextInputType.emailAddress,
                                cursorColor: AppColors.textPrimary,
                                enableInteractiveSelection: true,
                                validator: (value) => _model
                                    .textControllerValidator
                                    ?.call(context, value),
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
                  padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppGradientButton(
                        text: 'Next',
                        borderRadius: 8.0,
                        isLoading: _model.isLoading,
                        onPressed: _model.isLoading
                            ? null
                            : () async {
                                final email =
                                    _model.textController!.text.trim();
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
                                setState(() => _model.isLoading = true);
                                try {
                                  _model.requestPasswordReset =
                                      await actions.requestPasswordReset(
                                    email,
                                  );
                                  if (!mounted) return;
                                  if ((_model.requestPasswordReset is Map)
                                      ? _model.requestPasswordReset['success']
                                      : null) {
                                    context.pushNamed(
                                      ForgotPasswordStep2Widget.routeName,
                                      queryParameters: {
                                        'email': _model.textController!.text,
                                      },
                                    );
                                  } else {
                                    await actions.toastificationshow(
                                      context,
                                      'Error!',
                                      ((_model.requestPasswordReset is Map)
                                              ? _model.requestPasswordReset[
                                                  'message']
                                              : null)
                                          .toString(),
                                      'error',
                                    );
                                  }
                                } finally {
                                  if (mounted) {
                                    setState(() => _model.isLoading = false);
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
