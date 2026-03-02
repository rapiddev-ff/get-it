import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'home_dashoard_inventory_add_widget.dart'
    show HomeDashoardInventoryAddWidget;
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class HomeDashoardInventoryAddModel
    extends FlutterFlowModel<HomeDashoardInventoryAddWidget> {
  ///  Local state fields for this page.

  List<FFUploadedFile> uploadedImages = [];
  void addToUploadedImages(FFUploadedFile item) => uploadedImages.add(item);
  void removeFromUploadedImages(FFUploadedFile item) =>
      uploadedImages.remove(item);
  void removeAtIndexFromUploadedImages(int index) =>
      uploadedImages.removeAt(index);
  void insertAtIndexInUploadedImages(int index, FFUploadedFile item) =>
      uploadedImages.insert(index, item);
  void updateUploadedImagesAtIndex(
          int index, Function(FFUploadedFile) updateFn) =>
      uploadedImages[index] = updateFn(uploadedImages[index]);

  String shippingCost = 'Use Seller Default Shipping Rule';

  CategoriesRow? category;

  SubcategoriesRow? subcategory;

  List<ConditionsRow> conditionsList = [];
  void addToConditionsList(ConditionsRow item) => conditionsList.add(item);
  void removeFromConditionsList(ConditionsRow item) =>
      conditionsList.remove(item);
  void removeAtIndexFromConditionsList(int index) =>
      conditionsList.removeAt(index);
  void insertAtIndexInConditionsList(int index, ConditionsRow item) =>
      conditionsList.insert(index, item);
  void updateConditionsListAtIndex(
          int index, Function(ConditionsRow) updateFn) =>
      conditionsList[index] = updateFn(conditionsList[index]);

  String discount = 'percentage';

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // Stores action output result for [Custom Action - getProductDetails] action in homeDashoardInventoryAdd widget.
  ProductDetailsStruct? getProduct;
  // Stores action output result for [Backend Call - Query Rows] action in homeDashoardInventoryAdd widget.
  List<CategoriesRow>? getCategory;
  // Stores action output result for [Backend Call - Query Rows] action in homeDashoardInventoryAdd widget.
  List<SubcategoriesRow>? getSubcategory;
  // Stores action output result for [Backend Call - Query Rows] action in homeDashoardInventoryAdd widget.
  List<ConditionsRow>? getConditions;
  // Stores action output result for [Custom Action - convertUrlsToUploadedFileList] action in homeDashoardInventoryAdd widget.
  List<FFUploadedFile>? convertImages;
  bool isDataUploading_uploadDataEdit = false;
  FFUploadedFile uploadedLocalFile_uploadDataEdit =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  // State field(s) for title widget.
  FocusNode? titleFocusNode;
  TextEditingController? titleTextController;
  String? Function(BuildContext, String?)? titleTextControllerValidator;
  // Stores action output result for [Bottom Sheet - homeDashoardInventoryAddCategory] action in Container widget.
  CategoriesRow? choosenCategory;
  // Stores action output result for [Bottom Sheet - homeDashoardInventoryAddSubCategory] action in Container widget.
  SubcategoriesRow? choosenSubcategory;
  // State field(s) for skuPrefix widget.
  FocusNode? skuPrefixFocusNode;
  TextEditingController? skuPrefixTextController;
  String? Function(BuildContext, String?)? skuPrefixTextControllerValidator;
  // Stores action output result for [Custom Action - getNextSkuNumber] action in skuPrefix widget.
  dynamic getNextSkuNumber;
  // State field(s) for skuNumber widget.
  FocusNode? skuNumberFocusNode;
  TextEditingController? skuNumberTextController;
  String? Function(BuildContext, String?)? skuNumberTextControllerValidator;
  // State field(s) for quantity widget.
  FocusNode? quantityFocusNode;
  TextEditingController? quantityTextController;
  late MaskTextInputFormatter quantityMask;
  String? Function(BuildContext, String?)? quantityTextControllerValidator;
  // Stores action output result for [Bottom Sheet - homeDashoardInventoryAddCondition] action in Container widget.
  List<ConditionsRow>? choosenConditions;
  // State field(s) for year widget.
  FocusNode? yearFocusNode;
  TextEditingController? yearTextController;
  late MaskTextInputFormatter yearMask;
  String? Function(BuildContext, String?)? yearTextControllerValidator;
  // State field(s) for issue widget.
  FocusNode? issueFocusNode;
  TextEditingController? issueTextController;
  late MaskTextInputFormatter issueMask;
  String? Function(BuildContext, String?)? issueTextControllerValidator;
  // State field(s) for Price widget.
  FocusNode? priceFocusNode;
  TextEditingController? priceTextController;
  String? Function(BuildContext, String?)? priceTextControllerValidator;
  // State field(s) for flashDropDown widget.
  int? flashDropDownValue;
  FormFieldController<int>? flashDropDownValueController;
  // State field(s) for SwitchFlashSale widget.
  bool? switchFlashSaleValue;
  // State field(s) for PercentageDiscount widget.
  FocusNode? percentageDiscountFocusNode;
  TextEditingController? percentageDiscountTextController;
  late MaskTextInputFormatter percentageDiscountMask;
  String? Function(BuildContext, String?)?
      percentageDiscountTextControllerValidator;
  // State field(s) for DollarDiscount widget.
  FocusNode? dollarDiscountFocusNode;
  TextEditingController? dollarDiscountTextController;
  String? Function(BuildContext, String?)?
      dollarDiscountTextControllerValidator;
  // State field(s) for FlatShippingCost widget.
  FocusNode? flatShippingCostFocusNode;
  TextEditingController? flatShippingCostTextController;
  String? Function(BuildContext, String?)?
      flatShippingCostTextControllerValidator;
  // State field(s) for AdditionalItemFee widget.
  FocusNode? additionalItemFeeFocusNode;
  TextEditingController? additionalItemFeeTextController;
  String? Function(BuildContext, String?)?
      additionalItemFeeTextControllerValidator;
  // State field(s) for desc widget.
  FocusNode? descFocusNode;
  TextEditingController? descTextController;
  String? Function(BuildContext, String?)? descTextControllerValidator;
  // State field(s) for SwitchConventionSettings widget.
  bool? switchConventionSettingsValue;
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  // Stores action output result for [Custom Action - createProduct] action in Button widget.
  dynamic createProduct;
  // Stores action output result for [Custom Action - createProduct] action in Button widget.
  dynamic createProductAsDraft;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    titleFocusNode?.dispose();
    titleTextController?.dispose();

    skuPrefixFocusNode?.dispose();
    skuPrefixTextController?.dispose();

    skuNumberFocusNode?.dispose();
    skuNumberTextController?.dispose();

    quantityFocusNode?.dispose();
    quantityTextController?.dispose();

    yearFocusNode?.dispose();
    yearTextController?.dispose();

    issueFocusNode?.dispose();
    issueTextController?.dispose();

    priceFocusNode?.dispose();
    priceTextController?.dispose();

    percentageDiscountFocusNode?.dispose();
    percentageDiscountTextController?.dispose();

    dollarDiscountFocusNode?.dispose();
    dollarDiscountTextController?.dispose();

    flatShippingCostFocusNode?.dispose();
    flatShippingCostTextController?.dispose();

    additionalItemFeeFocusNode?.dispose();
    additionalItemFeeTextController?.dispose();

    descFocusNode?.dispose();
    descTextController?.dispose();
  }
}
