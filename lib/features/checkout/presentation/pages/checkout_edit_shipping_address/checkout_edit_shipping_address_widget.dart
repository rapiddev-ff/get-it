import '/app_state.dart';
import '/features/auth/data/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/core/constants/app_constants.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/geo_data.dart';
import '/core/utils/list_extensions.dart';
import '/flutter_flow/flutter_flow_autocomplete_options_list.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckoutEditShippingAddressWidget extends StatefulWidget {
  const CheckoutEditShippingAddressWidget({super.key});

  static String routeName = 'checkoutEditShippingAddress';
  static String routePath = 'checkoutEditShippingAddress';

  @override
  State<CheckoutEditShippingAddressWidget> createState() =>
      _CheckoutEditShippingAddressWidgetState();
}

class _CheckoutEditShippingAddressWidgetState
    extends State<CheckoutEditShippingAddressWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool streetaddressFocusListenerRegistered = false;

  // Inlined model state
  List<String> autocompletePredictionName = [];
  List<String> autocompletePredictionPlace = [];
  String? choosenPlaceId;
  FocusNode? fullNameFocusNode;
  TextEditingController? fullNameTextController;
  final streetaddressKey = GlobalKey();
  FocusNode? streetaddressFocusNode;
  TextEditingController? streetaddressTextController;
  String? streetaddressSelectedOption;
  ApiCallResponse? apiResultlkc;
  ApiCallResponse? getPlace;
  FocusNode? aptsuiteunitFocusNode;
  TextEditingController? aptsuiteunitTextController;
  FocusNode? cityFocusNode;
  TextEditingController? cityTextController;
  String? countryDropdownValue;
  FormFieldController<String>? countryDropdownValueController;
  String? stateDropdownValue;
  FormFieldController<String>? stateDropdownValueController;
  FocusNode? stateFocusNode;
  TextEditingController? stateTextController;
  FocusNode? zipCodeFocusNode;
  TextEditingController? zipCodeTextController;
  ShippingAddressesRow? createShippingAddress;

  // Inline: getIndexByVal
  static int? _getIndexByVal(String val, List<String> valList) {
    final index = valList.indexOf(val);
    return index != -1 ? index : null;
  }

  // Inline: parseAddressComponents
  static Map<String, String> _parseAddressComponents(dynamic addressResponse) {
    final components =
        (addressResponse is Map ? addressResponse['addressComponents'] : null)
                as List? ??
            [];
    String streetNumber = '';
    String route = '';
    String city = '';
    String state = '';
    String zip = '';
    String country = '';
    for (final c in components) {
      final types = ((c['types'] as List?)?.cast<String>()) ?? [];
      final longText = (c['longText'] ?? '').toString();
      final shortText = (c['shortText'] ?? '').toString();
      if (types.contains('street_number')) streetNumber = longText;
      if (types.contains('route')) route = longText;
      if (types.contains('locality') ||
          types.contains('sublocality') ||
          types.contains('sublocality_level_1')) city = longText;
      if (types.contains('administrative_area_level_1')) state = longText;
      if (types.contains('postal_code')) zip = longText;
      if (types.contains('country')) country = shortText;
    }
    return {
      'street': '$streetNumber $route'.trim(),
      'city': city,
      'state': state,
      'zip': zip,
      'country': country,
    };
  }

  @override
  void initState() {
    super.initState();

    // TODO: replace FFAppState() with proper state provider
    fullNameTextController ??= TextEditingController(
        text:
            '${FFAppState().userData.firstName} ${FFAppState().userData.lastName}');
    fullNameFocusNode ??= FocusNode();
    fullNameFocusNode!.addListener(() => setState(() {}));
    streetaddressTextController ??= TextEditingController();

    aptsuiteunitTextController ??= TextEditingController();
    aptsuiteunitFocusNode ??= FocusNode();
    aptsuiteunitFocusNode!.addListener(() => setState(() {}));
    cityTextController ??= TextEditingController();
    cityFocusNode ??= FocusNode();
    cityFocusNode!.addListener(() => setState(() {}));
    stateTextController ??= TextEditingController();
    stateFocusNode ??= FocusNode();
    stateFocusNode!.addListener(() => setState(() {}));
    zipCodeTextController ??= TextEditingController();
    zipCodeFocusNode ??= FocusNode();
    zipCodeFocusNode!.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    fullNameFocusNode?.dispose();
    fullNameTextController?.dispose();
    aptsuiteunitFocusNode?.dispose();
    aptsuiteunitTextController?.dispose();
    cityFocusNode?.dispose();
    cityTextController?.dispose();
    stateFocusNode?.dispose();
    stateTextController?.dispose();
    zipCodeFocusNode?.dispose();
    zipCodeTextController?.dispose();
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
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56.0),
          child: AppBar(
            backgroundColor: AppColors.backgroundSecondary,
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  style: IconButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  iconSize: 40.0,
                  icon: Icon(
                    Icons.arrow_back,
                    color: AppColors.info,
                    size: 24.0,
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                ),
                Text(
                  'Edit Shipping Address',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                    color: AppColors.textPrimary,
                  ),
                ),
                Opacity(
                  opacity: 0.0,
                  child: IconButton(
                    style: IconButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    iconSize: 40.0,
                    icon: Icon(
                      Icons.notifications_none,
                      color: AppColors.info,
                      size: 20.0,
                    ),
                    onPressed: true
                        ? null
                        : () {
                            print('IconButton pressed ...');
                          },
                  ),
                ),
              ],
            ),
            actions: [],
            centerTitle: true,
            elevation: 0.0,
          ),
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Full Name',
                            style: GoogleFonts.inter(
                              fontSize: 15.0,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 8.0, 0.0, 0.0),
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
                                enabled: true,
                                obscureText: false,
                                decoration: InputDecoration(
                                  isDense: false,
                                  hintText: 'Enter Full Name',
                                  hintStyle: GoogleFonts.inter(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16.0,
                                    color: AppColors.textSecondary,
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
                                  color: AppColors.textPrimary,
                                ),
                                cursorColor: AppColors.textPrimary,
                                enableInteractiveSelection: true,
                                validator: null,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 20.0, 0.0, 0.0),
                            child: Text(
                              'Street address',
                              style: GoogleFonts.inter(
                                fontSize: 15.0,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 8.0, 0.0, 0.0),
                            child: Container(
                              width: double.infinity,
                              child: Autocomplete<String>(
                                initialValue: TextEditingValue(),
                                optionsBuilder: (textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<String>.empty();
                                  }
                                  return autocompletePredictionName
                                      .where((option) {
                                    final lowercaseOption =
                                        option.toLowerCase();
                                    return lowercaseOption.contains(
                                        textEditingValue.text.toLowerCase());
                                  });
                                },
                                optionsViewBuilder:
                                    (context, onSelected, options) {
                                  return AutocompleteOptionsList(
                                    textFieldKey: streetaddressKey,
                                    textController:
                                        streetaddressTextController!,
                                    options: options.toList(),
                                    onSelected: onSelected,
                                    textStyle: TextStyle(),
                                    textHighlightStyle: TextStyle(),
                                    elevation: 4.0,
                                    optionBackgroundColor:
                                        AppColors.backgroundPrimary,
                                    optionHighlightColor:
                                        AppColors.backgroundSecondary,
                                    maxHeight: 200.0,
                                  );
                                },
                                onSelected: (String selection) {
                                  setState(() =>
                                      streetaddressSelectedOption = selection);
                                  FocusScope.of(context).unfocus();
                                },
                                fieldViewBuilder: (
                                  context,
                                  textEditingController,
                                  focusNode,
                                  onEditingComplete,
                                ) {
                                  streetaddressFocusNode = focusNode;
                                  if (!streetaddressFocusListenerRegistered) {
                                    streetaddressFocusListenerRegistered = true;
                                    streetaddressFocusNode!.addListener(
                                      () async {
                                        if (streetaddressSelectedOption !=
                                                null &&
                                            streetaddressSelectedOption !=
                                                '') {
                                          choosenPlaceId =
                                              autocompletePredictionPlace
                                                  .elementAtOrNull(
                                                      _getIndexByVal(
                                                          streetaddressSelectedOption!,
                                                          autocompletePredictionName
                                                              .toList())!);
                                          setState(() {});
                                          getPlace =
                                              await GooglePlacesGroup
                                                  .getPlaceCall
                                                  .call(
                                            placeId: choosenPlaceId,
                                          );

                                          if ((getPlace?.succeeded ??
                                              true)) {
                                            final parsed =
                                                _parseAddressComponents(
                                                    getPlace?.jsonBody ?? {});
                                            await Future.wait([
                                              Future(() async {
                                                setState(() {
                                                  cityTextController?.text =
                                                      parsed['city'] ?? '';
                                                });
                                              }),
                                              Future(() async {
                                                setState(() {
                                                  countryDropdownValueController
                                                          ?.value =
                                                      parsed['country'] ?? '';
                                                  countryDropdownValue =
                                                      parsed['country'] ?? '';
                                                });
                                              }),
                                              Future(() async {
                                                setState(() {
                                                  zipCodeTextController?.text =
                                                      parsed['zip'] ?? '';
                                                });
                                              }),
                                              Future(() async {
                                                setState(() {
                                                  stateTextController?.text =
                                                      parsed['state'] ?? '';
                                                });
                                              }),
                                              Future(() async {
                                                setState(() {
                                                  stateDropdownValueController
                                                          ?.value =
                                                      parsed['state'] ?? '';
                                                  stateDropdownValue =
                                                      parsed['state'] ?? '';
                                                });
                                              }),
                                              Future(() async {
                                                setState(() {
                                                  streetaddressTextController
                                                          ?.text =
                                                      parsed['street'] ?? '';
                                                });
                                              }),
                                            ]);
                                          }
                                        }

                                        setState(() {});
                                      },
                                    );
                                  }
                                  streetaddressTextController =
                                      textEditingController;
                                  return TextFormField(
                                    key: streetaddressKey,
                                    controller: textEditingController,
                                    focusNode: focusNode,
                                    onEditingComplete: onEditingComplete,
                                    onChanged: (_) => EasyDebounce.debounce(
                                      'streetaddressTextController',
                                      Duration(milliseconds: 100),
                                      () async {
                                        if ((streetaddressTextController!
                                                .text.length) >=
                                            3) {
                                          apiResultlkc =
                                              await GooglePlacesGroup
                                                  .autocompleteCall
                                                  .call(
                                            searchingString:
                                                streetaddressTextController!
                                                    .text,
                                          );

                                          if ((apiResultlkc?.succeeded ??
                                              true)) {
                                            autocompletePredictionName =
                                                GooglePlacesGroup
                                                    .autocompleteCall
                                                    .predictionPlaceText(
                                                      (apiResultlkc
                                                              ?.jsonBody ??
                                                          ''),
                                                    )!
                                                    .toList()
                                                    .cast<String>();
                                            autocompletePredictionPlace =
                                                (GooglePlacesGroup
                                                        .autocompleteCall
                                                        .autocompletePredictions(
                                              (apiResultlkc?.jsonBody ??
                                                  ''),
                                            ) as List?)!
                                                    .map<String>(
                                                        (e) => e.toString())
                                                    .toList()
                                                    .cast<String>()
                                                    .toList()
                                                    .cast<String>();
                                            setState(() {});
                                          }
                                        }

                                        setState(() {});
                                      },
                                    ),
                                    autofocus: false,
                                    enabled: true,
                                    textInputAction: TextInputAction.done,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      isDense: false,
                                      hintText: 'Enter street address',
                                      hintStyle: GoogleFonts.inter(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16.0,
                                        color: AppColors.textSecondary,
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
                                      color: AppColors.textPrimary,
                                    ),
                                    cursorColor: AppColors.textPrimary,
                                    enableInteractiveSelection: true,
                                    validator: null,
                                  );
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 20.0, 0.0, 0.0),
                            child: Text(
                              'Apt, suite, unit',
                              style: GoogleFonts.inter(
                                fontSize: 15.0,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 8.0, 0.0, 0.0),
                            child: Container(
                              width: double.infinity,
                              child: TextFormField(
                                controller: aptsuiteunitTextController,
                                focusNode: aptsuiteunitFocusNode,
                                onChanged: (_) => EasyDebounce.debounce(
                                  'aptsuiteunitTextController',
                                  Duration(milliseconds: 100),
                                  () => setState(() {}),
                                ),
                                autofocus: false,
                                enabled: true,
                                obscureText: false,
                                decoration: InputDecoration(
                                  isDense: false,
                                  hintText: 'Enter apt, suite, unit',
                                  hintStyle: GoogleFonts.inter(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16.0,
                                    color: AppColors.textSecondary,
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
                                  color: AppColors.textPrimary,
                                ),
                                cursorColor: AppColors.textPrimary,
                                enableInteractiveSelection: true,
                                validator: null,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 20.0, 0.0, 0.0),
                            child: Text(
                              'City',
                              style: GoogleFonts.inter(
                                fontSize: 15.0,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 8.0, 0.0, 0.0),
                            child: Container(
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
                                enabled: true,
                                obscureText: false,
                                decoration: InputDecoration(
                                  isDense: false,
                                  hintText: 'Enter city',
                                  hintStyle: GoogleFonts.inter(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16.0,
                                    color: AppColors.textSecondary,
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
                                  color: AppColors.textPrimary,
                                ),
                                cursorColor: AppColors.textPrimary,
                                enableInteractiveSelection: true,
                                validator: null,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 20.0, 0.0, 0.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Country',
                                  style: GoogleFonts.inter(
                                    fontSize: 15.0,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                FlutterFlowDropDown<String>(
                                  controller:
                                      countryDropdownValueController ??=
                                          FormFieldController<String>(
                                    countryDropdownValue ??= '',
                                  ),
                                  options: List<String>.from(GeoData
                                      .getCountries()
                                      .map((e) => e['code'] ?? '')
                                      .toList()),
                                  optionLabels: GeoData
                                      .getCountries()
                                      .map((e) => e['name'] ?? '')
                                      .toList(),
                                  onChanged: (val) => setState(
                                      () => countryDropdownValue = val),
                                  width: double.infinity,
                                  height: 52.0,
                                  textStyle: GoogleFonts.inter(
                                    color: AppColors.textPrimary,
                                  ),
                                  hintText: 'Country',
                                  icon: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: AppColors.textSecondary,
                                    size: 24.0,
                                  ),
                                  fillColor: AppColors.backgroundPrimary,
                                  elevation: 2.0,
                                  borderColor: AppColors.neutral700,
                                  borderWidth: 1.0,
                                  borderRadius: 4.0,
                                  margin: EdgeInsetsDirectional.fromSTEB(
                                      12.0, 0.0, 12.0, 0.0),
                                  hidesUnderline: true,
                                  isOverButton: true,
                                  isSearchable: false,
                                  isMultiSelect: false,
                                ),
                              ].divide(SizedBox(height: 8.0)),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'State',
                                        style: GoogleFonts.inter(
                                          fontSize: 15.0,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      Builder(
                                        builder: (context) {
                                          if ((countryDropdownValue ==
                                                  'US') ||
                                              (countryDropdownValue ==
                                                  'CA')) {
                                            return FlutterFlowDropDown<String>(
                                              controller:
                                                  stateDropdownValueController ??=
                                                      FormFieldController<
                                                          String>(
                                                stateDropdownValue ??= '',
                                              ),
                                              options: List<String>.from(
                                                  GeoData.getStatesByCountry(
                                                          countryDropdownValue)
                                                      .toList()),
                                              optionLabels: GeoData
                                                  .getStatesByCountry(
                                                      countryDropdownValue)
                                                  .toList(),
                                              onChanged: (val) => setState(
                                                  () => stateDropdownValue =
                                                      val),
                                              width: double.infinity,
                                              height: 52.0,
                                              textStyle: GoogleFonts.inter(
                                                color: AppColors.textPrimary,
                                              ),
                                              hintText: 'State',
                                              icon: Icon(
                                                Icons
                                                    .keyboard_arrow_down_rounded,
                                                color: AppColors.textSecondary,
                                                size: 24.0,
                                              ),
                                              fillColor:
                                                  AppColors.backgroundPrimary,
                                              elevation: 2.0,
                                              borderColor:
                                                  AppColors.neutral700,
                                              borderWidth: 1.0,
                                              borderRadius: 4.0,
                                              margin: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      12.0, 0.0, 12.0, 0.0),
                                              hidesUnderline: true,
                                              isOverButton: true,
                                              isSearchable: false,
                                              isMultiSelect: false,
                                            );
                                          } else {
                                            return Container(
                                              width: double.infinity,
                                              child: TextFormField(
                                                controller:
                                                    stateTextController,
                                                focusNode: stateFocusNode,
                                                onChanged: (_) =>
                                                    EasyDebounce.debounce(
                                                  'stateTextController',
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
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 16.0,
                                                    color:
                                                        AppColors.textSecondary,
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          AppColors.neutral700,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            AppConstants
                                                                .radiusTextField4),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          AppColors.secondary,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            AppConstants
                                                                .radiusTextField4),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: AppColors.error,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            AppConstants
                                                                .radiusTextField4),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: AppColors.error,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            AppConstants
                                                                .radiusTextField4),
                                                  ),
                                                ),
                                                style: GoogleFonts.inter(
                                                  color: AppColors.textPrimary,
                                                ),
                                                cursorColor:
                                                    AppColors.textPrimary,
                                                enableInteractiveSelection:
                                                    true,
                                                validator: null,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ].divide(SizedBox(height: 8.0)),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Zip Code',
                                        style: GoogleFonts.inter(
                                          fontSize: 15.0,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        child: TextFormField(
                                          controller: zipCodeTextController,
                                          focusNode: zipCodeFocusNode,
                                          onChanged: (_) =>
                                              EasyDebounce.debounce(
                                            'zipCodeTextController',
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
                                              color: AppColors.textSecondary,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: AppColors.neutral700,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      AppConstants
                                                          .radiusTextField4),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: AppColors.secondary,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      AppConstants
                                                          .radiusTextField4),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: AppColors.error,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      AppConstants
                                                          .radiusTextField4),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: AppColors.error,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      AppConstants
                                                          .radiusTextField4),
                                            ),
                                          ),
                                          style: GoogleFonts.inter(
                                            color: AppColors.textPrimary,
                                          ),
                                          keyboardType: TextInputType.number,
                                          cursorColor: AppColors.textPrimary,
                                          enableInteractiveSelection: true,
                                          validator: null,
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
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
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
                            createShippingAddress =
                                await ShippingAddressesTable().insert({
                              'user_id': currentUserUid,
                              'full_name': fullNameTextController!.text,
                              'address_line1':
                                  streetaddressTextController!.text,
                              'address_line2':
                                  aptsuiteunitTextController!.text,
                              'city': cityTextController!.text,
                              'country': countryDropdownValue,
                              'state': (countryDropdownValue == 'US') ||
                                      (countryDropdownValue == 'CA')
                                  ? stateDropdownValue
                                  : stateTextController!.text,
                              'zip_code': zipCodeTextController!.text,
                              'is_default': true,
                              'created_at': DateTime.now().toIso8601String(),
                            });
                          }),
                          Future(() async {
                            // TODO: replace FFAppState() with proper state provider
                            FFAppState().updateUserDataStruct(
                              (e) => e
                                ..updateShippingAddress(
                                  (e) => e
                                    ..fullName =
                                        fullNameTextController!.text
                                    ..addressLine1 =
                                        streetaddressTextController!.text
                                    ..addressLine2 =
                                        aptsuiteunitTextController!.text
                                    ..city = cityTextController!.text
                                    ..state =
                                        (countryDropdownValue == 'US') ||
                                                (countryDropdownValue ==
                                                    'CA')
                                            ? stateDropdownValue
                                            : stateTextController!.text
                                    ..country = countryDropdownValue
                                    ..zipCode =
                                        zipCodeTextController!.text,
                                ),
                            );
                            setState(() {});
                          }),
                        ]);
                        Navigator.pop(context);

                        setState(() {});
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 0.0, 16.0, 0.0),
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        'Save Changes',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                  child: TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      minimumSize: Size(double.infinity, 56.0),
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      backgroundColor: AppColors.backgroundPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        side: BorderSide(
                          color: Color(0xFF545454),
                        ),
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
              ].addToEnd(SizedBox(height: 32.0)),
            ),
          ),
        ),
      ),
    );
  }
}
