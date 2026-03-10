import '/core/providers/current_user_provider.dart';
import '/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/core/utils/keyboard_visibility_mixin.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/app_text_field.dart';
import '/core/widgets/app_gradient_button.dart';
import '/core/widgets/dismiss_keyboard.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class SettingsChangeEmailWidget extends ConsumerStatefulWidget {
  const SettingsChangeEmailWidget({
    super.key,
    required this.isOnboarding,
  });

  final bool? isOnboarding;

  static String routeName = 'settingsChangeEmail';
  static String routePath = 'settingsChangeEmail';

  @override
  ConsumerState<SettingsChangeEmailWidget> createState() =>
      _SettingsChangeEmailWidgetState();
}

class _SettingsChangeEmailWidgetState
    extends ConsumerState<SettingsChangeEmailWidget>
    with KeyboardVisibilityMixin {
  // Local state fields
  bool errorEmailRequired = false;
  bool errorEmailFormat = false;
  bool emailAlreadyInUse = false;
  bool errorPasswordRequired = false;
  bool errorPassword = false;
  bool passwordVisibility = false;

  // Text controllers and focus nodes
  late final TextEditingController textController1;
  late final FocusNode textFieldFocusNode1;
  late final TextEditingController textController2;
  late final FocusNode textFieldFocusNode2;

  // Action output results
  dynamic isCorrect;
  bool? isEmailRegistered;
  dynamic result;

  @override
  void initState() {
    super.initState();

    textController1 = TextEditingController();
    textFieldFocusNode1 = FocusNode();
    textController2 = TextEditingController();
    textFieldFocusNode2 = FocusNode();
  }

  @override
  void dispose() {
    textFieldFocusNode1.dispose();
    textController1.dispose();
    textFieldFocusNode2.dispose();
    textController2.dispose();
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
            'Edit Email',
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
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 4.0),
                                child: Text(
                                  'Current Password',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(height: 1.4),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                child: TextFormField(
                                  controller: textController1,
                                  focusNode: textFieldFocusNode1,
                                  onChanged: (_) => EasyDebounce.debounce(
                                    'textController1',
                                    Duration(milliseconds: 100),
                                    () => setState(() {}),
                                  ),
                                  autofocus: false,
                                  enabled: true,
                                  autofillHints: [AutofillHints.password],
                                  obscureText: !passwordVisibility,
                                  decoration: appInputDecoration(
                                    'Your password',
                                    suffixIcon: InkWell(
                                      onTap: () {
                                        setState(() => passwordVisibility =
                                            !passwordVisibility);
                                      },
                                      focusNode: FocusNode(skipTraversal: true),
                                      child: Icon(
                                        passwordVisibility
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: AppColors.textSecondary,
                                        size: 20.0,
                                      ),
                                    ),
                                  ),
                                  style: appTextFieldStyle,
                                  cursorColor: AppColors.textPrimary,
                                  enableInteractiveSelection: true,
                                ),
                              ),
                              if (errorPasswordRequired)
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 16.0, top: 4.0),
                                  child: Text(
                                    'Password is required.',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: AppColors.error),
                                  ).animate().fade(duration: 600.ms),
                                ),
                              if (errorPassword)
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 16.0, top: 4.0),
                                  child: Text(
                                    'Incorrect password. Try again.',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: AppColors.error),
                                  ).animate().fade(duration: 600.ms),
                                ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 4.0),
                                child: Text(
                                  'New Email',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(height: 1.4),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                child: TextFormField(
                                  controller: textController2,
                                  focusNode: textFieldFocusNode2,
                                  onChanged: (_) => EasyDebounce.debounce(
                                    'textController2',
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
                                ),
                              ),
                              if (errorEmailRequired)
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 16.0, top: 4.0),
                                  child: Text(
                                    'Please enter your email.',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: AppColors.error),
                                  ).animate().fade(duration: 600.ms),
                                ),
                              if (errorEmailFormat)
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 16.0, top: 4.0),
                                  child: Text(
                                    'Check your email format.',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: AppColors.error),
                                  ).animate().fade(duration: 600.ms),
                                ),
                              if (emailAlreadyInUse)
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 16.0, top: 4.0),
                                  child: Text(
                                    'Email already in use.',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: AppColors.error),
                                  ).animate().fade(duration: 600.ms),
                                ),
                            ],
                          ),
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
                        text: 'Save Changes',
                        onPressed: () async {
                          if (textController1.text != '') {
                            errorPasswordRequired = false;
                            setState(() {});
                          } else {
                            errorPasswordRequired = true;
                            setState(() {});
                            return;
                          }

                          isCorrect = await actions.supabaseLogin(
                            ref.read(currentUserEmailProvider),
                            textController1.text,
                          );
                          if (((isCorrect is Map)
                              ? isCorrect['success']
                              : false)) {
                            errorPassword = false;
                            if (!mounted) return;
                            setState(() {});
                          } else {
                            errorPassword = true;
                            setState(() {});
                            return;
                          }

                          errorEmailRequired = false;
                          errorEmailFormat = false;
                          emailAlreadyInUse = false;
                          setState(() {});
                          if (RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(textController2.text.trim())) {
                            errorEmailFormat = false;
                            setState(() {});
                          } else {
                            errorEmailFormat = true;
                            setState(() {});
                            return;
                          }

                          isEmailRegistered =
                              await actions.checkIsEmailRegistered(
                            textController2.text,
                          );
                          if (!isEmailRegistered!) {
                            emailAlreadyInUse = false;
                            if (!mounted) return;
                            setState(() {});
                          } else {
                            emailAlreadyInUse = true;
                            setState(() {});
                            return;
                          }

                          result =
                              await actions.changeUserEmailWithPasswordCheck(
                            context,
                            ref.read(currentUserEmailProvider),
                            textController2.text,
                            textController1.text,
                          );
                          if ((result is Map) ? result['success'] : false) {
                            if (!mounted) return;
                            context.pop();
                          } else {
                            await actions.toastificationshow(
                              context,
                              'Error!',
                              ((result is Map) ? result['error'] : '')
                                  .toString(),
                              'error',
                            );
                          }

                          if (!mounted) return;
                          setState(() {});
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
