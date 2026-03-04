import '/features/auth/data/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/features/home/presentation/pages/seller_dashboard/dialog_product_created/dialog_product_created_widget.dart';
import '/features/home/presentation/pages/seller_dashboard/dialog_product_draft/dialog_product_draft_widget.dart';
import '/features/home/presentation/pages/seller_dashboard/inventory_add_category/home_dashoard_inventory_add_category_widget.dart';
import '/features/home/presentation/pages/seller_dashboard/inventory_add_condition/home_dashoard_inventory_add_condition_widget.dart';
import '/features/home/presentation/pages/seller_dashboard/inventory_add_sub_category/home_dashoard_inventory_add_sub_category_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/core/theme/app_colors.dart';
import '/core/constants/app_constants.dart';
import '/core/utils/list_extensions.dart';
import '/core/utils/value_utils.dart';
import '/core/widgets/app_drop_down.dart';
import '/core/widgets/form_field_controller.dart';
import '/core/utils/uploaded_file.dart';
import '/core/utils/upload_data.dart';
import '/features/home/domain/models/product_details_model.dart';
import '/features/browse/domain/models/tag_model.dart';
import 'package:go_router/go_router.dart';
import '/features/home/presentation/pages/seller_dashboard/inventory_add_tags/home_dashoard_inventory_add_tags_widget.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class HomeDashoardInventoryAddWidget extends StatefulWidget {
  const HomeDashoardInventoryAddWidget({
    super.key,
    this.productId,
  });

  final String? productId;

  static String routeName = 'homeDashoardInventoryAdd';
  static String routePath = 'homeDashoardInventoryAdd';

  @override
  State<HomeDashoardInventoryAddWidget> createState() =>
      _HomeDashoardInventoryAddWidgetState();
}

class _HomeDashoardInventoryAddWidgetState
    extends State<HomeDashoardInventoryAddWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  // Model state inlined
  List<UploadedFile> uploadedImages = [];
  String shippingCost = 'Use Seller Default Shipping Rule';
  CategoriesRow? category;
  SubcategoriesRow? subcategory;
  List<ConditionsRow> conditionsList = [];
  String discount = 'percentage';
  ProductDetails? getProduct;
  List<CategoriesRow>? getCategory;
  List<SubcategoriesRow>? getSubcategory;
  List<ConditionsRow>? getConditions;
  List<UploadedFile>? convertImages;
  bool isDataUploading_uploadDataEdit = false;
  List<Tag> choosenTags = [];
  List<Tag> tags = [];
  List<ShortlistsRow> userShortlists = [];

  void addToUploadedImages(UploadedFile item) => uploadedImages.add(item);
  void removeFromUploadedImages(UploadedFile item) =>
      uploadedImages.remove(item);
  dynamic getNextSkuNumber;
  dynamic createProduct;
  dynamic createProductAsDraft;

  // Flash sale
  bool? switchFlashSaleValue;
  int? flashDropDownValue;
  FormFieldController<int>? flashDropDownValueController;

  // Convention settings
  bool? switchConventionSettingsValue;
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;

  // Text controllers
  TextEditingController? titleTextController;
  FocusNode? titleFocusNode;
  TextEditingController? skuPrefixTextController;
  FocusNode? skuPrefixFocusNode;
  TextEditingController? skuNumberTextController;
  FocusNode? skuNumberFocusNode;
  TextEditingController? quantityTextController;
  FocusNode? quantityFocusNode;
  late MaskTextInputFormatter quantityMask;
  TextEditingController? yearTextController;
  FocusNode? yearFocusNode;
  late MaskTextInputFormatter yearMask;
  TextEditingController? issueTextController;
  FocusNode? issueFocusNode;
  late MaskTextInputFormatter issueMask;
  TextEditingController? priceTextController;
  FocusNode? priceFocusNode;
  TextEditingController? percentageDiscountTextController;
  FocusNode? percentageDiscountFocusNode;
  late MaskTextInputFormatter percentageDiscountMask;
  TextEditingController? dollarDiscountTextController;
  FocusNode? dollarDiscountFocusNode;
  TextEditingController? flatShippingCostTextController;
  FocusNode? flatShippingCostFocusNode;
  TextEditingController? additionalItemFeeTextController;
  FocusNode? additionalItemFeeFocusNode;
  TextEditingController? descTextController;
  FocusNode? descFocusNode;

  @override
  void initState() {
    super.initState();
    // Model state inlined into State class

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      choosenTags = [];
      userShortlists = await ShortlistsTable().queryRows(
        queryFn: (q) => q.eqOrNull('seller_id', currentUserUid),
      );
      setState(() {});
      if (widget.productId != null && widget.productId != '') {
        getProduct = await actions.getProductDetails(
          widget.productId!,
          currentUserUid,
        );
        await Future.wait([
          Future(() async {
            setState(() {
              titleTextController?.text = getProduct!.title;
            });
          }),
          Future(() async {
            setState(() {
              skuPrefixTextController?.text = getProduct!.sku ?? '';
            });
          }),
          Future(() async {
            setState(() {
              quantityTextController?.text = getProduct!.quantity.toString();
              quantityMask.updateMask(
                newValue: TextEditingValue(
                  text: quantityTextController!.text,
                ),
              );
            });
          }),
          Future(() async {
            setState(() {
              yearTextController?.text = getProduct!.year.toString();
              yearMask.updateMask(
                newValue: TextEditingValue(
                  text: yearTextController!.text,
                ),
              );
            });
          }),
          Future(() async {
            setState(() {
              issueTextController?.text = getProduct!.issueNumber.toString();
              issueMask.updateMask(
                newValue: TextEditingValue(
                  text: issueTextController!.text,
                ),
              );
            });
          }),
          Future(() async {
            setState(() {
              priceTextController?.text = getProduct!.price.toString();
            });
          }),
          Future(() async {
            setState(() {
              descTextController?.text = getProduct!.description;
            });
          }),
          Future(() async {
            if (getProduct?.discountType == 'dollar') {
              setState(() {
                dollarDiscountTextController?.text =
                    getProduct!.discountAmount.toString();
              });
            } else {
              setState(() {
                percentageDiscountTextController?.text =
                    getProduct!.discountAmount.toString();
                percentageDiscountMask.updateMask(
                  newValue: TextEditingValue(
                    text: percentageDiscountTextController!.text,
                  ),
                );
              });
            }
          }),
          Future(() async {
            setState(() {
              flatShippingCostTextController?.text =
                  getProduct!.customFlatRate.toString();
            });
          }),
          Future(() async {
            setState(() {
              additionalItemFeeTextController?.text =
                  getProduct!.customAdditionalItemFee.toString();
            });
          }),
          Future(() async {
            setState(() {
              skuNumberTextController?.text = getProduct!.skuNumber ?? '';
            });
          }),
        ]);
        await Future.wait([
          Future(() async {
            getCategory = await CategoriesTable().queryRows(
              queryFn: (q) => q.eqOrNull(
                'id',
                getProduct?.category?.id,
              ),
            );
          }),
          Future(() async {
            getSubcategory = await SubcategoriesTable().queryRows(
              queryFn: (q) => q.eqOrNull(
                'id',
                getProduct?.subcategory?.id,
              ),
            );
          }),
          Future(() async {
            getConditions = await ConditionsTable().queryRows(
              queryFn: (q) => q.inFilterOrNull(
                'id',
                getProduct?.conditions.map((e) => e.id).toList(),
              ),
            );
          }),
          Future(() async {
            convertImages = await actions.convertUrlsToUploadedFileList(
              getProduct!.images
                  .map((e) {
                    final m = e.toJson();
                    return m['imageUrl'];
                  })
                  .toList()
                  .map((e) => e.toString())
                  .toList()
                  .toList(),
            );
          }),
        ]);
        uploadedImages = convertImages!.toList().cast<UploadedFile>();
        category = getCategory?.firstOrNull;
        subcategory = getSubcategory?.firstOrNull;
        conditionsList = getConditions!.toList().cast<ConditionsRow>();
        choosenTags = getProduct!.tags.toList();
        discount = getProduct!.discountType ?? 'percentage';
        if (getProduct?.shortlistId != null && getProduct!.shortlistId!.isNotEmpty) {
          switchConventionSettingsValue = true;
          dropDownValue = getProduct!.shortlistId;
          dropDownValueController = FormFieldController<String>(dropDownValue);
        }
        setState(() {});
      }
    });

    titleTextController ??= TextEditingController();
    titleFocusNode ??= FocusNode();
    titleFocusNode!.addListener(() => setState(() {}));
    skuPrefixTextController ??= TextEditingController();
    skuPrefixFocusNode ??= FocusNode();
    skuPrefixFocusNode!.addListener(() => setState(() {}));
    skuNumberTextController ??= TextEditingController();
    skuNumberFocusNode ??= FocusNode();
    skuNumberFocusNode!.addListener(() => setState(() {}));
    quantityTextController ??= TextEditingController();
    quantityFocusNode ??= FocusNode();
    quantityFocusNode!.addListener(() => setState(() {}));
    quantityMask = MaskTextInputFormatter(mask: '####');
    yearTextController ??= TextEditingController();
    yearFocusNode ??= FocusNode();
    yearFocusNode!.addListener(() => setState(() {}));
    yearMask = MaskTextInputFormatter(mask: '####');
    issueTextController ??= TextEditingController();
    issueFocusNode ??= FocusNode();
    issueFocusNode!.addListener(() => setState(() {}));
    issueMask = MaskTextInputFormatter(mask: '#######');
    priceTextController ??= TextEditingController();
    priceFocusNode ??= FocusNode();
    priceFocusNode!.addListener(() => setState(() {}));
    switchFlashSaleValue = false;
    percentageDiscountTextController ??= TextEditingController();
    percentageDiscountFocusNode ??= FocusNode();
    percentageDiscountFocusNode!.addListener(() => setState(() {}));
    percentageDiscountMask = MaskTextInputFormatter(mask: '##');
    dollarDiscountTextController ??= TextEditingController();
    dollarDiscountFocusNode ??= FocusNode();
    dollarDiscountFocusNode!.addListener(() => setState(() {}));
    flatShippingCostTextController ??= TextEditingController();
    flatShippingCostFocusNode ??= FocusNode();
    flatShippingCostFocusNode!.addListener(() => setState(() {}));
    additionalItemFeeTextController ??= TextEditingController();
    additionalItemFeeFocusNode ??= FocusNode();
    additionalItemFeeFocusNode!.addListener(() => setState(() {}));
    descTextController ??= TextEditingController();
    descFocusNode ??= FocusNode();
    descFocusNode!.addListener(() => setState(() {}));
    switchConventionSettingsValue = false;
  }

  @override
  void dispose() {
    titleTextController?.dispose();
    titleFocusNode?.dispose();
    skuPrefixTextController?.dispose();
    skuPrefixFocusNode?.dispose();
    skuNumberTextController?.dispose();
    skuNumberFocusNode?.dispose();
    quantityTextController?.dispose();
    quantityFocusNode?.dispose();
    yearTextController?.dispose();
    yearFocusNode?.dispose();
    issueTextController?.dispose();
    issueFocusNode?.dispose();
    priceTextController?.dispose();
    priceFocusNode?.dispose();
    percentageDiscountTextController?.dispose();
    percentageDiscountFocusNode?.dispose();
    dollarDiscountTextController?.dispose();
    dollarDiscountFocusNode?.dispose();
    flatShippingCostTextController?.dispose();
    flatShippingCostFocusNode?.dispose();
    additionalItemFeeTextController?.dispose();
    additionalItemFeeFocusNode?.dispose();
    descTextController?.dispose();
    descFocusNode?.dispose();
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
                  icon: Icon(
                    Icons.arrow_back,
                    color: AppColors.info,
                    size: 24.0,
                  ),
                  iconSize: 40.0,
                  onPressed: () async {
                    context.pop();
                  },
                ),
                Text(
                  widget.productId != null && widget.productId != ''
                      ? 'Edit Product'
                      : 'Add a Product',
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0,
                      color: AppColors.textPrimary),
                ),
                IconButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: AppColors.info,
                    size: 20.0,
                  ),
                  iconSize: 40.0,
                  onPressed: () {},
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                  child: Text(
                    'Product Photos',
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0,
                        color: AppColors.textPrimary),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            final remaining = 10 - uploadedImages.length;
                            if (remaining <= 0) {
                              await actions.toastificationshow(
                                context,
                                'Up to 10 images',
                                'Limit',
                                'warning',
                              );
                              return;
                            }
                            final selectedMedia =
                                await selectMediaWithSourceBottomSheet(
                              context: context,
                              imageQuality: 80,
                              allowPhoto: true,
                            );
                            if (selectedMedia != null &&
                                selectedMedia.every((m) => validateFileFormat(
                                    m.storagePath, context))) {
                              setState(() =>
                                  isDataUploading_uploadDataEdit = true);
                              try {
                                final selectedUploadedFiles = selectedMedia
                                    .map((m) => UploadedFile(
                                          name: m.storagePath.split('/').last,
                                          bytes: m.bytes,
                                          height: m.dimensions?.height,
                                          width: m.dimensions?.width,
                                          blurHash: m.blurHash,
                                          originalFilename: m.originalFilename,
                                        ))
                                    .take(remaining)
                                    .toList();
                                for (final file in selectedUploadedFiles) {
                                  if (file.bytes?.isNotEmpty ?? false) {
                                    addToUploadedImages(file);
                                  }
                                }
                                if (selectedUploadedFiles.length <
                                    selectedMedia.length) {
                                  await actions.toastificationshow(
                                    context,
                                    'Some photos were skipped (limit 10)',
                                    'Limit',
                                    'warning',
                                  );
                                }
                              } finally {
                                setState(() {
                                  isDataUploading_uploadDataEdit = false;
                                });
                              }
                            }
                          },
                          child: Container(
                            width: 112.0,
                            height: 112.0,
                            decoration: BoxDecoration(
                              color: AppColors.backgroundSecondary,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Align(
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: FaIcon(
                                FontAwesomeIcons.camera,
                                color: AppColors.textPrimary,
                                size: 20.0,
                              ),
                            ),
                          ),
                        ),
                        Builder(
                          builder: (context) {
                            final images = uploadedImages.toList();

                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children:
                                  List.generate(images.length, (imagesIndex) {
                                final imagesItem = images[imagesIndex];
                                return Container(
                                  width: 112.0,
                                  height: 112.0,
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.memory(
                                          imagesItem.bytes ??
                                              Uint8List.fromList([]),
                                          width: 112.0,
                                          height: 112.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Align(
                                        alignment:
                                            AlignmentDirectional(1.0, -1.0),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 8.0, 8.0, 0.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              removeFromUploadedImages(
                                                  imagesItem);
                                              setState(() {});
                                            },
                                            child: Container(
                                              width: 25.0,
                                              height: 25.0,
                                              decoration: BoxDecoration(
                                                color: Color(0x4C252525),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Align(
                                                alignment: AlignmentDirectional(
                                                    0.0, 0.0),
                                                child: Icon(
                                                  Icons.close,
                                                  color: AppColors.textPrimary,
                                                  size: 16.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).divide(SizedBox(width: 16.0)),
                            );
                          },
                        ),
                      ]
                          .divide(SizedBox(width: 16.0))
                          .addToStart(SizedBox(width: 16.0))
                          .addToEnd(SizedBox(width: 16.0)),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(16.0, 10.0, 16.0, 0.0),
                  child: Text(
                    'Add up to 10 photos. First photo will be the main image.',
                    style: GoogleFonts.inter(
                        fontSize: 12.0, color: AppColors.textSecondary),
                  ),
                ),
                Divider(
                  height: 32.0,
                  thickness: 1.0,
                  color: Color(0xFF363636),
                ),
                Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Basic Information',
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontSize: 18.0,
                              color: AppColors.textPrimary),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 16.0, 0.0, 0.0),
                          child: Text(
                            'Product Title',
                            style: GoogleFonts.inter(
                                fontSize: 15.0, color: AppColors.textPrimary),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 8.0, 0.0, 0.0),
                          child: Container(
                            width: double.infinity,
                            child: TextFormField(
                              controller: titleTextController,
                              focusNode: titleFocusNode,
                              onChanged: (_) => EasyDebounce.debounce(
                                'titleTextController',
                                Duration(milliseconds: 100),
                                () => setState(() {}),
                              ),
                              autofocus: false,
                              enabled: true,
                              obscureText: false,
                              decoration: InputDecoration(
                                isDense: false,
                                hintText: 'Enter product title',
                                hintStyle: GoogleFonts.inter(
                                    fontSize: 16.0,
                                    color: AppColors.textSecondary),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.neutral700,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      valueOrDefault<double>(
                                    AppConstants.radiusTextField4,
                                    0.0,
                                  )),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.secondary,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      valueOrDefault<double>(
                                    AppConstants.radiusTextField4,
                                    0.0,
                                  )),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.error,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      valueOrDefault<double>(
                                    AppConstants.radiusTextField4,
                                    0.0,
                                  )),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.error,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      valueOrDefault<double>(
                                    AppConstants.radiusTextField4,
                                    0.0,
                                  )),
                                ),
                              ),
                              style: GoogleFonts.inter(
                                  fontSize: 14.0, color: AppColors.textPrimary),
                              cursorColor: AppColors.textPrimary,
                              enableInteractiveSelection: true,
                              validator: null,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 16.0, 0.0, 0.0),
                          child: Text(
                            'Category',
                            style: GoogleFonts.inter(
                                fontSize: 15.0, color: AppColors.textPrimary),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 8.0, 0.0, 0.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              await showModalBottomSheet(
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                isDismissible: false,
                                enableDrag: false,
                                useSafeArea: true,
                                context: context,
                                builder: (context) {
                                  return WebViewAware(
                                    child: GestureDetector(
                                      onTap: () {
                                        FocusScope.of(context).unfocus();
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                      },
                                      child: Padding(
                                        padding:
                                            MediaQuery.viewInsetsOf(context),
                                        child:
                                            HomeDashoardInventoryAddCategoryWidget(
                                          category: category,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ).then((value) {
                                if (value == null) return;
                                setState(() {
                                  // Reset subcategory when category changes
                                  if (category?.id != value.id) {
                                    subcategory = null;
                                  }
                                  category = value;
                                });
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              height: 52.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    valueOrDefault<double>(
                                  AppConstants.radiusTextField4,
                                  0.0,
                                )),
                                border: Border.all(
                                  color: AppColors.neutral700,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    8.0, 12.0, 8.0, 12.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        valueOrDefault<String>(
                                          category != null
                                              ? category?.name
                                              : 'Select category',
                                          'Select category',
                                        ),
                                        style: GoogleFonts.inter(
                                            fontSize: 16.0,
                                            color: AppColors.textPrimary),
                                      ),
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_down_outlined,
                                      color: AppColors.textPrimary,
                                      size: 24.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 16.0, 0.0, 0.0),
                          child: Text(
                            'Subcategory',
                            style: GoogleFonts.inter(
                                fontSize: 15.0, color: AppColors.textPrimary),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 8.0, 0.0, 0.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              if (category != null) {
                                await showModalBottomSheet(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  isDismissible: false,
                                  enableDrag: false,
                                  useSafeArea: true,
                                  context: context,
                                  builder: (context) {
                                    return WebViewAware(
                                      child: GestureDetector(
                                        onTap: () {
                                          FocusScope.of(context).unfocus();
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                        },
                                        child: Padding(
                                          padding:
                                              MediaQuery.viewInsetsOf(context),
                                          child:
                                              HomeDashoardInventoryAddSubCategoryWidget(
                                            categoryRow: category!,
                                            subcategories: subcategory,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ).then((value) {
                                  if (value == null) return;
                                  setState(() {
                                    subcategory = value;
                                  });
                                });
                              } else {
                                await actions.toastificationshow(
                                  context,
                                  'Choose Category First',
                                  'Category should be choosen ',
                                  'warning',
                                );
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              height: 52.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    valueOrDefault<double>(
                                  AppConstants.radiusTextField4,
                                  0.0,
                                )),
                                border: Border.all(
                                  color: AppColors.neutral700,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    8.0, 12.0, 8.0, 12.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        valueOrDefault<String>(
                                          subcategory != null
                                              ? subcategory?.name
                                              : 'Select subcategory',
                                          'Select subcategory',
                                        ),
                                        style: GoogleFonts.inter(
                                            fontSize: 16.0,
                                            color: AppColors.textPrimary),
                                      ),
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_down_outlined,
                                      color: AppColors.textPrimary,
                                      size: 24.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 16.0, 0.0, 0.0),
                          child: Text(
                            'SKU',
                            style: GoogleFonts.inter(
                                fontSize: 15.0, color: AppColors.textPrimary),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 8.0, 0.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  child: TextFormField(
                                    controller: skuPrefixTextController,
                                    focusNode: skuPrefixFocusNode,
                                    onChanged: (_) => EasyDebounce.debounce(
                                      'skuPrefixTextController',
                                      Duration(milliseconds: 100),
                                      () async {
                                        getNextSkuNumber =
                                            await actions.getNextSkuNumber(
                                          skuPrefixTextController?.text ?? '',
                                          widget.productId,
                                        );
                                        setState(() {
                                          skuNumberTextController?.text =
                                              (getNextSkuNumber is Map
                                                      ? getNextSkuNumber[
                                                          'nextNumber']
                                                      : null)
                                                  .toString();
                                        });

                                        setState(() {});
                                      },
                                    ),
                                    autofocus: false,
                                    enabled: true,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      isDense: false,
                                      hintText: 'Enter Prefix',
                                      hintStyle: GoogleFonts.inter(
                                          fontSize: 16.0,
                                          color: AppColors.textSecondary),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.neutral700,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            valueOrDefault<double>(
                                          AppConstants.radiusTextField4,
                                          0.0,
                                        )),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.secondary,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            valueOrDefault<double>(
                                          AppConstants.radiusTextField4,
                                          0.0,
                                        )),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.error,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            valueOrDefault<double>(
                                          AppConstants.radiusTextField4,
                                          0.0,
                                        )),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.error,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            valueOrDefault<double>(
                                          AppConstants.radiusTextField4,
                                          0.0,
                                        )),
                                      ),
                                    ),
                                    style: GoogleFonts.inter(
                                        fontSize: 14.0,
                                        color: AppColors.textPrimary),
                                    cursorColor: AppColors.textPrimary,
                                    enableInteractiveSelection: true,
                                    validator: null,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  child: TextFormField(
                                    controller: skuNumberTextController,
                                    focusNode: skuNumberFocusNode,
                                    onChanged: (_) => EasyDebounce.debounce(
                                      'skuNumberTextController',
                                      Duration(milliseconds: 100),
                                      () => setState(() {}),
                                    ),
                                    autofocus: false,
                                    enabled: true,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      isDense: false,
                                      hintText: 'SKU number',
                                      hintStyle: GoogleFonts.inter(
                                          fontSize: 16.0,
                                          color: AppColors.textSecondary),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.neutral700,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            valueOrDefault<double>(
                                          AppConstants.radiusTextField4,
                                          0.0,
                                        )),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.secondary,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            valueOrDefault<double>(
                                          AppConstants.radiusTextField4,
                                          0.0,
                                        )),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.error,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            valueOrDefault<double>(
                                          AppConstants.radiusTextField4,
                                          0.0,
                                        )),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.error,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            valueOrDefault<double>(
                                          AppConstants.radiusTextField4,
                                          0.0,
                                        )),
                                      ),
                                    ),
                                    style: GoogleFonts.inter(
                                        fontSize: 14.0,
                                        color: AppColors.textPrimary),
                                    keyboardType: TextInputType.number,
                                    cursorColor: AppColors.textPrimary,
                                    enableInteractiveSelection: true,
                                    validator: null,
                                  ),
                                ),
                              ),
                            ].divide(SizedBox(width: 12.0)),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 16.0, 0.0, 0.0),
                          child: Text(
                            'Quantity',
                            style: GoogleFonts.inter(
                                fontSize: 15.0, color: AppColors.textPrimary),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 8.0, 0.0, 0.0),
                          child: Container(
                            width: double.infinity,
                            child: TextFormField(
                              controller: quantityTextController,
                              focusNode: quantityFocusNode,
                              onChanged: (_) => EasyDebounce.debounce(
                                'quantityTextController',
                                Duration(milliseconds: 100),
                                () => setState(() {}),
                              ),
                              autofocus: false,
                              enabled: true,
                              obscureText: false,
                              decoration: InputDecoration(
                                isDense: false,
                                hintText: 'Enter quantity',
                                hintStyle: GoogleFonts.inter(
                                    fontSize: 16.0,
                                    color: AppColors.textSecondary),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.neutral700,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      valueOrDefault<double>(
                                    AppConstants.radiusTextField4,
                                    0.0,
                                  )),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.secondary,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      valueOrDefault<double>(
                                    AppConstants.radiusTextField4,
                                    0.0,
                                  )),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.error,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      valueOrDefault<double>(
                                    AppConstants.radiusTextField4,
                                    0.0,
                                  )),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.error,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      valueOrDefault<double>(
                                    AppConstants.radiusTextField4,
                                    0.0,
                                  )),
                                ),
                              ),
                              style: GoogleFonts.inter(
                                  fontSize: 14.0, color: AppColors.textPrimary),
                              keyboardType: TextInputType.number,
                              cursorColor: AppColors.textPrimary,
                              enableInteractiveSelection: true,
                              validator: null,
                              inputFormatters: [quantityMask],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 16.0, 0.0, 0.0),
                          child: Text(
                            'Condition',
                            style: GoogleFonts.inter(
                                fontSize: 15.0, color: AppColors.textPrimary),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 8.0, 0.0, 0.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              await showModalBottomSheet(
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                isDismissible: false,
                                enableDrag: false,
                                useSafeArea: true,
                                context: context,
                                builder: (context) {
                                  return WebViewAware(
                                    child: GestureDetector(
                                      onTap: () {
                                        FocusScope.of(context).unfocus();
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                      },
                                      child: Padding(
                                        padding:
                                            MediaQuery.viewInsetsOf(context),
                                        child:
                                            HomeDashoardInventoryAddConditionWidget(
                                          conditionsList: conditionsList,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ).then((value) {
                                if (value == null) return;
                                setState(() {
                                  conditionsList = List<ConditionsRow>.from(value);
                                });
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              height: 52.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    valueOrDefault<double>(
                                  AppConstants.radiusTextField4,
                                  0.0,
                                )),
                                border: Border.all(
                                  color: AppColors.neutral700,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    8.0, 12.0, 8.0, 12.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Builder(
                                        builder: (context) {
                                          if (conditionsList.isNotEmpty) {
                                            return Builder(
                                              builder: (context) {
                                                final conditions =
                                                    conditionsList.toList();

                                                return Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: List.generate(
                                                      conditions.length,
                                                      (conditionsIndex) {
                                                    final conditionsItem =
                                                        conditions[
                                                            conditionsIndex];
                                                    return Text(
                                                      '${conditionsItem.name}${conditionsIndex == (conditionsList.length - 1) ? '' : ', '}',
                                                      style: GoogleFonts.inter(
                                                          fontSize: 16.0,
                                                          color: AppColors
                                                              .textPrimary),
                                                    );
                                                  }),
                                                );
                                              },
                                            );
                                          } else {
                                            return Text(
                                              'Select condition',
                                              style: GoogleFonts.inter(
                                                  fontSize: 16.0,
                                                  color: AppColors.textPrimary),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_down_outlined,
                                      color: AppColors.textPrimary,
                                      size: 24.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 16.0, 0.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Year (Optional)',
                                      style: GoogleFonts.inter(
                                          fontSize: 15.0,
                                          color: AppColors.textPrimary),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      child: TextFormField(
                                        controller: yearTextController,
                                        focusNode: yearFocusNode,
                                        onChanged: (_) => EasyDebounce.debounce(
                                          'yearTextController',
                                          Duration(milliseconds: 100),
                                          () => setState(() {}),
                                        ),
                                        autofocus: false,
                                        enabled: true,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          isDense: false,
                                          hintText: 'Enter year',
                                          hintStyle: GoogleFonts.inter(
                                              fontSize: 16.0,
                                              color: AppColors.textSecondary),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: AppColors.neutral700,
                                              width: 1.0,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                valueOrDefault<double>(
                                              AppConstants.radiusTextField4,
                                              0.0,
                                            )),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: AppColors.secondary,
                                              width: 1.0,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                valueOrDefault<double>(
                                              AppConstants.radiusTextField4,
                                              0.0,
                                            )),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: AppColors.error,
                                              width: 1.0,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                valueOrDefault<double>(
                                              AppConstants.radiusTextField4,
                                              0.0,
                                            )),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: AppColors.error,
                                              width: 1.0,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                valueOrDefault<double>(
                                              AppConstants.radiusTextField4,
                                              0.0,
                                            )),
                                          ),
                                        ),
                                        style: GoogleFonts.inter(
                                            fontSize: 14.0,
                                            color: AppColors.textPrimary),
                                        keyboardType: TextInputType.number,
                                        cursorColor: AppColors.textPrimary,
                                        enableInteractiveSelection: true,
                                        validator: null,
                                        inputFormatters: [yearMask],
                                      ),
                                    ),
                                  ].divide(SizedBox(height: 8.0)),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Issue # (Optional)',
                                      style: GoogleFonts.inter(
                                          fontSize: 15.0,
                                          color: AppColors.textPrimary),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      child: TextFormField(
                                        controller: issueTextController,
                                        focusNode: issueFocusNode,
                                        onChanged: (_) => EasyDebounce.debounce(
                                          'issueTextController',
                                          Duration(milliseconds: 100),
                                          () => setState(() {}),
                                        ),
                                        autofocus: false,
                                        enabled: true,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          isDense: false,
                                          hintText: 'Enter issue #',
                                          hintStyle: GoogleFonts.inter(
                                              fontSize: 16.0,
                                              color: AppColors.textSecondary),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: AppColors.neutral700,
                                              width: 1.0,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                valueOrDefault<double>(
                                              AppConstants.radiusTextField4,
                                              0.0,
                                            )),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: AppColors.secondary,
                                              width: 1.0,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                valueOrDefault<double>(
                                              AppConstants.radiusTextField4,
                                              0.0,
                                            )),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: AppColors.error,
                                              width: 1.0,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                valueOrDefault<double>(
                                              AppConstants.radiusTextField4,
                                              0.0,
                                            )),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: AppColors.error,
                                              width: 1.0,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                valueOrDefault<double>(
                                              AppConstants.radiusTextField4,
                                              0.0,
                                            )),
                                          ),
                                        ),
                                        style: GoogleFonts.inter(
                                            fontSize: 14.0,
                                            color: AppColors.textPrimary),
                                        keyboardType: TextInputType.number,
                                        cursorColor: AppColors.textPrimary,
                                        enableInteractiveSelection: true,
                                        validator: null,
                                        inputFormatters: [issueMask],
                                      ),
                                    ),
                                  ].divide(SizedBox(height: 8.0)),
                                ),
                              ),
                            ].divide(SizedBox(width: 12.0)),
                          ),
                        ),
                        Divider(
                          height: 48.0,
                          thickness: 1.0,
                          color: Color(0xFF363636),
                        ),
                        Text(
                          'Pricing',
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontSize: 18.0,
                              color: AppColors.textPrimary),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 16.0, 0.0, 0.0),
                          child: Text(
                            'Price',
                            style: GoogleFonts.inter(
                                fontSize: 15.0, color: AppColors.textPrimary),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 8.0, 0.0, 0.0),
                          child: Container(
                            width: double.infinity,
                            child: TextFormField(
                              controller: priceTextController,
                              focusNode: priceFocusNode,
                              onChanged: (_) => EasyDebounce.debounce(
                                'priceTextController',
                                Duration(milliseconds: 100),
                                () => setState(() {}),
                              ),
                              autofocus: false,
                              enabled: true,
                              obscureText: false,
                              decoration: InputDecoration(
                                isDense: false,
                                prefix: Text(
                                  '\$ ',
                                  style: GoogleFonts.inter(
                                      fontSize: 16.0,
                                      color: AppColors.textPrimary),
                                ),
                                hintText: '0.00',
                                hintStyle: GoogleFonts.inter(
                                    fontSize: 16.0,
                                    color: AppColors.textSecondary),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.neutral700,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      valueOrDefault<double>(
                                    AppConstants.radiusTextField4,
                                    0.0,
                                  )),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.secondary,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      valueOrDefault<double>(
                                    AppConstants.radiusTextField4,
                                    0.0,
                                  )),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.error,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      valueOrDefault<double>(
                                    AppConstants.radiusTextField4,
                                    0.0,
                                  )),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.error,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      valueOrDefault<double>(
                                    AppConstants.radiusTextField4,
                                    0.0,
                                  )),
                                ),
                              ),
                              style: GoogleFonts.inter(
                                  fontSize: 14.0, color: AppColors.textPrimary),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              cursorColor: AppColors.textPrimary,
                              enableInteractiveSelection: true,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*[.,]?\d{0,2}')),
                              ],
                              validator: null,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 16.0, 0.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      'Flash Sale',
                                      style: GoogleFonts.inter(
                                          fontSize: 15.0,
                                          color: AppColors.textPrimary),
                                    ),
                                    if (switchFlashSaleValue ?? true)
                                      AppDropDown<int>(
                                        controller:
                                            flashDropDownValueController ??=
                                                FormFieldController<int>(
                                          flashDropDownValue ??= 1,
                                        ),
                                        options: List<int>.from([1, 20, 24]),
                                        optionLabels: [
                                          '1 hour',
                                          '20 hours',
                                          '24 hours'
                                        ],
                                        onChanged: (val) => setState(
                                            () => flashDropDownValue = val),
                                        width: 115.0,
                                        height: 50.0,
                                        textStyle: GoogleFonts.inter(
                                            fontSize: 14.0,
                                            color: AppColors.textPrimary),
                                        hintText: '20 hours',
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
                                  ].divide(SizedBox(width: 8.0)),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(1.0, 0.0),
                                child: Switch.adaptive(
                                  value: switchFlashSaleValue!,
                                  onChanged: (newValue) async {
                                    setState(
                                        () => switchFlashSaleValue = newValue);
                                  },
                                  activeColor: AppColors.primary,
                                  activeTrackColor: AppColors.primary,
                                  inactiveTrackColor: AppColors.alternate,
                                  inactiveThumbColor:
                                      AppColors.backgroundSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (switchFlashSaleValue ?? true)
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 16.0, 0.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Amount',
                                        style: GoogleFonts.inter(
                                            fontSize: 15.0,
                                            color: AppColors.textPrimary),
                                      ),
                                      Builder(
                                        builder: (context) {
                                          if (discount == 'percentage') {
                                            return Container(
                                              width: double.infinity,
                                              child: TextFormField(
                                                controller:
                                                    percentageDiscountTextController,
                                                focusNode:
                                                    percentageDiscountFocusNode,
                                                onChanged: (_) =>
                                                    EasyDebounce.debounce(
                                                  'percentageDiscountTextController',
                                                  Duration(milliseconds: 100),
                                                  () => setState(() {}),
                                                ),
                                                autofocus: false,
                                                enabled: true,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  isDense: false,
                                                  prefix: Text(
                                                    '% ',
                                                    style: GoogleFonts.inter(
                                                        fontSize: 16.0,
                                                        color: AppColors
                                                            .textPrimary),
                                                  ),
                                                  hintText: '0',
                                                  hintStyle: GoogleFonts.inter(
                                                      fontSize: 16.0,
                                                      color: AppColors
                                                          .textSecondary),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          AppColors.neutral700,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            valueOrDefault<
                                                                double>(
                                                      AppConstants
                                                          .radiusTextField4,
                                                      0.0,
                                                    )),
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
                                                            valueOrDefault<
                                                                double>(
                                                      AppConstants
                                                          .radiusTextField4,
                                                      0.0,
                                                    )),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: AppColors.error,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            valueOrDefault<
                                                                double>(
                                                      AppConstants
                                                          .radiusTextField4,
                                                      0.0,
                                                    )),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: AppColors.error,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            valueOrDefault<
                                                                double>(
                                                      AppConstants
                                                          .radiusTextField4,
                                                      0.0,
                                                    )),
                                                  ),
                                                ),
                                                style: GoogleFonts.inter(
                                                    fontSize: 14.0,
                                                    color:
                                                        AppColors.textPrimary),
                                                keyboardType:
                                                    TextInputType.number,
                                                cursorColor:
                                                    AppColors.textPrimary,
                                                enableInteractiveSelection:
                                                    true,
                                                validator: null,
                                                inputFormatters: [
                                                  percentageDiscountMask
                                                ],
                                              ),
                                            );
                                          } else {
                                            return Container(
                                              width: double.infinity,
                                              child: TextFormField(
                                                controller:
                                                    dollarDiscountTextController,
                                                focusNode:
                                                    dollarDiscountFocusNode,
                                                onChanged: (_) =>
                                                    EasyDebounce.debounce(
                                                  'dollarDiscountTextController',
                                                  Duration(milliseconds: 100),
                                                  () => setState(() {}),
                                                ),
                                                autofocus: false,
                                                enabled: true,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  isDense: false,
                                                  prefix: Text(
                                                    '\$ ',
                                                    style: GoogleFonts.inter(
                                                        fontSize: 16.0,
                                                        color: AppColors
                                                            .textPrimary),
                                                  ),
                                                  hintText: '0.00',
                                                  hintStyle: GoogleFonts.inter(
                                                      fontSize: 16.0,
                                                      color: AppColors
                                                          .textSecondary),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          AppColors.neutral700,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            valueOrDefault<
                                                                double>(
                                                      AppConstants
                                                          .radiusTextField4,
                                                      0.0,
                                                    )),
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
                                                            valueOrDefault<
                                                                double>(
                                                      AppConstants
                                                          .radiusTextField4,
                                                      0.0,
                                                    )),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: AppColors.error,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            valueOrDefault<
                                                                double>(
                                                      AppConstants
                                                          .radiusTextField4,
                                                      0.0,
                                                    )),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: AppColors.error,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            valueOrDefault<
                                                                double>(
                                                      AppConstants
                                                          .radiusTextField4,
                                                      0.0,
                                                    )),
                                                  ),
                                                ),
                                                style: GoogleFonts.inter(
                                                    fontSize: 14.0,
                                                    color:
                                                        AppColors.textPrimary),
                                                keyboardType:
                                                    const TextInputType
                                                        .numberWithOptions(
                                                        decimal: true),
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
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                discount = 'percentage';
                                                setState(() {});
                                              },
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  if (discount != 'percentage')
                                                    Icon(
                                                      Icons.circle_outlined,
                                                      color: AppColors
                                                          .textSecondary,
                                                      size: 20.0,
                                                    ),
                                                  if (discount == 'percentage')
                                                    Icon(
                                                      Icons
                                                          .radio_button_checked_rounded,
                                                      color: AppColors.primary,
                                                      size: 20.0,
                                                    ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  8.0,
                                                                  0.0,
                                                                  8.0),
                                                      child: Text(
                                                        'Percentage Discount',
                                                        style: GoogleFonts.inter(
                                                            fontSize: 15.0,
                                                            color: AppColors
                                                                .textPrimary),
                                                      ),
                                                    ),
                                                  ),
                                                ].divide(SizedBox(width: 12.0)),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                discount = 'dollar';
                                                setState(() {});
                                              },
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  if (discount != 'dollar')
                                                    Icon(
                                                      Icons.circle_outlined,
                                                      color: AppColors
                                                          .textSecondary,
                                                      size: 20.0,
                                                    ),
                                                  if (discount == 'dollar')
                                                    Icon(
                                                      Icons
                                                          .radio_button_checked_rounded,
                                                      color: AppColors.primary,
                                                      size: 20.0,
                                                    ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  8.0,
                                                                  0.0,
                                                                  8.0),
                                                      child: Text(
                                                        'Dollar Discount',
                                                        style: GoogleFonts.inter(
                                                            fontSize: 15.0,
                                                            color: AppColors
                                                                .textPrimary),
                                                      ),
                                                    ),
                                                  ),
                                                ].divide(SizedBox(width: 12.0)),
                                              ),
                                            ),
                                          ),
                                        ].divide(SizedBox(width: 24.0)),
                                      ),
                                    ].divide(SizedBox(height: 8.0)),
                                  ),
                                ),
                              ].divide(SizedBox(width: 12.0)),
                            ),
                          ),
                        Divider(
                          height: 48.0,
                          thickness: 1.0,
                          color: Color(0xFF363636),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 8.0),
                          child: Text(
                            'Shipping Cost',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 18.0,
                                color: AppColors.textPrimary),
                          ),
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            shippingCost = 'Use Seller Default Shipping Rule';
                            setState(() {});
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              if (shippingCost !=
                                  'Use Seller Default Shipping Rule')
                                Icon(
                                  Icons.circle_outlined,
                                  color: AppColors.textSecondary,
                                  size: 20.0,
                                ),
                              if (shippingCost ==
                                  'Use Seller Default Shipping Rule')
                                Icon(
                                  Icons.radio_button_checked_rounded,
                                  color: AppColors.primary,
                                  size: 20.0,
                                ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 8.0, 0.0, 8.0),
                                  child: Text(
                                    'Use Seller Default Shipping Rule',
                                    style: GoogleFonts.inter(
                                        fontSize: 15.0,
                                        color: AppColors.textPrimary),
                                  ),
                                ),
                              ),
                            ].divide(SizedBox(width: 12.0)),
                          ),
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            shippingCost =
                                'Set Custom Shipping For This Product';
                            setState(() {});
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              if (shippingCost !=
                                  'Set Custom Shipping For This Product')
                                Icon(
                                  Icons.circle_outlined,
                                  color: AppColors.textSecondary,
                                  size: 20.0,
                                ),
                              if (shippingCost ==
                                  'Set Custom Shipping For This Product')
                                Icon(
                                  Icons.radio_button_checked_rounded,
                                  color: AppColors.primary,
                                  size: 20.0,
                                ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 8.0, 0.0, 8.0),
                                  child: Text(
                                    'Set Custom Shipping For This Product',
                                    style: GoogleFonts.inter(
                                        fontSize: 15.0,
                                        color: AppColors.textPrimary),
                                  ),
                                ),
                              ),
                            ].divide(SizedBox(width: 12.0)),
                          ),
                        ),
                        if (shippingCost ==
                            'Set Custom Shipping For This Product')
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 16.0, 0.0, 0.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Flat Shipping Cost',
                                  style: GoogleFonts.inter(
                                      fontSize: 15.0,
                                      color: AppColors.textPrimary),
                                ),
                                Container(
                                  width: double.infinity,
                                  child: TextFormField(
                                    controller: flatShippingCostTextController,
                                    focusNode: flatShippingCostFocusNode,
                                    onChanged: (_) => EasyDebounce.debounce(
                                      'flatShippingCostTextController',
                                      Duration(milliseconds: 100),
                                      () => setState(() {}),
                                    ),
                                    autofocus: false,
                                    enabled: true,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      isDense: false,
                                      prefix: Text(
                                        '\$ ',
                                        style: GoogleFonts.inter(
                                            fontSize: 16.0,
                                            color: AppColors.textPrimary),
                                      ),
                                      hintText: '0.00',
                                      hintStyle: GoogleFonts.inter(
                                          fontSize: 16.0,
                                          color: AppColors.textSecondary),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.neutral700,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            valueOrDefault<double>(
                                          AppConstants.radiusTextField4,
                                          0.0,
                                        )),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.secondary,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            valueOrDefault<double>(
                                          AppConstants.radiusTextField4,
                                          0.0,
                                        )),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.error,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            valueOrDefault<double>(
                                          AppConstants.radiusTextField4,
                                          0.0,
                                        )),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.error,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            valueOrDefault<double>(
                                          AppConstants.radiusTextField4,
                                          0.0,
                                        )),
                                      ),
                                    ),
                                    style: GoogleFonts.inter(
                                        fontSize: 14.0,
                                        color: AppColors.textPrimary),
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                    cursorColor: AppColors.textPrimary,
                                    enableInteractiveSelection: true,
                                    validator: null,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 4.0, 0.0, 0.0),
                                  child: Text(
                                    'Additional Item Fee',
                                    style: GoogleFonts.inter(
                                        fontSize: 15.0,
                                        color: AppColors.textPrimary),
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  child: TextFormField(
                                    controller: additionalItemFeeTextController,
                                    focusNode: additionalItemFeeFocusNode,
                                    onChanged: (_) => EasyDebounce.debounce(
                                      'additionalItemFeeTextController',
                                      Duration(milliseconds: 100),
                                      () => setState(() {}),
                                    ),
                                    autofocus: false,
                                    enabled: true,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      isDense: false,
                                      prefix: Text(
                                        '\$ ',
                                        style: GoogleFonts.inter(
                                            fontSize: 16.0,
                                            color: AppColors.textPrimary),
                                      ),
                                      hintText: '0.00',
                                      hintStyle: GoogleFonts.inter(
                                          fontSize: 16.0,
                                          color: AppColors.textSecondary),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.neutral700,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            valueOrDefault<double>(
                                          AppConstants.radiusTextField4,
                                          0.0,
                                        )),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.secondary,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            valueOrDefault<double>(
                                          AppConstants.radiusTextField4,
                                          0.0,
                                        )),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.error,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            valueOrDefault<double>(
                                          AppConstants.radiusTextField4,
                                          0.0,
                                        )),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.error,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            valueOrDefault<double>(
                                          AppConstants.radiusTextField4,
                                          0.0,
                                        )),
                                      ),
                                    ),
                                    style: GoogleFonts.inter(
                                        fontSize: 14.0,
                                        color: AppColors.textPrimary),
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                    cursorColor: AppColors.textPrimary,
                                    enableInteractiveSelection: true,
                                    validator: null,
                                  ),
                                ),
                              ].divide(SizedBox(height: 8.0)),
                            ),
                          ),
                        Divider(
                          height: 48.0,
                          thickness: 1.0,
                          color: Color(0xFF363636),
                        ),
                        Text(
                          'Description',
                          style: GoogleFonts.inter(
                              fontSize: 15.0, color: AppColors.textPrimary),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 8.0, 0.0, 0.0),
                          child: Container(
                            width: double.infinity,
                            child: TextFormField(
                              controller: descTextController,
                              focusNode: descFocusNode,
                              onChanged: (_) => EasyDebounce.debounce(
                                'descTextController',
                                Duration(milliseconds: 100),
                                () => setState(() {}),
                              ),
                              autofocus: false,
                              enabled: true,
                              obscureText: false,
                              decoration: InputDecoration(
                                isDense: false,
                                hintText: 'Describe your item in detail',
                                hintStyle: GoogleFonts.inter(
                                    fontSize: 16.0,
                                    color: AppColors.textSecondary),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.neutral700,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      valueOrDefault<double>(
                                    AppConstants.radiusTextField4,
                                    0.0,
                                  )),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.secondary,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      valueOrDefault<double>(
                                    AppConstants.radiusTextField4,
                                    0.0,
                                  )),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.error,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      valueOrDefault<double>(
                                    AppConstants.radiusTextField4,
                                    0.0,
                                  )),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.error,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      valueOrDefault<double>(
                                    AppConstants.radiusTextField4,
                                    0.0,
                                  )),
                                ),
                              ),
                              style: GoogleFonts.inter(
                                  fontSize: 14.0, color: AppColors.textPrimary),
                              maxLines: 10,
                              minLines: 4,
                              maxLength: 500,
                              maxLengthEnforcement:
                                  MaxLengthEnforcement.enforced,
                              buildCounter: (context,
                                      {required currentLength,
                                      required isFocused,
                                      maxLength}) =>
                                  null,
                              cursorColor: AppColors.textPrimary,
                              enableInteractiveSelection: true,
                              validator: null,
                            ),
                          ),
                        ),
                        Divider(
                          height: 48.0,
                          thickness: 1.0,
                          color: Color(0xFF363636),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Add Product Tags',
                              style: GoogleFonts.inter(
                                  fontSize: 15.0, color: AppColors.textPrimary),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 8.0, 0.0, 0.0),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  final result = await Navigator.push<List<Tag>>(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => HomeDashoardInventoryAddTagsWidget(
                                        initialTags: choosenTags,
                                      ),
                                    ),
                                  );
                                  if (result != null) {
                                    setState(() {
                                      choosenTags = result;
                                    });
                                  }
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 48.0,
                                  decoration: BoxDecoration(
                                    color: AppColors.backgroundSecondary,
                                    borderRadius: BorderRadius.circular(
                                        valueOrDefault<double>(
                                      AppConstants.radiusTextField4,
                                      0.0,
                                    )),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8.0, 12.0, 8.0, 12.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Add Tags',
                                            style: GoogleFonts.inter(
                                                fontSize: 16.0,
                                                color: AppColors.textPrimary),
                                          ),
                                        ),
                                        Icon(
                                          Icons.keyboard_arrow_down_outlined,
                                          color: AppColors.textPrimary,
                                          size: 24.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 16.0, 0.0, 0.0),
                          child: Builder(
                            builder: (context) {
                              final tags = choosenTags.toList();

                              return InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  shippingCost =
                                      'Use Seller Default Shipping Rule';
                                  setState(() {});
                                },
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children:
                                        List.generate(tags.length, (tagsIndex) {
                                      final tagsItem = tags[tagsIndex];
                                      return InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          choosenTags.remove(tagsItem);
                                          setState(() {});
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xFF252525),
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                          ),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    12.0, 2.0, 12.0, 4.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  tagsItem.name,
                                                  style: GoogleFonts.inter(
                                                      fontSize: 14.0,
                                                      color: AppColors
                                                          .textPrimary),
                                                ),
                                                Icon(
                                                  Icons.close,
                                                  color: AppColors.textPrimary,
                                                  size: 12.0,
                                                ),
                                              ].divide(SizedBox(width: 4.0)),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).divide(SizedBox(width: 12.0)),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Divider(
                          height: 48.0,
                          thickness: 1.0,
                          color: Color(0xFF363636),
                        ),
                        Container(
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
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 0.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.auto_awesome_outlined,
                                  size: 20.0,
                                  color: AppColors.textPrimary,
                                ),
                                SizedBox(width: 8.0),
                                Text(
                                  'AI Scan',
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.0,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          height: 48.0,
                          thickness: 1.0,
                          color: Color(0xFF363636),
                        ),
                        Text(
                          'Convention Settings',
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontSize: 18.0,
                              color: AppColors.textPrimary),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Text(
                                'Add to Convention Shortlist',
                                style: GoogleFonts.inter(
                                    fontSize: 15.0,
                                    color: AppColors.textPrimary),
                              ),
                            ),
                            Switch.adaptive(
                              value: switchConventionSettingsValue!,
                              onChanged: (newValue) async {
                                setState(() {
                                  switchConventionSettingsValue = newValue;
                                  if (!newValue) {
                                    dropDownValue = null;
                                    dropDownValueController?.reset();
                                  }
                                });
                              },
                              activeColor: AppColors.primary,
                              activeTrackColor: AppColors.primary,
                              inactiveTrackColor: AppColors.alternate,
                              inactiveThumbColor: AppColors.backgroundSecondary,
                            ),
                          ].divide(SizedBox(width: 8.0)),
                        ),
                        if (switchConventionSettingsValue ?? true)
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 8.0, 0.0, 0.0),
                            child: Text(
                              'Select Convention',
                              style: GoogleFonts.inter(
                                  fontSize: 15.0, color: AppColors.textPrimary),
                            ),
                          ),
                        if (switchConventionSettingsValue ?? true)
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 8.0, 0.0, 0.0),
                            child: AppDropDown<String>(
                              controller: dropDownValueController ??=
                                  FormFieldController<String>(null),
                              options: userShortlists.map((s) => s.id).toList(),
                              optionLabels: userShortlists.map((s) => s.name).toList(),
                              onChanged: (val) =>
                                  setState(() => dropDownValue = val),
                              width: double.infinity,
                              height: 50.0,
                              textStyle: GoogleFonts.inter(
                                  fontSize: 14.0, color: AppColors.textPrimary),
                              hintText: 'Select shortlist',
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
                          ),
                        Divider(
                          height: 48.0,
                          thickness: 1.0,
                          color: Color(0xFF363636),
                        ),
                        Container(
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
                          child: Builder(
                            builder: (context) => TextButton(
                              onPressed: () async {
                                createProduct = await actions.createProduct(
                                  widget.productId,
                                  titleTextController?.text ?? '',
                                  descTextController?.text ?? '',
                                  category?.id,
                                  subcategory?.id,
                                  skuPrefixTextController?.text ?? '',
                                  skuNumberTextController?.text ?? '',
                                  quantityTextController?.text ?? '',
                                  conditionsList.map((e) => e.id).toList(),
                                  yearTextController?.text ?? '',
                                  issueTextController?.text ?? '',
                                  priceTextController?.text ?? '',
                                  switchFlashSaleValue,
                                  flashDropDownValue,
                                  discount == 'percentage' ? true : false,
                                  discount == 'percentage'
                                      ? percentageDiscountTextController?.text ?? ''
                                      : dollarDiscountTextController?.text ?? '',
                                  choosenTags.map((e) => e.id).toList(),
                                  (switchConventionSettingsValue == true) ? dropDownValue : null,
                                  shippingCost ==
                                          'Use Seller Default Shipping Rule'
                                      ? true
                                      : false,
                                  flatShippingCostTextController?.text ?? '',
                                  additionalItemFeeTextController?.text ?? '',
                                  'active',
                                  uploadedImages.toList(),
                                );
                                if (createProduct is Map &&
                                    createProduct['success'] == true) {
                                  await showDialog(
                                    context: context,
                                    builder: (dialogContext) {
                                      return Dialog(
                                        elevation: 0,
                                        insetPadding: EdgeInsets.zero,
                                        backgroundColor: Colors.transparent,
                                        alignment:
                                            AlignmentDirectional(0.0, 0.0)
                                                .resolve(
                                                    Directionality.of(context)),
                                        child: WebViewAware(
                                          child: GestureDetector(
                                            onTap: () {
                                              FocusScope.of(dialogContext)
                                                  .unfocus();
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                            },
                                            child: DialogProductCreatedWidget(
                                              productId: (createProduct is Map
                                                      ? createProduct['productId']
                                                      : null)
                                                  .toString(),
                                              action: () async {
                                                Navigator.pop(context);
                                                if (Navigator.of(context)
                                                    .canPop()) {
                                                  context.pop();
                                                }
                                                context.pushNamed(
                                                    HomeDashoardInventoryAddWidget
                                                        .routeName);
                                              },
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  await actions.toastificationshow(
                                    context,
                                    (createProduct is Map
                                            ? createProduct['title']
                                            : null)
                                        .toString(),
                                    (createProduct is Map
                                            ? createProduct['message']
                                            : null)
                                        .toString(),
                                    'error',
                                  );
                                }

                                setState(() {});
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 0.0, 16.0, 0.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: Text(
                                'Save & Publish',
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17.0,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        if ((widget.productId != null &&
                                widget.productId != '') &&
                            (getProduct?.status != 'active'))
                          Builder(
                            builder: (context) => Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 16.0, 0.0, 0.0),
                              child: SizedBox(
                                width: double.infinity,
                                height: 56.0,
                                child: OutlinedButton(
                                  onPressed: () async {
                                    createProductAsDraft =
                                        await actions.createProduct(
                                      widget.productId,
                                      titleTextController?.text ?? '',
                                      descTextController?.text ?? '',
                                      category?.id,
                                      subcategory?.id,
                                      skuPrefixTextController?.text ?? '',
                                      skuNumberTextController?.text ?? '',
                                      quantityTextController?.text ?? '',
                                      conditionsList.map((e) => e.id).toList(),
                                      yearTextController?.text ?? '',
                                      issueTextController?.text ?? '',
                                      priceTextController?.text ?? '',
                                      switchFlashSaleValue,
                                      flashDropDownValue,
                                      discount == 'percentage' ? true : false,
                                      discount == 'percentage'
                                          ? percentageDiscountTextController?.text ?? ''
                                          : dollarDiscountTextController?.text ?? '',
                                      choosenTags.map((e) => e.id).toList(),
                                      (switchConventionSettingsValue == true) ? dropDownValue : null,
                                      shippingCost ==
                                              'Use Seller Default Shipping Rule'
                                          ? true
                                          : false,
                                      flatShippingCostTextController?.text ??
                                          '',
                                      additionalItemFeeTextController?.text ??
                                          '',
                                      'draft',
                                      uploadedImages.toList(),
                                    );
                                    if (createProductAsDraft is Map &&
                                        createProductAsDraft['success'] ==
                                            true) {
                                      await showDialog(
                                        context: context,
                                        builder: (dialogContext) {
                                          return Dialog(
                                            elevation: 0,
                                            insetPadding: EdgeInsets.zero,
                                            backgroundColor: Colors.transparent,
                                            alignment: AlignmentDirectional(
                                                    0.0, 0.0)
                                                .resolve(
                                                    Directionality.of(context)),
                                            child: WebViewAware(
                                              child: GestureDetector(
                                                onTap: () {
                                                  FocusScope.of(dialogContext)
                                                      .unfocus();
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                },
                                                child: DialogProductDraftWidget(
                                                  action: () async {
                                                    Navigator.pop(context);
                                                    if (Navigator.of(context)
                                                        .canPop()) {
                                                      context.pop();
                                                    }
                                                    context.pushNamed(
                                                        HomeDashoardInventoryAddWidget
                                                            .routeName);
                                                  },
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    } else {
                                      await actions.toastificationshow(
                                        context,
                                        (createProductAsDraft is Map
                                                ? createProductAsDraft['title']
                                                : null)
                                            .toString(),
                                        (createProductAsDraft is Map
                                                ? createProductAsDraft[
                                                    'message']
                                                : null)
                                            .toString(),
                                        'error',
                                      );
                                    }

                                    setState(() {});
                                  },
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor:
                                        AppColors.backgroundPrimary,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 0.0, 16.0, 0.0),
                                    side: BorderSide(
                                      color: Color(0xFF545454),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                  ),
                                  child: Text(
                                    'Save as Draft',
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17.0,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ]
                  .addToStart(SizedBox(height: 24.0))
                  .addToEnd(SizedBox(height: 24.0)),
            ),
          ),
        ),
      ),
    );
  }
}
