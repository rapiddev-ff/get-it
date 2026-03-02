import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'checkout_edit_shipping_address_widget.dart'
    show CheckoutEditShippingAddressWidget;
import 'package:flutter/material.dart';

class CheckoutEditShippingAddressModel
    extends FlutterFlowModel<CheckoutEditShippingAddressWidget> {
  ///  Local state fields for this page.

  List<String> autocompletePredictionName = [];
  void addToAutocompletePredictionName(String item) =>
      autocompletePredictionName.add(item);
  void removeFromAutocompletePredictionName(String item) =>
      autocompletePredictionName.remove(item);
  void removeAtIndexFromAutocompletePredictionName(int index) =>
      autocompletePredictionName.removeAt(index);
  void insertAtIndexInAutocompletePredictionName(int index, String item) =>
      autocompletePredictionName.insert(index, item);
  void updateAutocompletePredictionNameAtIndex(
          int index, Function(String) updateFn) =>
      autocompletePredictionName[index] =
          updateFn(autocompletePredictionName[index]);

  List<String> autocompletePredictionPlace = [];
  void addToAutocompletePredictionPlace(String item) =>
      autocompletePredictionPlace.add(item);
  void removeFromAutocompletePredictionPlace(String item) =>
      autocompletePredictionPlace.remove(item);
  void removeAtIndexFromAutocompletePredictionPlace(int index) =>
      autocompletePredictionPlace.removeAt(index);
  void insertAtIndexInAutocompletePredictionPlace(int index, String item) =>
      autocompletePredictionPlace.insert(index, item);
  void updateAutocompletePredictionPlaceAtIndex(
          int index, Function(String) updateFn) =>
      autocompletePredictionPlace[index] =
          updateFn(autocompletePredictionPlace[index]);

  String? choosenPlaceId;

  ///  State fields for stateful widgets in this page.

  // State field(s) for FullName widget.
  FocusNode? fullNameFocusNode;
  TextEditingController? fullNameTextController;
  String? Function(BuildContext, String?)? fullNameTextControllerValidator;
  // State field(s) for Streetaddress widget.
  final streetaddressKey = GlobalKey();
  FocusNode? streetaddressFocusNode;
  TextEditingController? streetaddressTextController;
  String? streetaddressSelectedOption;
  String? Function(BuildContext, String?)? streetaddressTextControllerValidator;
  // Stores action output result for [Backend Call - API (autocomplete)] action in Streetaddress widget.
  ApiCallResponse? apiResultlkc;
  // Stores action output result for [Backend Call - API (getPlace)] action in Streetaddress widget.
  ApiCallResponse? getPlace;
  // State field(s) for Aptsuiteunit widget.
  FocusNode? aptsuiteunitFocusNode;
  TextEditingController? aptsuiteunitTextController;
  String? Function(BuildContext, String?)? aptsuiteunitTextControllerValidator;
  // State field(s) for City widget.
  FocusNode? cityFocusNode;
  TextEditingController? cityTextController;
  String? Function(BuildContext, String?)? cityTextControllerValidator;
  // State field(s) for CountryDropdown widget.
  String? countryDropdownValue;
  FormFieldController<String>? countryDropdownValueController;
  // State field(s) for StateDropdown widget.
  String? stateDropdownValue;
  FormFieldController<String>? stateDropdownValueController;
  // State field(s) for State widget.
  FocusNode? stateFocusNode;
  TextEditingController? stateTextController;
  String? Function(BuildContext, String?)? stateTextControllerValidator;
  // State field(s) for ZipCode widget.
  FocusNode? zipCodeFocusNode;
  TextEditingController? zipCodeTextController;
  String? Function(BuildContext, String?)? zipCodeTextControllerValidator;
  // Stores action output result for [Backend Call - Insert Row] action in Button widget.
  ShippingAddressesRow? createShippingAddress;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    fullNameFocusNode?.dispose();
    fullNameTextController?.dispose();

    streetaddressFocusNode?.dispose();

    aptsuiteunitFocusNode?.dispose();
    aptsuiteunitTextController?.dispose();

    cityFocusNode?.dispose();
    cityTextController?.dispose();

    stateFocusNode?.dispose();
    stateTextController?.dispose();

    zipCodeFocusNode?.dispose();
    zipCodeTextController?.dispose();
  }
}
