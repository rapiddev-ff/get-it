import '/features/auth/data/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/features/profile/presentation/pages/settings_business/settings_business_widget.dart';
import '/features/profile/presentation/pages/settings_item/settings_item_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/core/utils/data_converters.dart' as functions;
import '/features/profile/presentation/pages/settings_my_profile/settings_my_profile_widget.dart';
import '/features/profile/presentation/pages/settings_referral/settings_referral_widget.dart';
import '/features/profile/presentation/pages/settings_edit_profile/settings_edit_profile_widget.dart';
import '/features/profile/presentation/pages/settings_change_email/settings_change_email_widget.dart';
import '/features/profile/presentation/pages/settings_change_phone/settings_change_phone_widget.dart';
import '/features/profile/presentation/pages/settings_block_list/settings_block_list_widget.dart';
import '/features/profile/presentation/pages/settings_change_password/settings_change_password_widget.dart';
import '/features/profile/presentation/pages/settings_payment_method/settings_payment_method_widget.dart';
import '/features/profile/presentation/pages/settings_daily_budget/settings_daily_budget_widget.dart';
import '/features/profile/presentation/pages/settings_business_address/settings_business_address_widget.dart';
import '/features/profile/presentation/pages/settings_shipping_defaults/settings_shipping_defaults_widget.dart';
import '/features/profile/presentation/pages/settings_terms/settings_terms_widget.dart';
import '/features/profile/presentation/pages/settings_privacy/settings_privacy_widget.dart';
import '/features/profile/presentation/pages/settings_report/settings_report_widget.dart';
import '/features/auth/presentation/pages/welcome/welcome_widget.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/core/utils/value_utils.dart';
import '/core/widgets/dismiss_keyboard.dart';
import '/features/auth/domain/models/user_settings_model.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '/core/providers/current_user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'settings_model.dart';
export 'settings_model.dart';

class SettingsWidget extends ConsumerStatefulWidget {
  const SettingsWidget({super.key});

  static String routeName = 'settings';
  static String routePath = 'settings';

  @override
  ConsumerState<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends ConsumerState<SettingsWidget> {
  late SettingsModel _model;

  @override
  void initState() {
    super.initState();
    _model = SettingsModel();

    _model.switchValue =
        ref.read(authProvider).userSettings?.swipePaymentEnabled ?? false;

    // Fetch latest stripe status
    _fetchStripeStatus();
  }

  Future<void> _fetchStripeStatus() async {
    final stripeRows = await StripeAccountsTable().queryRows(
      queryFn: (q) => q.eqOrNull('user_id', ref.read(currentUserIdProvider)),
    );
    if (!mounted) return;
    ref.read(authProvider.notifier).updateUser(
          (e) => e.copyWith(
            stripe: functions.convertStripeStatus(stripeRows.firstOrNull),
          ),
        );
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

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
            onPressed: () async {
              context.pop();
            },
          ),
          title: Text(
            'Settings',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.normal,
              fontSize: 18.0,
              color: Colors.white,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    onTap: () async {
                      context.pushNamed(SettingsMyProfileWidget.routeName);
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundSecondary,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Container(
                              width: 60.0,
                              height: 60.0,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: CachedNetworkImage(
                                fadeInDuration: Duration(milliseconds: 500),
                                fadeOutDuration: Duration(milliseconds: 500),
                                imageUrl: valueOrDefault<String>(
                                  authState.avatarUrl,
                                  'https://media.istockphoto.com/id/1223671392/vector/default-profile-picture-avatar-photo-placeholder-vector-illustration.jpg?s=612x612&w=0&k=20&c=s0aTdmT5aU6b8ot7VKm11DeID6NctRCpB755rA1BIP0=',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'View Profile',
                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: AppColors.textSecondary,
                              size: 24.0,
                            ),
                          ].divide(SizedBox(width: 12.0)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 24.0),
                    child: SettingsItemWidget(
                      tittle: 'Referral Code',
                      value:
                          'Share your link to earn commission with other sellers',
                      showTrailingIcon: false,
                      action: () async {
                        context.pushNamed(SettingsReferralWidget.routeName);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: SettingsItemWidget(
                      tittle: 'Edit Profile',
                      value:
                          '${authState.firstName} ${authState.lastName}, ${authState.username}',
                      showTrailingIcon: true,
                      action: () async {
                        context.pushNamed(SettingsEditProfileWidget.routeName);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: SettingsItemWidget(
                      tittle: 'Edit Email',
                      value: authState.email,
                      showTrailingIcon: true,
                      action: () async {
                        context.pushNamed(
                          SettingsChangeEmailWidget.routeName,
                          queryParameters: {
                            'isOnboarding': false.toString(),
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: SettingsItemWidget(
                      tittle: 'Edit Phone Number',
                      value: authState.phone,
                      showTrailingIcon: true,
                      action: () async {
                        context.pushNamed(
                          SettingsChangePhoneWidget.routeName,
                          queryParameters: {
                            'isOnboarding': false.toString(),
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: SettingsItemWidget(
                      tittle: 'Block List',
                      value: 'View your blocked list',
                      showTrailingIcon: true,
                      action: () async {
                        context.pushNamed(SettingsBlockListWidget.routeName);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: SettingsItemWidget(
                      tittle: 'Change Password',
                      value: '********',
                      showTrailingIcon: true,
                      action: () async {
                        context
                            .pushNamed(SettingsChangePasswordWidget.routeName);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: SettingsItemWidget(
                      tittle: 'Payment Method',
                      value: authState.paymentMethod.firstOrNull != null
                          ? '**** **** **** ${authState.paymentMethod.firstOrNull?.card?.last4 ?? ''}'
                          : '',
                      showTrailingIcon: true,
                      action: () async {
                        context
                            .pushNamed(SettingsPaymentMethodWidget.routeName);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundSecondary,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Enable Swipe Payment',
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Text(
                                              'Daily Budget',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!,
                                            ),
                                            if (!(authState.userSettings
                                                    ?.swipePaymentEnabled ??
                                                false))
                                              Text(
                                                'Off',
                                                style: Theme.of(context).textTheme.labelMedium!,
                                              ),
                                            if ((authState.userSettings
                                                    ?.swipePaymentEnabled ??
                                                false))
                                              InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  context.pushNamed(
                                                      SettingsDailyBudgetWidget
                                                          .routeName);
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.0),
                                                    border: Border.all(
                                                      color:
                                                          AppColors.neutral700,
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(12.0, 8.0,
                                                                20.0, 8.0),
                                                    child: Text(
                                                      '\$ ${valueOrDefault<String>(
                                                        NumberFormat('#,##0.##',
                                                                'en_US')
                                                            .format(authState
                                                                    .userSettings
                                                                    ?.dailyBudget ??
                                                                0.0),
                                                        '0',
                                                      )}',
                                                      style: GoogleFonts.inter(
                                                        fontSize: 14.0,
                                                        color: AppColors
                                                            .textPrimary,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ].divide(SizedBox(width: 8.0)),
                                        ),
                                      ),
                                      Switch.adaptive(
                                        value: _model.switchValue,
                                        onChanged: (newValue) async {
                                          setState(() =>
                                              _model.switchValue = newValue);
                                          if (newValue) {
                                            await Future.wait([
                                              Future(() async {
                                                ref
                                                    .read(authProvider.notifier)
                                                    .updateUser(
                                                      (e) => e.copyWith(
                                                        userSettings:
                                                            (e.userSettings ??
                                                                    const UserSettings())
                                                                .copyWith(
                                                          swipePaymentEnabled:
                                                              true,
                                                        ),
                                                      ),
                                                    );
                                                setState(() {});
                                              }),
                                              Future(() async {
                                                await UserSettingsTable()
                                                    .update(
                                                  data: {
                                                    'swipe_payment_enabled':
                                                        true,
                                                  },
                                                  matchingRows: (rows) =>
                                                      rows.eqOrNull(
                                                    'user_id',
                                                    ref.read(
                                                        currentUserIdProvider),
                                                  ),
                                                );
                                              }),
                                            ]);
                                          } else {
                                            await Future.wait([
                                              Future(() async {
                                                ref
                                                    .read(authProvider.notifier)
                                                    .updateUser(
                                                      (e) => e.copyWith(
                                                        userSettings:
                                                            (e.userSettings ??
                                                                    const UserSettings())
                                                                .copyWith(
                                                          swipePaymentEnabled:
                                                              false,
                                                        ),
                                                      ),
                                                    );
                                                setState(() {});
                                              }),
                                              Future(() async {
                                                await UserSettingsTable()
                                                    .update(
                                                  data: {
                                                    'swipe_payment_enabled':
                                                        false,
                                                  },
                                                  matchingRows: (rows) =>
                                                      rows.eqOrNull(
                                                    'user_id',
                                                    ref.read(
                                                        currentUserIdProvider),
                                                  ),
                                                );
                                              }),
                                            ]);
                                          }
                                        },
                                        activeThumbColor: AppColors.primary,
                                        activeTrackColor: AppColors.primary,
                                        inactiveTrackColor: AppColors.alternate,
                                        inactiveThumbColor:
                                            AppColors.backgroundSecondary,
                                      ),
                                    ],
                                  ),
                                ].divide(SizedBox(height: 8.0)),
                              ),
                            ),
                          ].divide(SizedBox(width: 12.0)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 32.0),
                    child: Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.solidBuilding,
                          color: AppColors.textPrimary,
                          size: 24.0,
                        ),
                        Text(
                          'Business',
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ].divide(SizedBox(width: 12.0)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: SettingsItemWidget(
                      tittle: 'Business Name',
                      value: valueOrDefault<String>(
                        authState.businessName,
                        'Add your business name',
                      ),
                      showTrailingIcon: true,
                      action: () async {
                        await showModalBottomSheet(
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) {
                            return DismissKeyboard(
                              child: Padding(
                                padding: MediaQuery.viewInsetsOf(context),
                                child: SettingsBusinessWidget(
                                  title: 'Business Name',
                                  hintText: 'Add your business name',
                                  initialVal: authState.businessName,
                                  action: (val) async {
                                    await UserProfilesTable().update(
                                      data: {
                                        'business_name': val,
                                      },
                                      matchingRows: (rows) => rows.eqOrNull(
                                        'user_id',
                                        ref.read(currentUserIdProvider),
                                      ),
                                    );
                                    ref.read(authProvider.notifier).updateUser(
                                          (e) => e.copyWith(
                                              businessName: val ?? ''),
                                        );
                                    setState(() {});
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            );
                          },
                        ).then((value) => setState(() {}));
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: SettingsItemWidget(
                      tittle: 'Business Address',
                      value: (authState.businessAddress?.country.isNotEmpty ??
                              false)
                          ? 'Update your address'
                          : 'Add your address',
                      showTrailingIcon: true,
                      action: () async {
                        context
                            .pushNamed(SettingsBusinessAddressWidget.routeName);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: SettingsItemWidget(
                      tittle: 'Business Email',
                      value: valueOrDefault<String>(
                        authState.businessEmail,
                        'Add business email',
                      ),
                      showTrailingIcon: true,
                      action: () async {
                        await showModalBottomSheet(
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) {
                            return DismissKeyboard(
                              child: Padding(
                                padding: MediaQuery.viewInsetsOf(context),
                                child: SettingsBusinessWidget(
                                  title: 'Business Email',
                                  hintText: 'Add business email',
                                  initialVal: authState.businessEmail,
                                  action: (val) async {
                                    await UserProfilesTable().update(
                                      data: {
                                        'business_email': val,
                                      },
                                      matchingRows: (rows) => rows.eqOrNull(
                                        'user_id',
                                        ref.read(currentUserIdProvider),
                                      ),
                                    );
                                    ref.read(authProvider.notifier).updateUser(
                                          (e) => e.copyWith(
                                              businessEmail: val ?? ''),
                                        );
                                    setState(() {});
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            );
                          },
                        ).then((value) => setState(() {}));
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: InkWell(
                      onTap: () async {
                        if ((authState.stripe?.hasAccount ?? false) == false) {
                          await actions.startStripeConnectOnboarding();
                        } else {
                          await actions.openStripeDashboard();
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundSecondary,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12.0),
                          child: Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.ccStripe,
                                color: AppColors.textPrimary,
                                size: 20.0,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      !(authState.stripe?.hasAccount ?? false)
                                          ? 'Connect Stripe'
                                          : 'Seller Dashboard',
                                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      () {
                                        switch (
                                            authState.stripe?.accountStatus ??
                                                '') {
                                          case 'not_connected':
                                            return 'Connect Stripe to start selling';
                                          case 'onboarding':
                                            return 'Complete your Stripe setup';
                                          case 'in_review':
                                            return 'Stripe is reviewing your account';
                                          case 'restricted':
                                            return 'Your account requires attention';
                                          case 'enabled':
                                            return 'Your seller account is active';
                                          case 'rejected':
                                            return 'Your account has been rejected';
                                          case 'disabled':
                                            return 'Your account has been disabled';
                                          default:
                                            return 'Connect Stripe to start selling';
                                        }
                                      }(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!,
                                    ),
                                  ].divide(SizedBox(height: 8.0)),
                                ),
                              ),
                              if ((authState.stripe?.hasAccount ?? false) &&
                                  (authState.stripe?.statusLabel ?? '')
                                      .isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0, vertical: 4.0),
                                  decoration: BoxDecoration(
                                    color: Color(int.parse(
                                            (authState.stripe?.statusColor ??
                                                    '#9E9E9E')
                                                .replaceFirst('#', ''),
                                            radix: 16) |
                                        0xFF000000),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Text(
                                    authState.stripe?.statusLabel ?? '',
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ),
                              if (!(authState.stripe?.hasAccount ?? false))
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.brandPurple,
                                        AppColors.brandBlue
                                      ],
                                      stops: [0.0, 1.0],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15.0, vertical: 8.0),
                                    child: Text(
                                      'Connect',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!,
                                    ),
                                  ),
                                ),
                            ].divide(SizedBox(width: 12.0)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundSecondary,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                        child: Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.shopify,
                              color: AppColors.textPrimary,
                              size: 20.0,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Connect Shopify',
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    'Not Connected',
                                    style:
                                        Theme.of(context).textTheme.bodySmall!,
                                  ),
                                ].divide(SizedBox(height: 8.0)),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                await actions.toastificationshow(
                                  context,
                                  'Shopify error',
                                  'Integration not started',
                                  'warning',
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.brandPurple,
                                      AppColors.brandBlue
                                    ],
                                    stops: [0.0, 1.0],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15.0, vertical: 8.0),
                                  child: Text(
                                    'Connect',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium!,
                                  ),
                                ),
                              ),
                            ),
                          ].divide(SizedBox(width: 12.0)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: SettingsItemWidget(
                      tittle: 'Shipping Defaults',
                      value: () {
                        final flat =
                            authState.userSettings?.defaultFlatShippingRate ??
                                0.0;
                        final additional =
                            authState.userSettings?.defaultAdditionalItemFee ??
                                0.0;
                        if (flat == 0.0 && additional == 0.0) {
                          return 'Applies to all your items by default';
                        }
                        final fmt = NumberFormat('\$#,##0.00', 'en_US');
                        return '${fmt.format(flat)} + ${fmt.format(additional)}';
                      }(),
                      showTrailingIcon: true,
                      action: () async {
                        context.pushNamed(
                            SettingsShippingDefaultsWidget.routeName);
                      },
                    ),
                  ),
                  Divider(
                    height: 64.0,
                    thickness: 2.0,
                    color: AppColors.surfaceDark,
                  ),
                  InkWell(
                    onTap: () async {
                      context.pushNamed(SettingsTermsWidget.routeName);
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundSecondary,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                        child: Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.solidFileLines,
                              color: AppColors.textPrimary,
                              size: 20.0,
                            ),
                            Expanded(
                              child: Text(
                                'Terms & Conditions',
                                style: Theme.of(context).textTheme.bodyMedium!,
                              ),
                            ),
                            Icon(
                              Icons.chevron_right_outlined,
                              color: AppColors.textSecondary,
                              size: 24.0,
                            ),
                          ].divide(SizedBox(width: 12.0)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: InkWell(
                      onTap: () async {
                        context.pushNamed(SettingsPrivacyWidget.routeName);
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundSecondary,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12.0),
                          child: Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.shieldHalved,
                                color: AppColors.textPrimary,
                                size: 20.0,
                              ),
                              Expanded(
                                child: Text(
                                  'Privacy Policy',
                                  style:
                                      Theme.of(context).textTheme.bodyMedium!,
                                ),
                              ),
                              Icon(
                                Icons.chevron_right_outlined,
                                color: AppColors.textSecondary,
                                size: 24.0,
                              ),
                            ].divide(SizedBox(width: 12.0)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: InkWell(
                      onTap: () async {
                        context.pushNamed(SettingsReportWidget.routeName);
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundSecondary,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12.0),
                          child: Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.headset,
                                color: AppColors.textPrimary,
                                size: 20.0,
                              ),
                              Expanded(
                                child: Text(
                                  'Support',
                                  style:
                                      Theme.of(context).textTheme.bodyMedium!,
                                ),
                              ),
                              Icon(
                                Icons.chevron_right_outlined,
                                color: AppColors.textSecondary,
                                size: 24.0,
                              ),
                            ].divide(SizedBox(width: 12.0)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 32.0),
                    child: Container(
                      width: double.infinity,
                      height: 56.0,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundPrimary,
                        borderRadius: BorderRadius.circular(4.0),
                        border: Border.all(
                          color: AppColors.neutral800,
                        ),
                      ),
                      child: TextButton.icon(
                        onPressed: () async {
                          await authManager.signOut();

                          context.goNamed(WelcomeWidget.routeName);
                        },
                        icon: Icon(
                          Icons.logout_rounded,
                          size: 22.0,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Logout',
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500, fontSize: 17.0, color: Colors.white),
                        ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                      ),
                    ),
                  ),
                ]
                    .addToStart(SizedBox(height: 24.0))
                    .addToEnd(SizedBox(height: 32.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
