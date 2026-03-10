import '/features/checkout/domain/models/payment_method_model.dart';
import '/features/checkout/domain/models/payment_card_model.dart';
import '/features/checkout/domain/models/billing_details_model.dart';
import '/custom_code/actions/index.dart' as actions;
import '/core/theme/app_colors.dart';
import '/core/utils/form_validators.dart';
import '/core/widgets/app_text_field.dart';
import '/core/utils/geo_data.dart';
import '/core/utils/list_extensions.dart';
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
import 'settings_payment_method_add_model.dart';
export 'settings_payment_method_add_model.dart';

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
  late SettingsPaymentMethodAddModel _model;

  @override
  void initState() {
    super.initState();
    _model = SettingsPaymentMethodAddModel();

    _model.cardNumberTextController ??= TextEditingController();
    _model.cardNumberFocusNode ??= FocusNode();
    _model.cardNumberFocusNode!.addListener(() => setState(() {}));
    _model.cardNumberMask = MaskTextInputFormatter(mask: '#### #### #### ####');
    _model.expireDateTextController ??= TextEditingController();
    _model.expireDateFocusNode ??= FocusNode();
    _model.expireDateFocusNode!.addListener(() => setState(() {}));
    _model.expireDateMask = MaskTextInputFormatter(mask: '##/##');
    _model.textFieldaCVCTextController ??= TextEditingController();
    _model.textFieldaCVCFocusNode ??= FocusNode();
    _model.textFieldaCVCFocusNode!.addListener(() => setState(() {}));
    _model.textFieldaCVCMask = MaskTextInputFormatter(mask: '###');
    _model.cardholderNameTextController ??= TextEditingController();
    _model.cardholderNameFocusNode ??= FocusNode();
    _model.cardholderNameFocusNode!.addListener(() => setState(() {}));
    _model.emailAddressTextController ??= TextEditingController();
    _model.emailAddressFocusNode ??= FocusNode();
    _model.emailAddressFocusNode!.addListener(() => setState(() {}));
    _model.fullNameTextController ??= TextEditingController();
    _model.fullNameFocusNode ??= FocusNode();
    _model.fullNameFocusNode!.addListener(() => setState(() {}));
    _model.addressLine1TextController ??= TextEditingController();
    _model.addressLine1FocusNode ??= FocusNode();
    _model.addressLine1FocusNode!.addListener(() => setState(() {}));
    _model.addressLine2TextController ??= TextEditingController();
    _model.addressLine2FocusNode ??= FocusNode();
    _model.addressLine2FocusNode!.addListener(() => setState(() {}));
    _model.stateTextController ??= TextEditingController();
    _model.stateFocusNode ??= FocusNode();
    _model.stateFocusNode!.addListener(() => setState(() {}));
    _model.cityTextController ??= TextEditingController();
    _model.cityFocusNode ??= FocusNode();
    _model.cityFocusNode!.addListener(() => setState(() {}));
    _model.zipCodeTextController ??= TextEditingController();
    _model.zipCodeFocusNode ??= FocusNode();
    _model.zipCodeFocusNode!.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

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
      hintStyle: GoogleFonts.inter(
        fontWeight: FontWeight.normal,
        fontSize: 14.0,
        color: AppColors.textSecondary,
      ),
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
                    'Card Information',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 18.0,
                    ),
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
                        controller: _model.cardNumberTextController,
                        focusNode: _model.cardNumberFocusNode,
                        onChanged: (_) => EasyDebounce.debounce(
                          '_model.cardNumberTextController',
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
                        inputFormatters: [_model.cardNumberMask],
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
                                  controller: _model.expireDateTextController,
                                  focusNode: _model.expireDateFocusNode,
                                  onChanged: (_) => EasyDebounce.debounce(
                                    '_model.expireDateTextController',
                                    Duration(milliseconds: 100),
                                    () => setState(() {}),
                                  ),
                                  autofocus: false,
                                  obscureText: false,
                                  decoration: appInputDecoration('MM/YY'),
                                  style: appTextFieldStyle,
                                  keyboardType: TextInputType.number,
                                  cursorColor: AppColors.textPrimary,
                                  inputFormatters: [_model.expireDateMask],
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
                                  controller:
                                      _model.textFieldaCVCTextController,
                                  focusNode: _model.textFieldaCVCFocusNode,
                                  onChanged: (_) => EasyDebounce.debounce(
                                    '_model.textFieldaCVCTextController',
                                    Duration(milliseconds: 100),
                                    () => setState(() {}),
                                  ),
                                  autofocus: false,
                                  obscureText: false,
                                  decoration: appInputDecoration('CVC'),
                                  style: appTextFieldStyle,
                                  keyboardType: TextInputType.number,
                                  cursorColor: AppColors.textPrimary,
                                  inputFormatters: [_model.textFieldaCVCMask],
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
                        controller: _model.cardholderNameTextController,
                        focusNode: _model.cardholderNameFocusNode,
                        onChanged: (_) => EasyDebounce.debounce(
                          '_model.cardholderNameTextController',
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
                    color: Color(0xFF363636),
                  ),
                  Text(
                    'Billing Address',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 18.0,
                    ),
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
                        controller: _model.emailAddressTextController,
                        focusNode: _model.emailAddressFocusNode,
                        onChanged: (_) => EasyDebounce.debounce(
                          '_model.emailAddressTextController',
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
                        controller: _model.fullNameTextController,
                        focusNode: _model.fullNameFocusNode,
                        onChanged: (_) => EasyDebounce.debounce(
                          '_model.fullNameTextController',
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
                        controller: _model.addressLine1TextController,
                        focusNode: _model.addressLine1FocusNode,
                        onChanged: (_) => EasyDebounce.debounce(
                          '_model.addressLine1TextController',
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
                        controller: _model.addressLine2TextController,
                        focusNode: _model.addressLine2FocusNode,
                        onChanged: (_) => EasyDebounce.debounce(
                          '_model.addressLine2TextController',
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
                                      (_model.countryDropdownValue ?? '')
                                              .isEmpty
                                          ? null
                                          : _model.countryDropdownValue,
                                  items: GeoData.getCountries()
                                      .map((c) => DropdownMenuItem(
                                            value: c['code'],
                                            child: Text(c['name']!,
                                                style: appTextFieldStyle),
                                          ))
                                      .toList(),
                                  onChanged: (val) => setState(
                                      () => _model.countryDropdownValue = val),
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
                                  if ((_model.countryDropdownValue == 'US') ||
                                      (_model.countryDropdownValue == 'CA')) {
                                    return SizedBox(
                                      height: 52.0,
                                      child: DropdownButtonFormField<String>(
                                        initialValue:
                                            (_model.stateDropdownValue ?? '')
                                                    .isEmpty
                                                ? null
                                                : _model.stateDropdownValue,
                                        items: GeoData.getStatesByCountry(
                                                _model.countryDropdownValue)
                                            .map((name) => DropdownMenuItem(
                                                  value: name,
                                                  child: Text(name,
                                                      style: appTextFieldStyle),
                                                ))
                                            .toList(),
                                        onChanged: (val) => setState(() =>
                                            _model.stateDropdownValue = val),
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
                                        controller: _model.stateTextController,
                                        focusNode: _model.stateFocusNode,
                                        onChanged: (_) => EasyDebounce.debounce(
                                          '_model.stateTextController',
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
                                  controller: _model.cityTextController,
                                  focusNode: _model.cityFocusNode,
                                  onChanged: (_) => EasyDebounce.debounce(
                                    '_model.cityTextController',
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
                                  controller: _model.zipCodeTextController,
                                  focusNode: _model.zipCodeFocusNode,
                                  onChanged: (_) => EasyDebounce.debounce(
                                    '_model.zipCodeTextController',
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
                        _model.setAsDefault = !_model.setAsDefault;
                        setState(() {});
                      },
                      child: Row(
                        children: [
                          if (!_model.setAsDefault)
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
                          if (_model.setAsDefault)
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
                              child: Align(
                                alignment: Alignment.center,
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
                                  style: GoogleFonts.inter(
                                    color: AppColors.textPrimary,
                                    fontSize: 14.0,
                                  ),
                                ).animate().fade(duration: 600.ms),
                                Text(
                                  'This card will  be used for future purchases',
                                  style: GoogleFonts.inter(
                                    color: Color(0xFFAFAFB4),
                                    fontSize: 14.0,
                                  ),
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
                    color: Color(0xFF363636),
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
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    'Your payment information is encrypted and securely processed by Stripe. We never store your card details on our servers.',
                                    style: GoogleFonts.inter(fontSize: 14.0),
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
                          child: TextButton(
                            onPressed: () async {
                              context.safePop();
                            },
                            style: TextButton.styleFrom(
                              minimumSize: Size(double.infinity, 56.0),
                              backgroundColor: AppColors.backgroundPrimary,
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                                side: BorderSide(color: Color(0xFF545454)),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontSize: 17.0,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            height: 56.0,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF7D56FF), Color(0xFF6187F1)],
                                stops: [0.0, 1.0],
                                begin: Alignment.topCenter,
                                end: AlignmentDirectional(0, 1.0),
                              ),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: TextButton.icon(
                              onPressed: () async {
                                final validationResult =
                                    FormValidators.paymentValidator(
                                        _model.cardNumberTextController!.text,
                                        _model.expireDateTextController!.text,
                                        _model
                                            .textFieldaCVCTextController!.text,
                                        _model
                                            .cardholderNameTextController!.text,
                                        _model.emailAddressTextController!.text,
                                        _model.fullNameTextController!.text,
                                        _model.addressLine1TextController!.text,
                                        _model.addressLine2TextController!.text,
                                        _model.countryDropdownValue ?? '',
                                        (_model.countryDropdownValue == 'US') ||
                                                (_model.countryDropdownValue ==
                                                    'CA')
                                            ? (_model.stateDropdownValue ?? '')
                                            : _model.stateTextController!.text,
                                        _model.cityTextController!.text,
                                        _model.zipCodeTextController!.text);
                                if (validationResult['success'] == true) {
                                  final parsedDate =
                                      FormValidators.parseMonthYear(_model
                                          .expireDateTextController!.text);
                                  _model.result = await actions.addPaymentCard(
                                    _model.cardNumberTextController!.text,
                                    parsedDate['month'] ?? '',
                                    parsedDate['year'] ?? '',
                                    _model.textFieldaCVCTextController!.text,
                                    _model.cardholderNameTextController!.text,
                                    _model.emailAddressTextController!.text,
                                    _model.addressLine1TextController!.text,
                                    _model.addressLine2TextController!.text,
                                    _model.cityTextController!.text,
                                    (_model.countryDropdownValue == 'US') ||
                                            (_model.countryDropdownValue ==
                                                'CA')
                                        ? _model.stateDropdownValue
                                        : _model.stateTextController!.text,
                                    _model.zipCodeTextController!.text,
                                    _model.countryDropdownValue,
                                    _model.setAsDefault,
                                  );
                                  final newPaymentMethod = PaymentMethod(
                                    id: _jsonStr(
                                        _model.result, 'payment_method_id'),
                                    card: PaymentCard(
                                      brand:
                                          _jsonStr(_model.result, 'card_brand'),
                                      last4:
                                          _jsonStr(_model.result, 'card_last4'),
                                      expMonth: ((_model.result is Map)
                                          ? _model.result['card_exp_month']
                                          : null),
                                      expYear: ((_model.result is Map)
                                          ? _model.result['card_exp_year']
                                          : null),
                                    ),
                                    isDefault: ((_model.result is Map)
                                        ? _model.result['is_default']
                                        : null),
                                    billingDetails: BillingDetails(
                                      name: _model.fullNameTextController!.text,
                                      email: _model
                                          .emailAddressTextController!.text,
                                      addressLine1: _model
                                          .addressLine1TextController!.text,
                                      addressLine2: _model
                                          .addressLine2TextController!.text,
                                      country:
                                          _model.countryDropdownValue ?? '',
                                      state: (_model.countryDropdownValue ==
                                                  'US') ||
                                              (_model.countryDropdownValue ==
                                                  'CA')
                                          ? _model.stateDropdownValue ?? ''
                                          : _model.stateTextController!.text,
                                      city: _model.cityTextController!.text,
                                      postalCode:
                                          _model.zipCodeTextController!.text,
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
                                  setState(() {});
                                  context.safePop();
                                } else {
                                  await actions.toastificationshow(
                                    context,
                                    'Error!',
                                    (validationResult['message'] ?? '')
                                        .toString(),
                                    'error',
                                  );
                                }

                                setState(() {});
                              },
                              icon: Icon(
                                Icons.add,
                                size: 28.0,
                                color: Colors.white,
                              ),
                              label: Text(
                                'Add Card',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                minimumSize: Size(double.infinity, 56.0),
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                              ),
                            ),
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
