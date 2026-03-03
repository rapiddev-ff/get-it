import '/features/auth/data/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/core/utils/geo_data.dart';
import 'dart:async';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '/core/theme/app_colors.dart';
import '/core/constants/app_constants.dart';
import '/core/utils/list_extensions.dart';
import '/features/auth/domain/models/business_address_model.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import 'settings_business_address_model.dart';
export 'settings_business_address_model.dart';

class SettingsBusinessAddressWidget extends ConsumerStatefulWidget {
  const SettingsBusinessAddressWidget({super.key});

  static String routeName = 'settingsBusinessAddress';
  static String routePath = 'settingsBusinessAddress';

  @override
  ConsumerState<SettingsBusinessAddressWidget> createState() =>
      _SettingsBusinessAddressWidgetState();
}

class _SettingsBusinessAddressWidgetState
    extends ConsumerState<SettingsBusinessAddressWidget> {
  late SettingsBusinessAddressModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  late StreamSubscription<bool> _keyboardVisibilitySubscription;
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    _model = SettingsBusinessAddressModel();

    if (!kIsWeb) {
      _keyboardVisibilitySubscription =
          KeyboardVisibilityController().onChange.listen((bool visible) {
        setState(() {
          _isKeyboardVisible = visible;
        });
      });
    }

    final userData = ref.read(authProvider);
    _model.addressLine1TextController ??= TextEditingController(
        text: userData.businessAddress?.addressLine1 ?? '');
    _model.addressLine1FocusNode ??= FocusNode();
    _model.addressLine1FocusNode!.addListener(() => setState(() {}));
    _model.addressLine2TextController ??= TextEditingController(
        text: userData.businessAddress?.addressLine2 ?? '');
    _model.addressLine2FocusNode ??= FocusNode();
    _model.addressLine2FocusNode!.addListener(() => setState(() {}));
    _model.stateTextController ??=
        TextEditingController(text: userData.businessAddress?.state ?? '');
    _model.stateFocusNode ??= FocusNode();
    _model.stateFocusNode!.addListener(() => setState(() {}));
    _model.cityTextController ??=
        TextEditingController(text: userData.businessAddress?.city ?? '');
    _model.cityFocusNode ??= FocusNode();
    _model.cityFocusNode!.addListener(() => setState(() {}));
    _model.zipCodeTextController ??=
        TextEditingController(text: userData.businessAddress?.zipCode ?? '');
    _model.zipCodeFocusNode ??= FocusNode();
    _model.zipCodeFocusNode!.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    if (!kIsWeb) {
      _keyboardVisibilitySubscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
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
            'Business Address',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 18.0,
              color: Colors.white,
            ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Business Address',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 18.0,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 20.0, 0.0, 0.0),
                          child: Text(
                            'Address',
                            style: GoogleFonts.inter(
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 8.0, 0.0, 0.0),
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
                              enabled: true,
                              autofillHints: [AutofillHints.streetAddressLine1],
                              obscureText: false,
                              decoration: InputDecoration(
                                isDense: false,
                                hintText: '123, Main street',
                                hintStyle: GoogleFonts.inter(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16.0,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.neutral700,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      AppConstants.radiusTextField4),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.secondary,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      AppConstants.radiusTextField4),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.error,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      AppConstants.radiusTextField4),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.error,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      AppConstants.radiusTextField4),
                                ),
                              ),
                              style: GoogleFonts.inter(
                                fontSize: 14.0,
                              ),
                              cursorColor: AppColors.textPrimary,
                              enableInteractiveSelection: true,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 20.0, 0.0, 0.0),
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
                              enabled: true,
                              autofillHints: [AutofillHints.streetAddressLine2],
                              obscureText: false,
                              decoration: InputDecoration(
                                isDense: false,
                                hintText: 'Apartment, suite, etc. (optional)',
                                hintStyle: GoogleFonts.inter(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16.0,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.neutral700,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      AppConstants.radiusTextField4),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.secondary,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      AppConstants.radiusTextField4),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.error,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      AppConstants.radiusTextField4),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.error,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      AppConstants.radiusTextField4),
                                ),
                              ),
                              style: GoogleFonts.inter(
                                fontSize: 14.0,
                              ),
                              cursorColor: AppColors.textPrimary,
                              enableInteractiveSelection: true,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 20.0, 0.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Country',
                                      style: GoogleFonts.inter(
                                        fontSize: 15.0,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 52.0,
                                      child: DropdownButtonFormField<String>(
                                        value: (_model.countryDropdownValue ??=
                                                    ref
                                                            .read(authProvider)
                                                            .businessAddress
                                                            ?.country ??
                                                        '')
                                                .isEmpty
                                            ? null
                                            : _model.countryDropdownValue,
                                        items: GeoData.getCountries()
                                            .map((c) => DropdownMenuItem(
                                                  value: c['code'],
                                                  child: Text(c['name']!,
                                                      style: GoogleFonts.inter(
                                                          fontSize: 14.0)),
                                                ))
                                            .toList(),
                                        onChanged: (val) => setState(() =>
                                            _model.countryDropdownValue = val),
                                        decoration: InputDecoration(
                                          isDense: true,
                                          hintText: 'Country',
                                          hintStyle: GoogleFonts.inter(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 14.0,
                                            color: AppColors.textSecondary,
                                          ),
                                          contentPadding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  12.0, 8.0, 12.0, 8.0),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: AppColors.neutral700,
                                                width: 1.0),
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: AppColors.neutral700,
                                                width: 1.0),
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                        ),
                                        dropdownColor:
                                            AppColors.backgroundPrimary,
                                        icon: Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: AppColors.textSecondary,
                                          size: 24.0,
                                        ),
                                        style:
                                            GoogleFonts.inter(fontSize: 14.0),
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
                                    Text(
                                      'State',
                                      style: GoogleFonts.inter(
                                        fontSize: 15.0,
                                      ),
                                    ),
                                    Builder(
                                      builder: (context) {
                                        if ((_model.countryDropdownValue ==
                                                'US') ||
                                            (_model.countryDropdownValue ==
                                                'CA')) {
                                          return SizedBox(
                                            height: 52.0,
                                            child:
                                                DropdownButtonFormField<String>(
                                              value: (_model
                                                          .stateDropdownValue ??= ref
                                                              .read(
                                                                  authProvider)
                                                              .businessAddress
                                                              ?.state ??
                                                          '')
                                                      .isEmpty
                                                  ? null
                                                  : _model.stateDropdownValue,
                                              items: GeoData.getStatesByCountry(
                                                      _model
                                                          .countryDropdownValue)
                                                  .map((name) =>
                                                      DropdownMenuItem(
                                                        value: name,
                                                        child: Text(name,
                                                            style: GoogleFonts
                                                                .inter(
                                                                    fontSize:
                                                                        14.0)),
                                                      ))
                                                  .toList(),
                                              onChanged: (val) => setState(() =>
                                                  _model.stateDropdownValue =
                                                      val),
                                              decoration: InputDecoration(
                                                isDense: true,
                                                hintText: 'State',
                                                hintStyle: GoogleFonts.inter(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 14.0,
                                                  color:
                                                      AppColors.textSecondary,
                                                ),
                                                contentPadding:
                                                    EdgeInsetsDirectional
                                                        .fromSTEB(12.0, 8.0,
                                                            12.0, 8.0),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color:
                                                          AppColors.neutral700,
                                                      width: 1.0),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.0),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color:
                                                          AppColors.neutral700,
                                                      width: 1.0),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.0),
                                                ),
                                              ),
                                              dropdownColor:
                                                  AppColors.backgroundPrimary,
                                              icon: Icon(
                                                Icons
                                                    .keyboard_arrow_down_rounded,
                                                color: AppColors.textSecondary,
                                                size: 24.0,
                                              ),
                                              style: GoogleFonts.inter(
                                                  fontSize: 14.0),
                                              isExpanded: true,
                                            ),
                                          );
                                        } else {
                                          return Container(
                                            width: double.infinity,
                                            child: TextFormField(
                                              controller:
                                                  _model.stateTextController,
                                              focusNode: _model.stateFocusNode,
                                              onChanged: (_) =>
                                                  EasyDebounce.debounce(
                                                '_model.stateTextController',
                                                Duration(milliseconds: 100),
                                                () => setState(() {}),
                                              ),
                                              autofocus: false,
                                              enabled: true,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                isDense: false,
                                                hintText: 'State',
                                                hintStyle: GoogleFonts.inter(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 16.0,
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: AppColors.neutral700,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius: BorderRadius
                                                      .circular(AppConstants
                                                          .radiusTextField4),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: AppColors.secondary,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius: BorderRadius
                                                      .circular(AppConstants
                                                          .radiusTextField4),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: AppColors.error,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius: BorderRadius
                                                      .circular(AppConstants
                                                          .radiusTextField4),
                                                ),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: AppColors.error,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius: BorderRadius
                                                      .circular(AppConstants
                                                          .radiusTextField4),
                                                ),
                                              ),
                                              style: GoogleFonts.inter(
                                                fontSize: 14.0,
                                              ),
                                              cursorColor:
                                                  AppColors.textPrimary,
                                              enableInteractiveSelection: true,
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
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 20.0, 0.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'City',
                                      style: GoogleFonts.inter(
                                        fontSize: 15.0,
                                      ),
                                    ),
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
                                        enabled: true,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          isDense: false,
                                          hintText: 'City',
                                          hintStyle: GoogleFonts.inter(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16.0,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: AppColors.neutral700,
                                              width: 1.0,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                AppConstants.radiusTextField4),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: AppColors.secondary,
                                              width: 1.0,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                AppConstants.radiusTextField4),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: AppColors.error,
                                              width: 1.0,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                AppConstants.radiusTextField4),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: AppColors.error,
                                              width: 1.0,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                AppConstants.radiusTextField4),
                                          ),
                                        ),
                                        style: GoogleFonts.inter(
                                          fontSize: 14.0,
                                        ),
                                        cursorColor: AppColors.textPrimary,
                                        enableInteractiveSelection: true,
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
                                    Text(
                                      'Zip Code',
                                      style: GoogleFonts.inter(
                                        fontSize: 15.0,
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      child: TextFormField(
                                        controller:
                                            _model.zipCodeTextController,
                                        focusNode: _model.zipCodeFocusNode,
                                        onChanged: (_) => EasyDebounce.debounce(
                                          '_model.zipCodeTextController',
                                          Duration(milliseconds: 100),
                                          () => setState(() {}),
                                        ),
                                        autofocus: false,
                                        enabled: true,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          isDense: false,
                                          hintText: '10001',
                                          hintStyle: GoogleFonts.inter(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16.0,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: AppColors.neutral700,
                                              width: 1.0,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                AppConstants.radiusTextField4),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: AppColors.secondary,
                                              width: 1.0,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                AppConstants.radiusTextField4),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: AppColors.error,
                                              width: 1.0,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                AppConstants.radiusTextField4),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: AppColors.error,
                                              width: 1.0,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                AppConstants.radiusTextField4),
                                          ),
                                        ),
                                        style: GoogleFonts.inter(
                                          fontSize: 14.0,
                                        ),
                                        keyboardType: TextInputType.number,
                                        cursorColor: AppColors.textPrimary,
                                        enableInteractiveSelection: true,
                                      ),
                                    ),
                                  ].divide(SizedBox(height: 8.0)),
                                ),
                              ),
                            ].divide(SizedBox(width: 12.0)),
                          ),
                        ),
                      ]
                          .addToStart(SizedBox(height: 24.0))
                          .addToEnd(SizedBox(height: 32.0)),
                    ),
                  ),
                ),
                if (!(kIsWeb
                    ? MediaQuery.viewInsetsOf(context).bottom > 0
                    : _isKeyboardVisible))
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 36.0, 0.0, 32.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              context.pop();
                            },
                            style: OutlinedButton.styleFrom(
                              minimumSize: Size(double.infinity, 56.0),
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              backgroundColor: AppColors.backgroundPrimary,
                              side: BorderSide(
                                color: Color(0xFF545454),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 17.0,
                                color: Colors.white,
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
                                begin: AlignmentDirectional(0.0, -1.0),
                                end: AlignmentDirectional(0, 1.0),
                              ),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: TextButton(
                              onPressed: () async {
                                await Future.wait([
                                  Future(() async {
                                    await UserProfilesTable().update(
                                      data: {
                                        'business_address_line1': _model
                                            .addressLine1TextController!.text,
                                        'business_address_line2': _model
                                            .addressLine2TextController!.text,
                                        'business_country':
                                            _model.countryDropdownValue,
                                        'business_state': (_model
                                                        .countryDropdownValue ==
                                                    'US') ||
                                                (_model.countryDropdownValue ==
                                                    'CA')
                                            ? _model.stateDropdownValue
                                            : _model.stateTextController!.text,
                                        'business_city':
                                            _model.cityTextController!.text,
                                        'business_zip':
                                            _model.zipCodeTextController!.text,
                                      },
                                      matchingRows: (rows) => rows.eqOrNull(
                                        'user_id',
                                        currentUserUid,
                                      ),
                                    );
                                  }),
                                  Future(() async {
                                    ref.read(authProvider.notifier).updateUser(
                                          (e) => e.copyWith(
                                            businessAddress:
                                                (e.businessAddress ??
                                                        const BusinessAddress())
                                                    .copyWith(
                                              addressLine1: _model
                                                  .addressLine1TextController!
                                                  .text,
                                              addressLine2: _model
                                                  .addressLine2TextController!
                                                  .text,
                                              country:
                                                  _model.countryDropdownValue ??
                                                      '',
                                              state: (_model.countryDropdownValue ==
                                                          'US') ||
                                                      (_model.countryDropdownValue ==
                                                          'CA')
                                                  ? _model.stateDropdownValue ??
                                                      ''
                                                  : _model.stateTextController!
                                                      .text,
                                              city: _model
                                                  .cityTextController!.text,
                                              zipCode: _model
                                                  .zipCodeTextController!.text,
                                            ),
                                          ),
                                        );
                                    setState(() {});
                                  }),
                                ]);
                                context.pop();
                              },
                              style: TextButton.styleFrom(
                                minimumSize: Size(double.infinity, 56.0),
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                              ),
                              child: Text(
                                'Save',
                                style: GoogleFonts.inter(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ].divide(SizedBox(width: 20.0)),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
