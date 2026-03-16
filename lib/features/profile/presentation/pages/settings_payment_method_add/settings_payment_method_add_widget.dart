import '/features/checkout/domain/models/payment_method_model.dart';
import '/features/checkout/domain/models/payment_card_model.dart';
import '/features/checkout/domain/models/billing_details_model.dart';
import '/custom_code/actions/index.dart' as actions;
import '/core/theme/app_colors.dart';
import '/core/utils/form_validators.dart';
import '/core/widgets/app_text_field.dart';
import '/core/utils/geo_data.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/app_gradient_button.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import '/features/checkout/presentation/providers/checkout_provider.dart';
import '/core/router/app_router.dart';
import '/core/widgets/dismiss_keyboard.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class SettingsPaymentMethodAddWidget extends ConsumerStatefulWidget {
  const SettingsPaymentMethodAddWidget({super.key});

  static String routeName = 'settingsPaymentMethodAdd';
  static String routePath = 'settingsPaymentMethodAdd';

  @override
  ConsumerState<SettingsPaymentMethodAddWidget> createState() =>
      _SettingsPaymentMethodAddWidgetState();
}

class _SettingsPaymentMethodAddWidgetState
    extends ConsumerState<SettingsPaymentMethodAddWidget>
    with TickerProviderStateMixin {
  // Local state fields
  bool setAsDefault = false;
  String? countryDropdownValue;
  String? stateDropdownValue;
  dynamic result;

  // Text controllers, focus nodes, and masks
  late final TextEditingController cardNumberTextController;
  late final FocusNode cardNumberFocusNode;
  late final MaskTextInputFormatter cardNumberMask;
  late final TextEditingController expireDateTextController;
  late final FocusNode expireDateFocusNode;
  late final MaskTextInputFormatter expireDateMask;
  late final TextEditingController textFieldaCVCTextController;
  late final FocusNode textFieldaCVCFocusNode;
  late final MaskTextInputFormatter textFieldaCVCMask;
  late final TextEditingController cardholderNameTextController;
  late final FocusNode cardholderNameFocusNode;
  late final TextEditingController emailAddressTextController;
  late final FocusNode emailAddressFocusNode;
  late final TextEditingController fullNameTextController;
  late final FocusNode fullNameFocusNode;
  late final TextEditingController addressLine1TextController;
  late final FocusNode addressLine1FocusNode;
  late final TextEditingController addressLine2TextController;
  late final FocusNode addressLine2FocusNode;
  late final TextEditingController stateTextController;
  late final FocusNode stateFocusNode;
  late final TextEditingController cityTextController;
  late final FocusNode cityFocusNode;
  late final TextEditingController zipCodeTextController;
  late final FocusNode zipCodeFocusNode;

  @override
  void initState() {
    super.initState();

    cardNumberTextController = TextEditingController();
    cardNumberFocusNode = FocusNode();    cardNumberMask = MaskTextInputFormatter(mask: '#### #### #### ####');
    expireDateTextController = TextEditingController();
    expireDateFocusNode = FocusNode();    expireDateMask = MaskTextInputFormatter(mask: '##/##');
    textFieldaCVCTextController = TextEditingController();
    textFieldaCVCFocusNode = FocusNode();    textFieldaCVCMask = MaskTextInputFormatter(mask: '###');
    cardholderNameTextController = TextEditingController();
    cardholderNameFocusNode = FocusNode();    emailAddressTextController = TextEditingController();
    emailAddressFocusNode = FocusNode();    fullNameTextController = TextEditingController();
    fullNameFocusNode = FocusNode();    addressLine1TextController = TextEditingController();
    addressLine1FocusNode = FocusNode();    addressLine2TextController = TextEditingController();
    addressLine2FocusNode = FocusNode();    stateTextController = TextEditingController();
    stateFocusNode = FocusNode();    cityTextController = TextEditingController();
    cityFocusNode = FocusNode();    zipCodeTextController = TextEditingController();
    zipCodeFocusNode = FocusNode();  }

  @override
  void dispose() {
    cardNumberFocusNode.dispose();
    cardNumberTextController.dispose();
    expireDateFocusNode.dispose();
    expireDateTextController.dispose();
    textFieldaCVCFocusNode.dispose();
    textFieldaCVCTextController.dispose();
    cardholderNameFocusNode.dispose();
    cardholderNameTextController.dispose();
    emailAddressFocusNode.dispose();
    emailAddressTextController.dispose();
    fullNameFocusNode.dispose();
    fullNameTextController.dispose();
    addressLine1FocusNode.dispose();
    addressLine1TextController.dispose();
    addressLine2FocusNode.dispose();
    addressLine2TextController.dispose();
    stateFocusNode.dispose();
    stateTextController.dispose();
    cityFocusNode.dispose();
    cityTextController.dispose();
    zipCodeFocusNode.dispose();
    zipCodeTextController.dispose();
    super.dispose();
  }

  static TextStyle _labelStyle({double fontSize = 15.0}) {
    return GoogleFonts.inter(fontSize: fontSize, color: AppColors.textPrimary);
  }

  String _jsonStr(dynamic json, String key) {
    if (json is Map) return (json[key] ?? '').toString();
    return '';
  }

  static InputDecoration _dropdownDecoration(String hintText) {
    return InputDecoration(
      isDense: true,
      hintText: hintText,
      hintStyle:
          GoogleFonts.inter(fontSize: 14.0, color: AppColors.textSecondary),
      contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.neutral700, width: 1.0),
        borderRadius: BorderRadius.circular(4.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.neutral700, width: 1.0),
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
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
            onPressed: () async {
              context.pop();
            },
          ),
          title: Text(
            'Payment Method',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Card Information',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Text('Card Number', style: _labelStyle()),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Container(
                      width: double.infinity,
                      child: TextFormField(
                        controller: cardNumberTextController,
                        focusNode: cardNumberFocusNode,
                        onChanged: (_) => EasyDebounce.debounce(
                          'cardNumberTextController',
                          Duration(milliseconds: 100),
                          () => setState(() {}),
                        ),
                        autofocus: false,
                        obscureText: false,
                        decoration:
                            appInputDecoration('Enter 16 digit card number'),
                        style: appTextFieldStyle,
                        keyboardType: TextInputType.number,
                        cursorColor: AppColors.textPrimary,
                        inputFormatters: [cardNumberMask],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Expire Date', style: _labelStyle()),
                              Container(
                                width: double.infinity,
                                child: TextFormField(
                                  controller: expireDateTextController,
                                  focusNode: expireDateFocusNode,
                                  onChanged: (_) => EasyDebounce.debounce(
                                    'expireDateTextController',
                                    Duration(milliseconds: 100),
                                    () => setState(() {}),
                                  ),
                                  autofocus: false,
                                  obscureText: false,
                                  decoration: appInputDecoration('MM/YY'),
                                  style: appTextFieldStyle,
                                  keyboardType: TextInputType.number,
                                  cursorColor: AppColors.textPrimary,
                                  inputFormatters: [expireDateMask],
                                ),
                              ),
                            ].divide(SizedBox(height: 8.0)),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('CVC', style: _labelStyle()),
                              Container(
                                width: double.infinity,
                                child: TextFormField(
                                  controller: textFieldaCVCTextController,
                                  focusNode: textFieldaCVCFocusNode,
                                  onChanged: (_) => EasyDebounce.debounce(
                                    'textFieldaCVCTextController',
                                    Duration(milliseconds: 100),
                                    () => setState(() {}),
                                  ),
                                  autofocus: false,
                                  obscureText: false,
                                  decoration: appInputDecoration('CVC'),
                                  style: appTextFieldStyle,
                                  keyboardType: TextInputType.number,
                                  cursorColor: AppColors.textPrimary,
                                  inputFormatters: [textFieldaCVCMask],
                                ),
                              ),
                            ].divide(SizedBox(height: 8.0)),
                          ),
                        ),
                      ].divide(SizedBox(width: 12.0)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Text('Cardholder Name', style: _labelStyle()),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Container(
                      width: double.infinity,
                      child: TextFormField(
                        controller: cardholderNameTextController,
                        focusNode: cardholderNameFocusNode,
                        onChanged: (_) => EasyDebounce.debounce(
                          'cardholderNameTextController',
                          Duration(milliseconds: 100),
                          () => setState(() {}),
                        ),
                        autofocus: false,
                        obscureText: false,
                        decoration:
                            appInputDecoration('Full name as shown as card'),
                        style: appTextFieldStyle,
                        cursorColor: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Divider(
                    height: 48.0,
                    thickness: 1.0,
                    color: AppColors.surfaceDark,
                  ),
                  Text(
                    'Billing Address',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Text('Email Address', style: _labelStyle()),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Container(
                      width: double.infinity,
                      child: TextFormField(
                        controller: emailAddressTextController,
                        focusNode: emailAddressFocusNode,
                        onChanged: (_) => EasyDebounce.debounce(
                          'emailAddressTextController',
                          Duration(milliseconds: 100),
                          () => setState(() {}),
                        ),
                        autofocus: false,
                        obscureText: false,
                        decoration: appInputDecoration('example@example.com'),
                        style: appTextFieldStyle,
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Text('Full Name', style: _labelStyle()),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Container(
                      width: double.infinity,
                      child: TextFormField(
                        controller: fullNameTextController,
                        focusNode: fullNameFocusNode,
                        onChanged: (_) => EasyDebounce.debounce(
                          'fullNameTextController',
                          Duration(milliseconds: 100),
                          () => setState(() {}),
                        ),
                        autofocus: false,
                        autofillHints: [AutofillHints.name],
                        obscureText: false,
                        decoration: appInputDecoration('Enter full name'),
                        style: appTextFieldStyle,
                        cursorColor: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Text('Address', style: _labelStyle()),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Container(
                      width: double.infinity,
                      child: TextFormField(
                        controller: addressLine1TextController,
                        focusNode: addressLine1FocusNode,
                        onChanged: (_) => EasyDebounce.debounce(
                          'addressLine1TextController',
                          Duration(milliseconds: 100),
                          () => setState(() {}),
                        ),
                        autofocus: false,
                        autofillHints: [AutofillHints.streetAddressLine1],
                        obscureText: false,
                        decoration: appInputDecoration('123, Main street'),
                        style: appTextFieldStyle,
                        cursorColor: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Container(
                      width: double.infinity,
                      child: TextFormField(
                        controller: addressLine2TextController,
                        focusNode: addressLine2FocusNode,
                        onChanged: (_) => EasyDebounce.debounce(
                          'addressLine2TextController',
                          Duration(milliseconds: 100),
                          () => setState(() {}),
                        ),
                        autofocus: false,
                        autofillHints: [AutofillHints.streetAddressLine2],
                        obscureText: false,
                        decoration: appInputDecoration(
                            'Apartment, suite, etc. (optional)'),
                        style: appTextFieldStyle,
                        cursorColor: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Country', style: _labelStyle()),
                              SizedBox(
                                height: 52.0,
                                child: DropdownButtonFormField<String>(
                                  initialValue:
                                      (countryDropdownValue ?? '').isEmpty
                                          ? null
                                          : countryDropdownValue,
                                  items: GeoData.getCountries()
                                      .map((c) => DropdownMenuItem(
                                            value: c['code'],
                                            child: Text(c['name']!,
                                                style: appTextFieldStyle),
                                          ))
                                      .toList(),
                                  onChanged: (val) => setState(
                                      () => countryDropdownValue = val),
                                  decoration: _dropdownDecoration('Country'),
                                  dropdownColor: AppColors.backgroundPrimary,
                                  icon: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: AppColors.textSecondary,
                                    size: 24.0,
                                  ),
                                  style: appTextFieldStyle,
                                  isExpanded: true,
                                ),
                              ),
                            ].divide(SizedBox(height: 8.0)),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('State', style: _labelStyle()),
                              Builder(
                                builder: (context) {
                                  if ((countryDropdownValue == 'US') ||
                                      (countryDropdownValue == 'CA')) {
                                    return SizedBox(
                                      height: 52.0,
                                      child: DropdownButtonFormField<String>(
                                        initialValue:
                                            (stateDropdownValue ?? '').isEmpty
                                                ? null
                                                : stateDropdownValue,
                                        items: GeoData.getStatesByCountry(
                                                countryDropdownValue)
                                            .map((name) => DropdownMenuItem(
                                                  value: name,
                                                  child: Text(name,
                                                      style: appTextFieldStyle),
                                                ))
                                            .toList(),
                                        onChanged: (val) => setState(
                                            () => stateDropdownValue = val),
                                        decoration:
                                            _dropdownDecoration('State'),
                                        dropdownColor:
                                            AppColors.backgroundPrimary,
                                        icon: Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: AppColors.textSecondary,
                                          size: 24.0,
                                        ),
                                        style: appTextFieldStyle,
                                        isExpanded: true,
                                      ),
                                    );
                                  } else {
                                    return Container(
                                      width: double.infinity,
                                      child: TextFormField(
                                        controller: stateTextController,
                                        focusNode: stateFocusNode,
                                        onChanged: (_) => EasyDebounce.debounce(
                                          'stateTextController',
                                          Duration(milliseconds: 100),
                                          () => setState(() {}),
                                        ),
                                        autofocus: false,
                                        obscureText: false,
                                        decoration: appInputDecoration('State'),
                                        style: appTextFieldStyle,
                                        cursorColor: AppColors.textPrimary,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ].divide(SizedBox(height: 8.0)),
                          ),
                        ),
                      ].divide(SizedBox(width: 12.0)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('City', style: _labelStyle()),
                              Container(
                                width: double.infinity,
                                child: TextFormField(
                                  controller: cityTextController,
                                  focusNode: cityFocusNode,
                                  onChanged: (_) => EasyDebounce.debounce(
                                    'cityTextController',
                                    Duration(milliseconds: 100),
                                    () => setState(() {}),
                                  ),
                                  autofocus: false,
                                  obscureText: false,
                                  decoration: appInputDecoration('City'),
                                  style: appTextFieldStyle,
                                  cursorColor: AppColors.textPrimary,
                                ),
                              ),
                            ].divide(SizedBox(height: 8.0)),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Zip Code', style: _labelStyle()),
                              Container(
                                width: double.infinity,
                                child: TextFormField(
                                  controller: zipCodeTextController,
                                  focusNode: zipCodeFocusNode,
                                  onChanged: (_) => EasyDebounce.debounce(
                                    'zipCodeTextController',
                                    Duration(milliseconds: 100),
                                    () => setState(() {}),
                                  ),
                                  autofocus: false,
                                  obscureText: false,
                                  decoration: appInputDecoration('10001'),
                                  style: appTextFieldStyle,
                                  keyboardType: TextInputType.number,
                                  cursorColor: AppColors.textPrimary,
                                ),
                              ),
                            ].divide(SizedBox(height: 8.0)),
                          ),
                        ),
                      ].divide(SizedBox(width: 12.0)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 24.0),
                    child: InkWell(
                      onTap: () async {
                        setAsDefault = !setAsDefault;
                        setState(() {});
                      },
                      child: Row(
                        children: [
                          if (!setAsDefault)
                            Container(
                              width: 22.0,
                              height: 22.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.0),
                                border: Border.all(
                                  color: AppColors.neutral700,
                                ),
                              ),
                            ),
                          if (setAsDefault)
                            Container(
                              width: 22.0,
                              height: 22.0,
                              decoration: BoxDecoration(
                                color: AppColors.secondary,
                                borderRadius: BorderRadius.circular(4.0),
                                border: Border.all(
                                  color: AppColors.neutral700,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.check_sharp,
                                  color: Colors.white,
                                  size: 12.0,
                                ),
                              ),
                            ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Set as default payment method',
                                  style:
                                      Theme.of(context).textTheme.bodyMedium!,
                                ).animate().fade(duration: 600.ms),
                                Text(
                                  'This card will  be used for future purchases',
                                  style:
                                      Theme.of(context).textTheme.labelMedium!,
                                ).animate().fade(duration: 600.ms),
                              ],
                            ),
                          ),
                        ].divide(SizedBox(width: 8.0)),
                      ),
                    ),
                  ),
                  Divider(
                    height: 48.0,
                    thickness: 1.0,
                    color: AppColors.surfaceDark,
                  ),
                  Container(
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(fontWeight: FontWeight.w500),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    'Your payment information is encrypted and securely processed by Stripe. We never store your card details on our servers.',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium!,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ].divide(SizedBox(width: 12.0)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 36.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: AppOutlineButton(
                            text: 'Cancel',
                            onPressed: () {
                              context.safePop();
                            },
                          ),
                        ),
                        Expanded(
                          child: AppGradientButton(
                            text: 'Add Card',
                            onPressed: () async {
                              final validationResult =
                                  FormValidators.paymentValidator(
                                      cardNumberTextController.text,
                                      expireDateTextController.text,
                                      textFieldaCVCTextController.text,
                                      cardholderNameTextController.text,
                                      emailAddressTextController.text,
                                      fullNameTextController.text,
                                      addressLine1TextController.text,
                                      addressLine2TextController.text,
                                      countryDropdownValue ?? '',
                                      (countryDropdownValue == 'US') ||
                                              (countryDropdownValue == 'CA')
                                          ? (stateDropdownValue ?? '')
                                          : stateTextController.text,
                                      cityTextController.text,
                                      zipCodeTextController.text);
                              if (validationResult['success'] != true) {
                                await actions.toastificationshow(
                                  context,
                                  'Error!',
                                  (validationResult['message'] ?? '')
                                      .toString(),
                                  'error',
                                );
                                return;
                              }
                              final parsedDate =
                                  FormValidators.parseMonthYear(
                                      expireDateTextController.text);
                              result = await actions.addPaymentCard(
                                cardNumberTextController.text,
                                parsedDate['month'] ?? '',
                                parsedDate['year'] ?? '',
                                textFieldaCVCTextController.text,
                                cardholderNameTextController.text,
                                emailAddressTextController.text,
                                addressLine1TextController.text,
                                addressLine2TextController.text,
                                cityTextController.text,
                                (countryDropdownValue == 'US') ||
                                        (countryDropdownValue == 'CA')
                                    ? stateDropdownValue
                                    : stateTextController.text,
                                zipCodeTextController.text,
                                countryDropdownValue,
                                setAsDefault,
                              );
                              if (!mounted) return;
                              if (result is Map &&
                                  result['success'] == false) {
                                await actions.toastificationshow(
                                  context,
                                  'Error!',
                                  (result['error'] ?? 'Failed to add card')
                                      .toString(),
                                  'error',
                                );
                                return;
                              }
                              final newPaymentMethod = PaymentMethod(
                                id: _jsonStr(result, 'payment_method_id'),
                                card: PaymentCard(
                                  brand: _jsonStr(result, 'card_brand'),
                                  last4: _jsonStr(result, 'card_last4'),
                                  expMonth: ((result is Map)
                                      ? result['card_exp_month']
                                      : null),
                                  expYear: ((result is Map)
                                      ? result['card_exp_year']
                                      : null),
                                ),
                                isDefault: ((result is Map)
                                    ? result['is_default']
                                    : null),
                                billingDetails: BillingDetails(
                                  name: fullNameTextController.text,
                                  email: emailAddressTextController.text,
                                  addressLine1:
                                      addressLine1TextController.text,
                                  addressLine2:
                                      addressLine2TextController.text,
                                  country: countryDropdownValue ?? '',
                                  state: (countryDropdownValue == 'US') ||
                                          (countryDropdownValue == 'CA')
                                      ? stateDropdownValue ?? ''
                                      : stateTextController.text,
                                  city: cityTextController.text,
                                  postalCode: zipCodeTextController.text,
                                ),
                              );
                              ref
                                  .read(authProvider.notifier)
                                  .updateUser((e) => e.copyWith(
                                        paymentMethod: [
                                          ...e.paymentMethod,
                                          newPaymentMethod
                                        ],
                                      ));
                              ref
                                  .read(checkoutProvider.notifier)
                                  .setPaymentMethod(newPaymentMethod);
                              if (!mounted) return;
                              context.safePop();
                            },
                          ),
                        ),
                      ].divide(SizedBox(width: 20.0)),
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
