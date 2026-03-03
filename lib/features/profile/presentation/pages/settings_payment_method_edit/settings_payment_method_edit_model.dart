import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class SettingsPaymentMethodEditModel {
  ///  Local state fields for this page.

  bool setAsDefault = false;

  ///  State fields for stateful widgets in this page.

  // State field(s) for CardNumber widget.
  FocusNode? cardNumberFocusNode;
  TextEditingController? cardNumberTextController;
  late MaskTextInputFormatter cardNumberMask;
  // State field(s) for ExpireDate widget.
  FocusNode? expireDateFocusNode;
  TextEditingController? expireDateTextController;
  late MaskTextInputFormatter expireDateMask;
  // State field(s) for TextFieldaCVC widget.
  FocusNode? textFieldaCVCFocusNode;
  TextEditingController? textFieldaCVCTextController;
  // State field(s) for CardholderName widget.
  FocusNode? cardholderNameFocusNode;
  TextEditingController? cardholderNameTextController;
  // State field(s) for EmailAddress widget.
  FocusNode? emailAddressFocusNode;
  TextEditingController? emailAddressTextController;
  // State field(s) for FullName widget.
  FocusNode? fullNameFocusNode;
  TextEditingController? fullNameTextController;
  // State field(s) for AddressLine1 widget.
  FocusNode? addressLine1FocusNode;
  TextEditingController? addressLine1TextController;
  // State field(s) for AddressLine2 widget.
  FocusNode? addressLine2FocusNode;
  TextEditingController? addressLine2TextController;
  // State field(s) for CountryDropdown widget.
  String? countryDropdownValue;
  // State field(s) for StateDropdown widget.
  String? stateDropdownValue;
  // State field(s) for State widget.
  FocusNode? stateFocusNode;
  TextEditingController? stateTextController;
  // State field(s) for City widget.
  FocusNode? cityFocusNode;
  TextEditingController? cityTextController;
  // State field(s) for ZipCode widget.
  FocusNode? zipCodeFocusNode;
  TextEditingController? zipCodeTextController;

  void dispose() {
    cardNumberFocusNode?.dispose();
    cardNumberTextController?.dispose();

    expireDateFocusNode?.dispose();
    expireDateTextController?.dispose();

    textFieldaCVCFocusNode?.dispose();
    textFieldaCVCTextController?.dispose();

    cardholderNameFocusNode?.dispose();
    cardholderNameTextController?.dispose();

    emailAddressFocusNode?.dispose();
    emailAddressTextController?.dispose();

    fullNameFocusNode?.dispose();
    fullNameTextController?.dispose();

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
