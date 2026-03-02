import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'settings_payment_method_add_widget.dart'
    show SettingsPaymentMethodAddWidget;
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class SettingsPaymentMethodAddModel
    extends FlutterFlowModel<SettingsPaymentMethodAddWidget> {
  ///  Local state fields for this page.

  bool setAsDefault = false;

  ///  State fields for stateful widgets in this page.

  // State field(s) for CardNumber widget.
  FocusNode? cardNumberFocusNode;
  TextEditingController? cardNumberTextController;
  late MaskTextInputFormatter cardNumberMask;
  String? Function(BuildContext, String?)? cardNumberTextControllerValidator;
  // State field(s) for ExpireDate widget.
  FocusNode? expireDateFocusNode;
  TextEditingController? expireDateTextController;
  late MaskTextInputFormatter expireDateMask;
  String? Function(BuildContext, String?)? expireDateTextControllerValidator;
  // State field(s) for TextFieldaCVC widget.
  FocusNode? textFieldaCVCFocusNode;
  TextEditingController? textFieldaCVCTextController;
  late MaskTextInputFormatter textFieldaCVCMask;
  String? Function(BuildContext, String?)? textFieldaCVCTextControllerValidator;
  // State field(s) for CardholderName widget.
  FocusNode? cardholderNameFocusNode;
  TextEditingController? cardholderNameTextController;
  String? Function(BuildContext, String?)?
      cardholderNameTextControllerValidator;
  // State field(s) for EmailAddress widget.
  FocusNode? emailAddressFocusNode;
  TextEditingController? emailAddressTextController;
  String? Function(BuildContext, String?)? emailAddressTextControllerValidator;
  // State field(s) for FullName widget.
  FocusNode? fullNameFocusNode;
  TextEditingController? fullNameTextController;
  String? Function(BuildContext, String?)? fullNameTextControllerValidator;
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
  FormFieldController<String>? countryDropdownValueController;
  // State field(s) for StateDropdown widget.
  String? stateDropdownValue;
  FormFieldController<String>? stateDropdownValueController;
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
  // Stores action output result for [Custom Action - addPaymentCard] action in Button widget.
  dynamic result;

  @override
  void initState(BuildContext context) {}

  @override
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
