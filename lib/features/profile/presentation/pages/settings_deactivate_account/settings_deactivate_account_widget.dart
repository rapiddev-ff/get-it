import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/dismiss_keyboard.dart';
import '/custom_code/actions/index.dart' as actions;
import '/features/auth/presentation/pages/sign_in/sign_in_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class SettingsDeactivateAccountWidget extends StatefulWidget {
  const SettingsDeactivateAccountWidget({super.key});

  static String routeName = 'settingsDeactivateAccount';
  static String routePath = 'settingsDeactivateAccount';

  @override
  State<SettingsDeactivateAccountWidget> createState() =>
      _SettingsDeactivateAccountWidgetState();
}

class _SettingsDeactivateAccountWidgetState
    extends State<SettingsDeactivateAccountWidget> {
  bool _isLoading = false;

  Future<void> _deactivate() async {
    setState(() => _isLoading = true);
    final result = await actions.deactivateAccount();
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result['success'] == true) {
      context.goNamed(SignInWidget.routeName);
      await actions.toastificationshow(
        context,
        'Account Deactivated',
        'Your account has been deactivated. Sign in again to reactivate.',
        'success',
      );
    } else {
      await actions.toastificationshow(
        context,
        'Error',
        (result['error'] ?? 'Something went wrong').toString(),
        'error',
      );
    }
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
            'Deactivate Account',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w500, color: Colors.white, height: 1.5),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.destructive500.withValues(alpha: 0.26),
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(14.0),
                    child: Icon(
                      Icons.remove_circle_outline,
                      color: AppColors.destructive500,
                      size: 20.0,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Text(
                    'Are you sure you want to deactivate your account?',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontWeight: FontWeight.w500, height: 1.5),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Text(
                    'If you choose to deactivate your account, you will need to reactivate your account by signing in the future. ',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(height: 1.5),
                  ),
                ),
                Spacer(),
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 56.0,
                      child: OutlinedButton.icon(
                        onPressed: _isLoading ? null : _deactivate,
                        icon: _isLoading
                            ? SizedBox(
                                width: 16.0,
                                height: 16.0,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  color: AppColors.destructive500,
                                ),
                              )
                            : FaIcon(
                                FontAwesomeIcons.powerOff,
                                size: 16.0,
                                color: AppColors.destructive500,
                              ),
                        label: Text(
                          'Deactivate Account',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17.0,
                                    color: AppColors.destructive500,
                                  ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: AppColors.destructive500,
                            width: 1.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 56.0,
                        child: OutlinedButton(
                          onPressed: () {
                            context.pop();
                          },
                          child: Text(
                            'Back',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17.0,
                                    color: Colors.white),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: AppColors.neutral800,
                              width: 1.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ].addToEnd(SizedBox(height: 32.0)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
