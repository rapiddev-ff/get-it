import 'package:flutter/material.dart';

class SettingsBusinessAddressModel {
  /// Local state fields for this page.
  bool setAsDefault = false;

  // State field(s) for AddressLine1 widget.
  FocusNode? addressLine1FocusNode;
  TextEditingController? addressLine1TextController;
  String? Function(BuildContext, String?)? addressLine1TextControllerValidator;
  // State field(s) for AddressLine2 widget.
  FocusNode? addressLine2FocusNode;
  TextEditingController? addressLine2TextController;
  String? Function(BuildContext, String?)? addressLine2TextControllerValidator;
  // State field(s) for CountryDropdown widget.
  String? countryDropdownValue;
  // State field(s) for StateDropdown widget.
  String? stateDropdownValue;
  // State field(s) for State widget.
  FocusNode? stateFocusNode;
  TextEditingController? stateTextController;
  String? Function(BuildContext, String?)? stateTextControllerValidator;
  // State field(s) for City widget.
  FocusNode? cityFocusNode;
  TextEditingController? cityTextController;
  String? Function(BuildContext, String?)? cityTextControllerValidator;
  // State field(s) for ZipCode widget.
  FocusNode? zipCodeFocusNode;
  TextEditingController? zipCodeTextController;
  String? Function(BuildContext, String?)? zipCodeTextControllerValidator;

  void dispose() {
    addressLine1FocusNode?.dispose();
    addressLine1TextController?.dispose();

    addressLine2FocusNode?.dispose();
    addressLine2TextController?.dispose();

    stateFocusNode?.dispose();
    stateTextController?.dispose();

    cityFocusNode?.dispose();
    cityTextController?.dispose();

    zipCodeFocusNode?.dispose();
    zipCodeTextController?.dispose();
  }
}
