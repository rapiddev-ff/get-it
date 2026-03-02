import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'settings_business_address_widget.dart'
    show SettingsBusinessAddressWidget;
import 'package:flutter/material.dart';

class SettingsBusinessAddressModel
    extends FlutterFlowModel<SettingsBusinessAddressWidget> {
  ///  Local state fields for this page.

  bool setAsDefault = false;

  ///  State fields for stateful widgets in this page.

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

  @override
  void initState(BuildContext context) {}

  @override
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
