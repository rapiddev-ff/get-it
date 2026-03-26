import '/backend/supabase/supabase.dart';
import '/backend/api_requests/api_calls.dart';
import '/core/utils/geo_data.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import '/core/providers/current_user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/keyboard_visibility_mixin.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/app_text_field.dart';
import '/core/widgets/app_gradient_button.dart';
import '/core/widgets/dismiss_keyboard.dart';
import '/features/auth/domain/models/business_address_model.dart';
import '/features/auth/presentation/providers/auth_provider.dart';

class SettingsBusinessAddressWidget extends ConsumerStatefulWidget {
  const SettingsBusinessAddressWidget({super.key});

  static const String routeName = 'settingsBusinessAddress';
  static const String routePath = 'settingsBusinessAddress';

  @override
  ConsumerState<SettingsBusinessAddressWidget> createState() =>
      _SettingsBusinessAddressWidgetState();
}

class _SettingsBusinessAddressWidgetState
    extends ConsumerState<SettingsBusinessAddressWidget>
    with KeyboardVisibilityMixin {
  // Local state fields
  bool setAsDefault = false;
  String? countryDropdownValue;
  String? stateDropdownValue;
  List<String> _autocompletePredictions = [];
  List<String> _autocompletePlaceIds = [];
  bool _showAddressSuggestions = false;

  // Text controllers and focus nodes
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

    final userData = ref.read(authProvider);
    addressLine1TextController = TextEditingController(
        text: userData.businessAddress?.addressLine1 ?? '');
    addressLine1FocusNode = FocusNode();
    addressLine1FocusNode.addListener(() {
      if (!addressLine1FocusNode.hasFocus) {
        Future.delayed(Duration(milliseconds: 200), () {
          if (mounted) setState(() => _showAddressSuggestions = false);
        });
      }
    });
    addressLine2TextController = TextEditingController(
        text: userData.businessAddress?.addressLine2 ?? '');
    addressLine2FocusNode = FocusNode();    stateTextController =
        TextEditingController(text: userData.businessAddress?.state ?? '');
    stateFocusNode = FocusNode();    cityTextController =
        TextEditingController(text: userData.businessAddress?.city ?? '');
    cityFocusNode = FocusNode();    zipCodeTextController =
        TextEditingController(text: userData.businessAddress?.zipCode ?? '');
    zipCodeFocusNode = FocusNode();  }

  @override
  void dispose() {
    EasyDebounce.cancelAll();
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
    String street = '$streetNumber $route'.trim();
    if (street.isEmpty && addressResponse is Map) {
      final formatted = (addressResponse['formattedAddress'] ?? '').toString();
      if (formatted.isNotEmpty) {
        street = formatted.split(',').first.trim();
      }
    }
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
    final placeId = _autocompletePlaceIds[index];
    final selectedName = _autocompletePredictions[index];
    setState(() {
      addressLine1TextController.text = selectedName;
      _showAddressSuggestions = false;
      _autocompletePredictions = [];
      _autocompletePlaceIds = [];
    });

    final getPlace =
        await GooglePlacesGroup.getPlaceCall.call(placeId: placeId);
    if (!mounted) return;

    if (getPlace.succeeded) {
      final parsed = _parseAddressComponents(getPlace.jsonBody ?? {});
      setState(() {
        addressLine1TextController.text = parsed['street'] ?? '';
        cityTextController.text = parsed['city'] ?? '';
        zipCodeTextController.text = parsed['zip'] ?? '';
        stateTextController.text = parsed['state'] ?? '';
        stateDropdownValue = parsed['state'] ?? '';
        countryDropdownValue = parsed['country'] ?? '';
      });
    }
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
            'Business Address',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
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
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Text(
                            'Address',
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
                              Container(
                                width: double.infinity,
                                child: AppTextField(
                                  controller: addressLine1TextController,
                                  focusNode: addressLine1FocusNode,
                                  hintText: '123, Main street',
                                  onChanged: (_) => EasyDebounce.debounce(
                                    'addressLine1TextController',
                                    Duration(milliseconds: 300),
                                    () async {
                                      final text =
                                          addressLine1TextController.text;
                                      if (text.length >= 3) {
                                        final result = await GooglePlacesGroup
                                            .autocompleteCall
                                            .call(searchingString: text);
                                        if (!mounted) return;
                                        if (result.succeeded) {
                                          _autocompletePredictions =
                                              GooglePlacesGroup.autocompleteCall
                                                      .predictionPlaceText(
                                                          result.jsonBody ?? '')
                                                      ?.toList()
                                                      .cast<String>() ??
                                                  [];
                                          _autocompletePlaceIds =
                                              (GooglePlacesGroup
                                                              .autocompleteCall
                                                              .autocompletePredictions(
                                                                  result.jsonBody ??
                                                                      '')
                                                          as List?)
                                                      ?.map<String>(
                                                          (e) => e.toString())
                                                      .toList() ??
                                                  [];
                                          setState(() =>
                                              _showAddressSuggestions =
                                                  _autocompletePredictions
                                                      .isNotEmpty);
                                        }
                                      } else {
                                        if (mounted) {
                                          setState(() {
                                            _showAddressSuggestions = false;
                                            _autocompletePredictions = [];
                                            _autocompletePlaceIds = [];
                                          });
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ),
                              if (_showAddressSuggestions &&
                                  _autocompletePredictions.isNotEmpty)
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
                                          _autocompletePredictions.length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () => _selectPlace(index),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16.0,
                                                vertical: 12.0),
                                            child: Text(
                                              _autocompletePredictions[index],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
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
                          child: Container(
                            width: double.infinity,
                            child: AppTextField(
                              controller: addressLine2TextController,
                              focusNode: addressLine2FocusNode,
                              hintText: 'Apartment, suite, etc. (optional)',
                              onChanged: (_) => EasyDebounce.debounce(
                                'addressLine2TextController',
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(fontSize: 15.0),
                                    ),
                                    DropdownButtonFormField<String>(
                                      initialValue: () {
                                        final saved = countryDropdownValue ??=
                                            ref
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
                                          countryDropdownValue =
                                              match.first['code']!;
                                          return countryDropdownValue;
                                        }
                                        countryDropdownValue = '';
                                        return null;
                                      }(),
                                      items: GeoData.getCountries()
                                          .map((c) => DropdownMenuItem(
                                                value: c['code'],
                                                child: Text(c['name']!,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!),
                                              ))
                                          .toList(),
                                      onChanged: (val) => setState(
                                          () => countryDropdownValue = val),
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!,
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(fontSize: 15.0),
                                    ),
                                    Builder(
                                      builder: (context) {
                                        if ((countryDropdownValue == 'US') ||
                                            (countryDropdownValue == 'CA')) {
                                          return DropdownButtonFormField<
                                              String>(
                                            initialValue: () {
                                              final saved =
                                                  stateDropdownValue ??= ref
                                                          .read(authProvider)
                                                          .businessAddress
                                                          ?.state ??
                                                      '';
                                              if (saved.isEmpty) return null;
                                              final valid =
                                                  GeoData.getStatesByCountry(
                                                      countryDropdownValue);
                                              if (valid.contains(saved)) {
                                                return saved;
                                              }
                                              stateDropdownValue = '';
                                              return null;
                                            }(),
                                            items: GeoData.getStatesByCountry(
                                                    countryDropdownValue)
                                                .map((name) => DropdownMenuItem(
                                                      value: name,
                                                      child: Text(name,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyMedium!),
                                                    ))
                                                .toList(),
                                            onChanged: (val) => setState(
                                                () => stateDropdownValue = val),
                                            decoration: InputDecoration(
                                              isDense: true,
                                              hintText: 'State',
                                              hintStyle: Theme.of(context)
                                                  .textTheme
                                                  .labelMedium!,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 12.0,
                                                      vertical: 16.0),
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
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!,
                                            isExpanded: true,
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(fontSize: 15.0),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      child: AppTextField(
                                        controller: cityTextController,
                                        focusNode: cityFocusNode,
                                        hintText: 'City',
                                        onChanged: (_) => EasyDebounce.debounce(
                                          'cityTextController',
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
                                        onChanged: (_) => EasyDebounce.debounce(
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
                                      'business_address_line1':
                                          addressLine1TextController.text,
                                      'business_address_line2':
                                          addressLine2TextController.text,
                                      'business_country': countryDropdownValue,
                                      'business_state':
                                          (countryDropdownValue == 'US') ||
                                                  (countryDropdownValue == 'CA')
                                              ? stateDropdownValue
                                              : stateTextController.text,
                                      'business_city': cityTextController.text,
                                      'business_zip':
                                          zipCodeTextController.text,
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
                                            addressLine1:
                                                addressLine1TextController.text,
                                            addressLine2:
                                                addressLine2TextController.text,
                                            country: countryDropdownValue ?? '',
                                            state: (countryDropdownValue ==
                                                        'US') ||
                                                    (countryDropdownValue ==
                                                        'CA')
                                                ? stateDropdownValue ?? ''
                                                : stateTextController.text,
                                            city: cityTextController.text,
                                            zipCode: zipCodeTextController.text,
                                          ),
                                        ),
                                      );
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
