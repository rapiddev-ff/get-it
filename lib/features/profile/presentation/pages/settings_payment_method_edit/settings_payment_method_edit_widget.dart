import '/features/checkout/domain/models/payment_method_model.dart';
import '/features/checkout/domain/models/billing_details_model.dart';
import '/custom_code/actions/index.dart' as actions;
import '/core/theme/app_colors.dart';
import '/core/utils/form_validators.dart';
import '/core/widgets/app_text_field.dart';
import '/core/widgets/app_gradient_button.dart';
import '/core/utils/geo_data.dart';
import '/core/utils/list_extensions.dart';
import '/core/router/app_router.dart';
import '/core/widgets/dismiss_keyboard.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'settings_payment_method_edit_model.dart';
export 'settings_payment_method_edit_model.dart';

class SettingsPaymentMethodEditWidget extends ConsumerStatefulWidget {
  const SettingsPaymentMethodEditWidget({
    super.key,
    required this.paymentMethod,
    this.index,
  });

  final PaymentMethod? paymentMethod;
  final int? index;

  static String routeName = 'settingsPaymentMethodEdit';
  static String routePath = 'settingsPaymentMethodEdit';

  @override
  ConsumerState<SettingsPaymentMethodEditWidget> createState() =>
      _SettingsPaymentMethodEditWidgetState();
}

class _SettingsPaymentMethodEditWidgetState
    extends ConsumerState<SettingsPaymentMethodEditWidget>
    with TickerProviderStateMixin {
  late SettingsPaymentMethodEditModel _model;

  @override
  void initState() {
    super.initState();
    _model = SettingsPaymentMethodEditModel();

    _model.cardNumberTextController ??= TextEditingController(
        text: '.... .... .... ${widget.paymentMethod?.card?.last4 ?? ''}');
    _model.cardNumberFocusNode ??= FocusNode();

    _model.cardNumberMask = MaskTextInputFormatter(mask: '#### #### #### ####');
    _model.expireDateTextController ??= TextEditingController(
        text:
            '${widget.paymentMethod?.card?.expMonth.toString() ?? ''}/${widget.paymentMethod?.card?.expYear.toString() ?? ''}');
    _model.expireDateFocusNode ??= FocusNode();

    _model.expireDateMask = MaskTextInputFormatter(mask: '##/##');
    _model.textFieldaCVCTextController ??= TextEditingController();
    _model.textFieldaCVCFocusNode ??= FocusNode();

    _model.cardholderNameTextController ??=
        TextEditingController(text: widget.paymentMethod?.billingDetails?.name);
    _model.cardholderNameFocusNode ??= FocusNode();

    _model.emailAddressTextController ??= TextEditingController(
        text: widget.paymentMethod?.billingDetails?.email);
    _model.emailAddressFocusNode ??= FocusNode();
    _model.emailAddressFocusNode!.addListener(() => setState(() {}));
    _model.fullNameTextController ??=
        TextEditingController(text: widget.paymentMethod?.billingDetails?.name);
    _model.fullNameFocusNode ??= FocusNode();
    _model.fullNameFocusNode!.addListener(() => setState(() {}));
    _model.addressLine1TextController ??= TextEditingController(
        text: widget.paymentMethod?.billingDetails?.addressLine1);
    _model.addressLine1FocusNode ??= FocusNode();
    _model.addressLine1FocusNode!.addListener(() => setState(() {}));
    _model.addressLine2TextController ??= TextEditingController(
        text: widget.paymentMethod?.billingDetails?.addressLine2);
    _model.addressLine2FocusNode ??= FocusNode();
    _model.addressLine2FocusNode!.addListener(() => setState(() {}));
    _model.stateTextController ??= TextEditingController(
        text: widget.paymentMethod?.billingDetails?.state);
    _model.stateFocusNode ??= FocusNode();
    _model.stateFocusNode!.addListener(() => setState(() {}));
    _model.cityTextController ??=
        TextEditingController(text: widget.paymentMethod?.billingDetails?.city);
    _model.cityFocusNode ??= FocusNode();
    _model.cityFocusNode!.addListener(() => setState(() {}));
    _model.zipCodeTextController ??= TextEditingController(
        text: widget.paymentMethod?.billingDetails?.postalCode);
    _model.zipCodeFocusNode ??= FocusNode();
    _model.zipCodeFocusNode!.addListener(() => setState(() {}));

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
          _model.textFieldaCVCTextController?.text = '***';
        }));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  static InputDecoration _fieldDecoration({
    required String hintText,
  }) {
    return InputDecoration(
      isDense: false,
      hintText: hintText,
      hintStyle: GoogleFonts.inter(
        fontSize: 16.0,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.neutral700, width: 1.0),
        borderRadius: BorderRadius.circular(4.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.neutral700, width: 1.0),
        borderRadius: BorderRadius.circular(4.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.error, width: 1.0),
        borderRadius: BorderRadius.circular(4.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.error, width: 1.0),
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
  }

  static TextStyle _labelStyle() {
    return GoogleFonts.inter(fontSize: 15.0, color: AppColors.textPrimary);
  }

  static InputDecoration _dropdownDecoration(String hintText) {
    return InputDecoration(
      isDense: true,
      hintText: hintText,
      hintStyle: GoogleFonts.inter(
        fontSize: 14.0,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
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
                    padding: EdgeInsets.only(top: 8.0),
                    child: Container(
                      width: double.infinity,
                      child: TextFormField(
                        controller: _model.cardNumberTextController,
                        focusNode: _model.cardNumberFocusNode,
                        autofocus: false,
                        readOnly: true,
                        obscureText: false,
                        decoration: _fieldDecoration(
                          hintText: 'Enter 16 digit card number',
                        ),
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
                                  autofocus: false,
                                  readOnly: true,
                                  obscureText: false,
                                  decoration:
                                      _fieldDecoration(hintText: 'MM/YY'),
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
                                  autofocus: false,
                                  readOnly: true,
                                  obscureText: false,
                                  decoration: _fieldDecoration(hintText: 'CVC'),
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
                        autofocus: false,
                        readOnly: true,
                        obscureText: false,
                        decoration: _fieldDecoration(
                          hintText: 'Full name as shown as card',
                        ),
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
                              DropdownButtonFormField<String>(
                                initialValue: () {
                                  final saved = _model.countryDropdownValue ??=
                                      widget.paymentMethod?.billingDetails
                                              ?.country ??
                                          '';
                                  if (saved.isEmpty) return null;
                                  final codes = GeoData.getCountries()
                                      .map((c) => c['code']!)
                                      .toSet();
                                  if (codes.contains(saved)) return saved;
                                  final match = GeoData.getCountries()
                                      .where((c) =>
                                          c['name']!.toLowerCase() ==
                                          saved.toLowerCase())
                                      .toList();
                                  if (match.isNotEmpty) {
                                    _model.countryDropdownValue =
                                        match.first['code']!;
                                    return _model.countryDropdownValue;
                                  }
                                  _model.countryDropdownValue = '';
                                  return null;
                                }(),
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
                                    return DropdownButtonFormField<String>(
                                      initialValue: () {
                                        final saved =
                                            _model.stateDropdownValue ??= widget
                                                    .paymentMethod
                                                    ?.billingDetails
                                                    ?.state ??
                                                '';
                                        if (saved.isEmpty) return null;
                                        final valid =
                                            GeoData.getStatesByCountry(
                                                _model.countryDropdownValue);
                                        if (valid.contains(saved)) {
                                          return saved;
                                        }
                                        _model.stateDropdownValue = '';
                                        return null;
                                      }(),
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
                                      decoration: _dropdownDecoration('State'),
                                      dropdownColor:
                                          AppColors.backgroundPrimary,
                                      icon: Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: AppColors.textSecondary,
                                        size: 24.0,
                                      ),
                                      style: appTextFieldStyle,
                                      isExpanded: true,
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
                            onPressed: () async {
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
                                      _model.cardNumberTextController!.text,
                                      _model.expireDateTextController!.text,
                                      _model.textFieldaCVCTextController!.text,
                                      _model.cardholderNameTextController!.text,
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
                                ref.read(authProvider.notifier).updateUser((e) {
                                  final methods = [...e.paymentMethod];
                                  final pm = methods[widget.index!];
                                  methods[widget.index!] = pm.copyWith(
                                    billingDetails: (pm.billingDetails ??
                                            const BillingDetails())
                                        .copyWith(
                                      name: _model.fullNameTextController!.text,
                                      email: _model
                                          .emailAddressTextController!.text,
                                      addressLine1: _model
                                          .addressLine1TextController!.text,
                                      addressLine2: _model
                                          .addressLine2TextController!.text,
                                      city: _model.cityTextController!.text,
                                      state: (_model.countryDropdownValue ==
                                                  'US') ||
                                              (_model.countryDropdownValue ==
                                                  'CA')
                                          ? _model.stateDropdownValue ?? ''
                                          : _model.stateTextController!.text,
                                      postalCode:
                                          _model.zipCodeTextController!.text,
                                      country:
                                          _model.countryDropdownValue ?? '',
                                    ),
                                  );
                                  return e.copyWith(paymentMethod: methods);
                                });
                                setState(() {});
                              } else {
                                await actions.toastificationshow(
                                  context,
                                  'Error!',
                                  (validationResult['message'] ?? '')
                                      .toString(),
                                  'error',
                                );
                              }
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
