import '/backend/supabase/supabase.dart';
import '/core/utils/geo_data.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import '/core/providers/current_user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/keyboard_visibility_mixin.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/app_text_field.dart';
import '/core/widgets/app_gradient_button.dart';
import '/core/widgets/dismiss_keyboard.dart';
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
    extends ConsumerState<SettingsBusinessAddressWidget>
    with KeyboardVisibilityMixin {
  late SettingsBusinessAddressModel _model;

  @override
  void initState() {
    super.initState();
    _model = SettingsBusinessAddressModel();

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
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
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
                          padding: EdgeInsets.only(top: 20.0),
                          child: Text(
                            'Address',
                            style: GoogleFonts.inter(
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Container(
                            width: double.infinity,
                            child: AppTextField(
                              controller: _model.addressLine1TextController,
                              focusNode: _model.addressLine1FocusNode,
                              hintText: '123, Main street',
                              onChanged: (_) => EasyDebounce.debounce(
                                '_model.addressLine1TextController',
                                Duration(milliseconds: 100),
                                () => setState(() {}),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Container(
                            width: double.infinity,
                            child: AppTextField(
                              controller: _model.addressLine2TextController,
                              focusNode: _model.addressLine2FocusNode,
                              hintText: 'Apartment, suite, etc. (optional)',
                              onChanged: (_) => EasyDebounce.debounce(
                                '_model.addressLine2TextController',
                                Duration(milliseconds: 100),
                                () => setState(() {}),
                              ),
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
                                    Text(
                                      'Country',
                                      style: GoogleFonts.inter(
                                        fontSize: 15.0,
                                      ),
                                    ),
                                    DropdownButtonFormField<String>(
                                      initialValue: () {
                                        final saved =
                                            _model.countryDropdownValue ??= ref
                                                    .read(authProvider)
                                                    .businessAddress
                                                    ?.country ??
                                                '';
                                        if (saved.isEmpty) return null;
                                        final codes = GeoData.getCountries()
                                            .map((c) => c['code']!)
                                            .toSet();
                                        if (codes.contains(saved)) {
                                          return saved;
                                        }
                                        // Legacy full name → resolve to code
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
                                                    style: GoogleFonts.inter(
                                                        fontSize: 14.0)),
                                              ))
                                          .toList(),
                                      onChanged: (val) => setState(() =>
                                          _model.countryDropdownValue = val),
                                      decoration: InputDecoration(
                                        isDense: true,
                                        hintText: 'Country',
                                        hintStyle: Theme.of(context)
                                            .textTheme
                                            .labelMedium!,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 12.0, vertical: 16.0),
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
                                      style: GoogleFonts.inter(fontSize: 14.0),
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
                                          return DropdownButtonFormField<
                                              String>(
                                            initialValue: () {
                                              final saved = _model
                                                  .stateDropdownValue ??= ref
                                                      .read(authProvider)
                                                      .businessAddress
                                                      ?.state ??
                                                  '';
                                              if (saved.isEmpty) return null;
                                              final valid = GeoData
                                                  .getStatesByCountry(_model
                                                      .countryDropdownValue);
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
                                                          style:
                                                              GoogleFonts.inter(
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
                                              hintStyle: Theme.of(context)
                                                  .textTheme
                                                  .labelMedium!,
                                              contentPadding:
                                                  EdgeInsetsDirectional
                                                      .fromSTEB(12.0, 16.0,
                                                          12.0, 16.0),
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
                                            style: GoogleFonts.inter(
                                                fontSize: 14.0),
                                            isExpanded: true,
                                          );
                                        } else {
                                          return Container(
                                            width: double.infinity,
                                            child: AppTextField(
                                              controller:
                                                  _model.stateTextController,
                                              focusNode: _model.stateFocusNode,
                                              hintText: 'State',
                                              onChanged: (_) =>
                                                  EasyDebounce.debounce(
                                                '_model.stateTextController',
                                                Duration(milliseconds: 100),
                                                () => setState(() {}),
                                              ),
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
                                    Text(
                                      'City',
                                      style: GoogleFonts.inter(
                                        fontSize: 15.0,
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      child: AppTextField(
                                        controller: _model.cityTextController,
                                        focusNode: _model.cityFocusNode,
                                        hintText: 'City',
                                        onChanged: (_) => EasyDebounce.debounce(
                                          '_model.cityTextController',
                                          Duration(milliseconds: 100),
                                          () => setState(() {}),
                                        ),
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
                                      child: AppTextField(
                                        controller:
                                            _model.zipCodeTextController,
                                        focusNode: _model.zipCodeFocusNode,
                                        hintText: '10001',
                                        keyboardType: TextInputType.number,
                                        onChanged: (_) => EasyDebounce.debounce(
                                          '_model.zipCodeTextController',
                                          Duration(milliseconds: 100),
                                          () => setState(() {}),
                                        ),
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
                if (!isKeyboardShowing(context))
                  Padding(
                    padding: EdgeInsets.only(top: 36.0, bottom: 32.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: AppOutlineButton(
                            text: 'Cancel',
                            onPressed: () async {
                              context.pop();
                            },
                          ),
                        ),
                        Expanded(
                          child: AppGradientButton(
                            text: 'Save',
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
                                      ref.read(currentUserIdProvider),
                                    ),
                                  );
                                }),
                                Future(() async {
                                  ref.read(authProvider.notifier).updateUser(
                                        (e) => e.copyWith(
                                          businessAddress: (e.businessAddress ??
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
                                                : _model
                                                    .stateTextController!.text,
                                            city:
                                                _model.cityTextController!.text,
                                            zipCode: _model
                                                .zipCodeTextController!.text,
                                          ),
                                        ),
                                      );
                                  if (mounted) setState(() {});
                                }),
                              ]);
                              if (!mounted) return;
                              context.pop();
                            },
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
