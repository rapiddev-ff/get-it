import '/features/profile/presentation/pages/settings_payment_card_item/settings_payment_card_item_widget.dart';
import '/features/profile/presentation/pages/settings_payment_method_add/settings_payment_method_add_widget.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/dismiss_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class SettingsPaymentMethodWidget extends ConsumerStatefulWidget {
  const SettingsPaymentMethodWidget({super.key});

  static String routeName = 'settingsPaymentMethod';
  static String routePath = 'settingsPaymentMethod';

  @override
  ConsumerState<SettingsPaymentMethodWidget> createState() =>
      _SettingsPaymentMethodWidgetState();
}

class _SettingsPaymentMethodWidgetState
    extends ConsumerState<SettingsPaymentMethodWidget> {
  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(authProvider);

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
            onPressed: () async {
              context.pop();
            },
          ),
          title: Text(
            'Payment Method',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Payment Methods',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Builder(
                      builder: (context) {
                        final paymentMethods = userData.paymentMethod.toList();

                        return ListView.separated(
                          padding: EdgeInsets.zero,
                          primary: false,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: paymentMethods.length,
                          separatorBuilder: (_, __) => SizedBox(height: 12.0),
                          itemBuilder: (context, paymentMethodsIndex) {
                            final paymentMethodsItem =
                                paymentMethods[paymentMethodsIndex];
                            return SettingsPaymentCardItemWidget(
                              key: Key(
                                  'Keyw63_${paymentMethodsIndex}_of_${paymentMethods.length}'),
                              paymentMethod: paymentMethodsItem,
                              index: paymentMethodsIndex,
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 28.0),
                    child: Container(
                      width: double.infinity,
                      height: 56.0,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF7D56FF), Color(0xFF6187F1)],
                          stops: [0.0, 1.0],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: TextButton.icon(
                        onPressed: () async {
                          context.pushNamed(
                              SettingsPaymentMethodAddWidget.routeName);
                        },
                        icon: Icon(
                          Icons.add,
                          size: 28.0,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Add New Payment Method',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 17.0,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          minimumSize: Size(double.infinity, 56.0),
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 28.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundSecondary,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.shieldHalved,
                              color: AppColors.primary,
                              size: 18.0,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Secure Payments',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      'Your payment information is encrypted and securely processed by Stripe. We never store your card details on our servers.',
                                      style: GoogleFonts.inter(
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ].divide(SizedBox(width: 12.0)),
                        ),
                      ),
                    ),
                  ),
                ].addToStart(SizedBox(height: 24.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
