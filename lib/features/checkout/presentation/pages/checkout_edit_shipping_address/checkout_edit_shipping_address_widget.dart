import '/features/checkout/domain/models/shipping_address_model.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/geo_data.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/app_text_field.dart';
import '/core/widgets/app_gradient_button.dart';
import '/core/widgets/app_drop_down.dart';
import '/core/widgets/form_field_controller.dart';
import '/core/widgets/dismiss_keyboard.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import '/core/providers/current_user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckoutEditShippingAddressWidget extends ConsumerStatefulWidget {
  const CheckoutEditShippingAddressWidget({
    super.key,
    this.existingAddress,
  });

  /// When non-null the page is in **edit** mode – fields are pre-populated
  /// and Save performs an UPDATE instead of INSERT.
  final ShippingAddress? existingAddress;

  bool get isEditMode => existingAddress != null && existingAddress!.id.isNotEmpty;

  static const String routeName = 'checkoutEditShippingAddress';
  static const String routePath = 'checkoutEditShippingAddress';

  @override
  ConsumerState<CheckoutEditShippingAddressWidget> createState() =>
      _CheckoutEditShippingAddressWidgetState();
}

class _CheckoutEditShippingAddressWidgetState
    extends ConsumerState<CheckoutEditShippingAddressWidget> {
  // Inlined model state
  List<String> autocompletePredictionName = [];
  List<String> autocompletePredictionPlace = [];
  bool _showSuggestions = false;
  FocusNode? fullNameFocusNode;
  TextEditingController? fullNameTextController;
  FocusNode? streetaddressFocusNode;
  TextEditingController? streetaddressTextController;
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

  // Inline: parseAddressComponents
  static Map<String, String> _parseAddressComponents(dynamic addressResponse) {
    final components = (addressResponse is Map
            ? addressResponse['addressComponents']
            : null) as List? ??
        [];
    String streetNumber = '';
    String route = '';
    String city = '';
    String county = '';
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
          types.contains('sublocality_level_1') ||
          types.contains('postal_town')) city = longText;
      if (types.contains('administrative_area_level_2')) county = longText;
      if (types.contains('administrative_area_level_1')) state = longText;
      if (types.contains('postal_code')) zip = longText;
      if (types.contains('country')) country = shortText;
    }
    // Fallback: use formattedAddress first part for street if no route
    String street = '$streetNumber $route'.trim();
    if (street.isEmpty && addressResponse is Map) {
      final formatted = (addressResponse['formattedAddress'] ?? '').toString();
      if (formatted.isNotEmpty) {
        street = formatted.split(',').first.trim();
      }
    }
    // Fallback: use county for city if locality not found
    if (city.isEmpty) city = county;
    return {
      'street': street,
      'city': city,
      'state': state,
      'zip': zip,
      'country': country,
    };
  }

  Future<void> _selectPlace(int index) async {
    final placeId = autocompletePredictionPlace[index];
    final selectedName = autocompletePredictionName[index];
    setState(() {
      streetaddressTextController?.text = selectedName;
      _showSuggestions = false;
      autocompletePredictionName = [];
      autocompletePredictionPlace = [];
    });

    final getPlace =
        await GooglePlacesGroup.getPlaceCall.call(placeId: placeId);
    if (!mounted) return;

    if (getPlace.succeeded) {
      final parsed = _parseAddressComponents(getPlace.jsonBody ?? {});
      setState(() {
        streetaddressTextController?.text = parsed['street'] ?? '';
        cityTextController?.text = parsed['city'] ?? '';
        zipCodeTextController?.text = parsed['zip'] ?? '';
        stateTextController?.text = parsed['state'] ?? '';
        stateDropdownValue = parsed['state'] ?? '';
        stateDropdownValueController?.value = parsed['state'] ?? '';
        countryDropdownValue = parsed['country'] ?? '';
        countryDropdownValueController?.value = parsed['country'] ?? '';
      });
    }
  }

  @override
  void initState() {
    super.initState();

    final addr = widget.existingAddress;
    final isEdit = widget.isEditMode;

    fullNameTextController ??= TextEditingController(
        text: isEdit
            ? addr!.fullName
            : '${ref.read(authProvider).firstName} ${ref.read(authProvider).lastName}');
    fullNameFocusNode ??= FocusNode();

    streetaddressTextController ??=
        TextEditingController(text: isEdit ? addr!.addressLine1 : '');
    streetaddressFocusNode ??= FocusNode();
    streetaddressFocusNode!.addListener(() {
      if (!streetaddressFocusNode!.hasFocus) {
        Future.delayed(Duration(milliseconds: 200), () {
          if (mounted) setState(() => _showSuggestions = false);
        });
      }
    });

    aptsuiteunitTextController ??=
        TextEditingController(text: isEdit ? addr!.addressLine2 : '');
    aptsuiteunitFocusNode ??= FocusNode();

    cityTextController ??=
        TextEditingController(text: isEdit ? addr!.city : '');
    cityFocusNode ??= FocusNode();

    stateTextController ??=
        TextEditingController(text: isEdit ? addr!.state : '');
    stateFocusNode ??= FocusNode();

    zipCodeTextController ??=
        TextEditingController(text: isEdit ? addr!.zipCode : '');
    zipCodeFocusNode ??= FocusNode();

    if (isEdit) {
      countryDropdownValue = addr!.country;
      stateDropdownValue = addr.state;
    }
  }

  @override
  void dispose() {
    EasyDebounce.cancelAll();
    fullNameFocusNode?.dispose();
    fullNameTextController?.dispose();
    streetaddressFocusNode?.dispose();
    streetaddressTextController?.dispose();
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
                  widget.isEditMode
                      ? 'Edit Shipping Address'
                      : 'Add Shipping Address',
                  style: Theme.of(context).textTheme.titleMedium!,
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
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontSize: 15.0),
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
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontSize: 15.0),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TextFormField(
                                  controller: streetaddressTextController,
                                  focusNode: streetaddressFocusNode,
                                  onChanged: (_) => EasyDebounce.debounce(
                                    'streetaddressTextController',
                                    Duration(milliseconds: 300),
                                    () async {
                                      final text =
                                          streetaddressTextController?.text ??
                                              '';
                                      if (text.length >= 3) {
                                        final result = await GooglePlacesGroup
                                            .autocompleteCall
                                            .call(searchingString: text);
                                        if (!mounted) return;
                                        if (result.succeeded) {
                                          autocompletePredictionName =
                                              GooglePlacesGroup
                                                      .autocompleteCall
                                                      .predictionPlaceText(
                                                        result.jsonBody ?? '',
                                                      )
                                                      ?.toList()
                                                      .cast<String>() ??
                                                  [];
                                          autocompletePredictionPlace =
                                              (GooglePlacesGroup
                                                          .autocompleteCall
                                                          .autocompletePredictions(
                                                    result.jsonBody ?? '',
                                                  ) as List?)
                                                      ?.map<String>((e) =>
                                                          e.toString())
                                                      .toList() ??
                                                  [];
                                          setState(() => _showSuggestions =
                                              autocompletePredictionName
                                                  .isNotEmpty);
                                        }
                                      } else {
                                        if (mounted) {
                                          setState(() {
                                            _showSuggestions = false;
                                            autocompletePredictionName = [];
                                            autocompletePredictionPlace = [];
                                          });
                                        }
                                      }
                                    },
                                  ),
                                  autofocus: false,
                                  textInputAction: TextInputAction.done,
                                  decoration: appInputDecoration(
                                      'Enter street address'),
                                  style: appTextFieldStyle,
                                  cursorColor: AppColors.textPrimary,
                                ),
                                if (_showSuggestions &&
                                    autocompletePredictionName.isNotEmpty)
                                  Material(
                                    elevation: 4.0,
                                    color: AppColors.backgroundPrimary,
                                    borderRadius: BorderRadius.circular(4.0),
                                    child: ConstrainedBox(
                                      constraints:
                                          BoxConstraints(maxHeight: 200.0),
                                      child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        itemCount:
                                            autocompletePredictionName.length,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () => _selectPlace(index),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16.0,
                                                  vertical: 12.0),
                                              child: Text(
                                                autocompletePredictionName[
                                                    index],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium,
                                                maxLines: 2,
                                                overflow:
                                                    TextOverflow.ellipsis,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Text(
                              'Apt, suite, unit',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontSize: 15.0),
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
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontSize: 15.0),
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontSize: 15.0),
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
                                  textStyle:
                                      Theme.of(context).textTheme.bodyMedium!,
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(fontSize: 15.0),
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
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!,
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
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 12.0),
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(fontSize: 15.0),
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
                      final stateValue = (countryDropdownValue == 'US') ||
                              (countryDropdownValue == 'CA')
                          ? stateDropdownValue ?? ''
                          : stateTextController!.text;

                      final data = {
                        'full_name': fullNameTextController!.text,
                        'address_line1': streetaddressTextController!.text,
                        'address_line2': aptsuiteunitTextController!.text,
                        'city': cityTextController!.text,
                        'country': countryDropdownValue,
                        'state': stateValue,
                        'zip_code': zipCodeTextController!.text,
                      };

                      String savedId;

                      if (widget.isEditMode) {
                        // UPDATE existing address
                        await ShippingAddressesTable().update(
                          data: data,
                          matchingRows: (rows) =>
                              rows.eqOrNull('id', widget.existingAddress!.id),
                        );
                        savedId = widget.existingAddress!.id;
                      } else {
                        // INSERT new address
                        createShippingAddress =
                            await ShippingAddressesTable().insert({
                          ...data,
                          'user_id': ref.read(currentUserIdProvider),
                          'is_default': true,
                          'created_at': DateTime.now().toIso8601String(),
                        });
                        savedId = createShippingAddress?.id ?? '';
                      }

                      if (!mounted) return;

                      // Update local auth state
                      ref.read(authProvider.notifier).updateUser(
                            (e) => e.copyWith(
                              shippingAddress: (e.shippingAddress ??
                                      const ShippingAddress())
                                  .copyWith(
                                id: savedId,
                                fullName: fullNameTextController!.text,
                                addressLine1:
                                    streetaddressTextController!.text,
                                addressLine2:
                                    aptsuiteunitTextController!.text,
                                city: cityTextController!.text,
                                state: stateValue,
                                country: countryDropdownValue ?? '',
                                zipCode: zipCodeTextController!.text,
                              ),
                            ),
                          );

                      Navigator.pop(context);
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
