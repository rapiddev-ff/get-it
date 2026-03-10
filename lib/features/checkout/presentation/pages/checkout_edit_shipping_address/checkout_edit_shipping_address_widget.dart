import '/features/checkout/domain/models/shipping_address_model.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/geo_data.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/app_text_field.dart';
import '/core/widgets/app_gradient_button.dart';
import '/core/widgets/autocomplete_options_list.dart';
import '/core/widgets/app_drop_down.dart';
import '/core/widgets/form_field_controller.dart';
import '/core/widgets/dismiss_keyboard.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import '/core/providers/current_user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckoutEditShippingAddressWidget extends ConsumerStatefulWidget {
  const CheckoutEditShippingAddressWidget({super.key});

  static String routeName = 'checkoutEditShippingAddress';
  static String routePath = 'checkoutEditShippingAddress';

  @override
  ConsumerState<CheckoutEditShippingAddressWidget> createState() =>
      _CheckoutEditShippingAddressWidgetState();
}

class _CheckoutEditShippingAddressWidgetState
    extends ConsumerState<CheckoutEditShippingAddressWidget> {
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
    final components = (addressResponse is Map
            ? addressResponse['addressComponents']
            : null) as List? ??
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

    fullNameTextController ??= TextEditingController(
        text:
            '${ref.read(authProvider).firstName} ${ref.read(authProvider).lastName}');
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
    return DismissKeyboard(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56.0),
          child: AppBar(
            backgroundColor: AppColors.backgroundSecondary,
            automaticallyImplyLeading: false,
            title: Row(
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
                    onPressed: null,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
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
                            padding: EdgeInsets.only(top: 8.0),
                            child: Container(
                              width: double.infinity,
                              child: AppTextField(
                                controller: fullNameTextController,
                                focusNode: fullNameFocusNode,
                                hintText: 'Enter Full Name',
                                onChanged: (_) => EasyDebounce.debounce(
                                  'fullNameTextController',
                                  Duration(milliseconds: 100),
                                  () => setState(() {}),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Text(
                              'Street address',
                              style: GoogleFonts.inter(
                                fontSize: 15.0,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8.0),
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
                                            streetaddressSelectedOption != '') {
                                          choosenPlaceId =
                                              autocompletePredictionPlace
                                                  .elementAtOrNull(_getIndexByVal(
                                                      streetaddressSelectedOption!,
                                                      autocompletePredictionName
                                                          .toList())!);
                                          setState(() {});
                                          getPlace = await GooglePlacesGroup
                                              .getPlaceCall
                                              .call(
                                            placeId: choosenPlaceId,
                                          );

                                          if ((getPlace?.succeeded ?? true)) {
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
                                          apiResultlkc = await GooglePlacesGroup
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
                                                      (apiResultlkc?.jsonBody ??
                                                          ''),
                                                    )!
                                                    .toList()
                                                    .cast<String>();
                                            autocompletePredictionPlace =
                                                (GooglePlacesGroup
                                                        .autocompleteCall
                                                        .autocompletePredictions(
                                              (apiResultlkc?.jsonBody ?? ''),
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
                                    decoration: appInputDecoration(
                                        'Enter street address'),
                                    style: appTextFieldStyle,
                                    cursorColor: AppColors.textPrimary,
                                    enableInteractiveSelection: true,
                                    validator: null,
                                  );
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Text(
                              'Apt, suite, unit',
                              style: GoogleFonts.inter(
                                fontSize: 15.0,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Container(
                              width: double.infinity,
                              child: AppTextField(
                                controller: aptsuiteunitTextController,
                                focusNode: aptsuiteunitFocusNode,
                                hintText: 'Enter apt, suite, unit',
                                onChanged: (_) => EasyDebounce.debounce(
                                  'aptsuiteunitTextController',
                                  Duration(milliseconds: 100),
                                  () => setState(() {}),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Text(
                              'City',
                              style: GoogleFonts.inter(
                                fontSize: 15.0,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Container(
                              width: double.infinity,
                              child: AppTextField(
                                controller: cityTextController,
                                focusNode: cityFocusNode,
                                hintText: 'Enter city',
                                onChanged: (_) => EasyDebounce.debounce(
                                  'cityTextController',
                                  Duration(milliseconds: 100),
                                  () => setState(() {}),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Country',
                                  style: GoogleFonts.inter(
                                    fontSize: 15.0,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                AppDropDown<String>(
                                  controller: countryDropdownValueController ??=
                                      FormFieldController<String>(
                                    countryDropdownValue ??= '',
                                  ),
                                  options: List<String>.from(
                                      GeoData.getCountries()
                                          .map((e) => e['code'] ?? '')
                                          .toList()),
                                  optionLabels: GeoData.getCountries()
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
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 12.0),
                                  hidesUnderline: true,
                                  isOverButton: true,
                                  isSearchable: false,
                                  isMultiSelect: false,
                                ),
                              ].divide(SizedBox(height: 8.0)),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Row(
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
                                          if ((countryDropdownValue == 'US') ||
                                              (countryDropdownValue == 'CA')) {
                                            return AppDropDown<String>(
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
                                              optionLabels:
                                                  GeoData.getStatesByCountry(
                                                          countryDropdownValue)
                                                      .toList(),
                                              onChanged: (val) => setState(() =>
                                                  stateDropdownValue = val),
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
                                              borderColor: AppColors.neutral700,
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
                                              child: AppTextField(
                                                controller: stateTextController,
                                                focusNode: stateFocusNode,
                                                hintText: 'State',
                                                onChanged: (_) =>
                                                    EasyDebounce.debounce(
                                                  'stateTextController',
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
                                        child: AppTextField(
                                          controller: zipCodeTextController,
                                          focusNode: zipCodeFocusNode,
                                          hintText: '10001',
                                          keyboardType: TextInputType.number,
                                          onChanged: (_) =>
                                              EasyDebounce.debounce(
                                            'zipCodeTextController',
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
                ),
                Padding(
                  padding: EdgeInsets.only(top: 24.0),
                  child: AppGradientButton(
                    text: 'Save Changes',
                    onPressed: () async {
                      await Future.wait([
                        Future(() async {
                          createShippingAddress =
                              await ShippingAddressesTable().insert({
                            'user_id': ref.read(currentUserIdProvider),
                            'full_name': fullNameTextController!.text,
                            'address_line1': streetaddressTextController!.text,
                            'address_line2': aptsuiteunitTextController!.text,
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
                          ref.read(authProvider.notifier).updateUser(
                                (e) => e.copyWith(
                                  shippingAddress: (e.shippingAddress ??
                                          const ShippingAddress())
                                      .copyWith(
                                    fullName: fullNameTextController!.text,
                                    addressLine1:
                                        streetaddressTextController!.text,
                                    addressLine2:
                                        aptsuiteunitTextController!.text,
                                    city: cityTextController!.text,
                                    state: (countryDropdownValue == 'US') ||
                                            (countryDropdownValue == 'CA')
                                        ? stateDropdownValue ?? ''
                                        : stateTextController!.text,
                                    country: countryDropdownValue ?? '',
                                    zipCode: zipCodeTextController!.text,
                                  ),
                                ),
                              );
                          setState(() {});
                        }),
                      ]);
                      Navigator.pop(context);

                      setState(() {});
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: AppOutlineButton(
                    text: 'Cancel',
                    onPressed: () async {
                      Navigator.pop(context);
                    },
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
