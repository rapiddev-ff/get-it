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
import '/core/widgets/app_gradient_button.dart';
import '/core/utils/value_utils.dart';
import '/core/widgets/app_drop_down.dart';
import '/core/widgets/form_field_controller.dart';
import '/core/utils/uploaded_file.dart';
import '/core/utils/upload_data.dart';
import '/core/widgets/dismiss_keyboard.dart';
import '/features/home/domain/models/product_details_model.dart';
import '/features/browse/domain/models/tag_model.dart';
import 'package:go_router/go_router.dart';
import '/features/home/presentation/pages/seller_dashboard/inventory_add_tags/home_dashoard_inventory_add_tags_widget.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import '/core/providers/current_user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class HomeDashoardInventoryAddWidget extends ConsumerStatefulWidget {
  const HomeDashoardInventoryAddWidget({
    super.key,
    this.productId,
  });

  final String? productId;

  static String routeName = 'homeDashoardInventoryAdd';
  static String routePath = 'homeDashoardInventoryAdd';

  @override
  ConsumerState<HomeDashoardInventoryAddWidget> createState() =>
      _HomeDashoardInventoryAddWidgetState();
}

class _HomeDashoardInventoryAddWidgetState
    extends ConsumerState<HomeDashoardInventoryAddWidget> {
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

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        Future(() async {
          tags = (await SupaFlow.client.rpc('get_all_tags') as List? ?? [])
              .map((e) => Tag.fromJson(Map<String, dynamic>.from(e)))
              .toList();
        }),
        Future(() async {
          userShortlists = await ShortlistsTable().queryRows(
            queryFn: (q) => q
                .eqOrNull('user_id', ref.read(currentUserIdProvider))
                .order('created_at', ascending: false),
          );
        }),
      ]);

      if (widget.productId != null && widget.productId != '') {
        await Future.wait([
          Future(() async {
            getProduct = await actions.getProductDetails(
                widget.productId!, ref.read(currentUserIdProvider));
          }),
        ]);
        titleTextController?.text = getProduct!.title;
        priceTextController?.text = getProduct!.price.toString();
        quantityTextController?.text = getProduct!.quantity.toString();
        yearTextController?.text = getProduct!.year?.toString() ?? '';
        issueTextController?.text = getProduct!.issueNumber?.toString() ?? '';
        descTextController?.text = getProduct!.description;
        shippingCost = getProduct!.useSellerShipping
            ? 'Use Seller Default Shipping Rule'
            : 'Set Custom Shipping For This Product';
        discount = getProduct!.discountType ?? 'percentage';
        switchFlashSaleValue = getProduct!.flashSaleEnabled;
        flashDropDownValue = null;
        if (getProduct!.discountType == 'percentage') {
          percentageDiscountTextController?.text =
              getProduct!.discountAmount?.toString() ?? '';
        } else {
          dollarDiscountTextController?.text =
              getProduct!.discountAmount?.toString() ?? '';
        }
        skuPrefixTextController?.text = getProduct!.sku ?? '';
        await Future.wait([
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
        if (getProduct?.shortlistId != null &&
            getProduct!.shortlistId!.isNotEmpty) {
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

  // ---------------------------------------------------------------------------
  // Shared helpers
  // ---------------------------------------------------------------------------

  static final _borderRadius = BorderRadius.circular(
    valueOrDefault<double>(AppConstants.radiusTextField4, 0.0),
  );

  InputDecoration _inputDecoration(String hint, {Widget? prefix}) {
    return InputDecoration(
      isDense: false,
      prefix: prefix,
      hintText: hint,
      hintStyle:
          GoogleFonts.inter(fontSize: 16.0, color: AppColors.textSecondary),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.neutral700, width: 1.0),
        borderRadius: _borderRadius,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.secondary, width: 1.0),
        borderRadius: _borderRadius,
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.error, width: 1.0),
        borderRadius: _borderRadius,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.error, width: 1.0),
        borderRadius: _borderRadius,
      ),
    );
  }

  static final _dollarPrefix = Text(
    '\$ ',
    style: GoogleFonts.inter(fontSize: 16.0, color: AppColors.textPrimary),
  );

  static final _percentPrefix = Text(
    '% ',
    style: GoogleFonts.inter(fontSize: 16.0, color: AppColors.textPrimary),
  );

  static final _textFieldStyle =
      GoogleFonts.inter(fontSize: 14.0, color: AppColors.textPrimary);

  static final _sectionDivider = Divider(
    height: 48.0,
    thickness: 1.0,
    color: Color(0xFF363636),
  );

  Widget _sectionTitle(String text) => Text(
        text,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500),
      );

  Widget _fieldLabel(String text) => Padding(
        padding: EdgeInsets.only(top: 16.0),
        child: Text(
          text,
          style:
              Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15.0),
        ),
      );

  Widget _selectorBox({
    required String placeholder,
    required String? selectedValue,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 52.0,
          decoration: BoxDecoration(
            borderRadius: _borderRadius,
            border: Border.all(color: AppColors.neutral700),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedValue ?? placeholder,
                    style: Theme.of(context).textTheme.bodyLarge!,
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
    );
  }

  Widget _radioOption({
    required String label,
    required String groupValue,
    required String value,
    required ValueChanged<String> onSelected,
  }) {
    final selected = groupValue == value;
    return InkWell(
      onTap: () => onSelected(value),
      child: Row(
        children: [
          Icon(
            selected
                ? Icons.radio_button_checked_rounded
                : Icons.circle_outlined,
            color: selected ? AppColors.primary : AppColors.textSecondary,
            size: 20.0,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15.0),
              ),
            ),
          ),
        ].divide(SizedBox(width: 12.0)),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Submit product (shared between Save & Publish / Save as Draft)
  // ---------------------------------------------------------------------------

  Future<void> _submitProduct(String status) async {
    final result = await actions.createProduct(
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
      shippingCost == 'Use Seller Default Shipping Rule' ? true : false,
      flatShippingCostTextController?.text ?? '',
      additionalItemFeeTextController?.text ?? '',
      status,
      uploadedImages.toList(),
    );

    if (result is Map && result['success'] == true) {
      if (status == 'active') {
        createProduct = result;
      } else {
        createProductAsDraft = result;
      }
      await showDialog(
        context: context,
        builder: (dialogContext) {
          return Dialog(
            elevation: 0,
            insetPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            alignment: Alignment.center.resolve(Directionality.of(context)),
            child: WebViewAware(
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(dialogContext).unfocus();
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: status == 'active'
                    ? DialogProductCreatedWidget(
                        productId: result['productId'].toString(),
                        action: () async {
                          Navigator.pop(context);
                          if (Navigator.of(context).canPop()) {
                            context.pop();
                          }
                          context.pushNamed(
                              HomeDashoardInventoryAddWidget.routeName);
                        },
                      )
                    : DialogProductDraftWidget(
                        action: () async {
                          Navigator.pop(context);
                          if (Navigator.of(context).canPop()) {
                            context.pop();
                          }
                          context.pushNamed(
                              HomeDashoardInventoryAddWidget.routeName);
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
        (result is Map ? result['title'] : null).toString(),
        (result is Map ? result['message'] : null).toString(),
        'error',
      );
    }

    setState(() {});
  }

  // ---------------------------------------------------------------------------
  // Section builders
  // ---------------------------------------------------------------------------

  Widget _buildPhotosSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Product Photos',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                InkWell(
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
                        selectedMedia.every((m) =>
                            validateFileFormat(m.storagePath, context))) {
                      setState(() => isDataUploading_uploadDataEdit = true);
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
                    child: Center(
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
                      children: List.generate(images.length, (imagesIndex) {
                        final imagesItem = images[imagesIndex];
                        return Container(
                          width: 112.0,
                          height: 112.0,
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.memory(
                                  imagesItem.bytes ?? Uint8List.fromList([]),
                                  width: 112.0,
                                  height: 112.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(top: 8.0, right: 8.0),
                                  child: InkWell(
                                    onTap: () async {
                                      removeFromUploadedImages(imagesItem);
                                      setState(() {});
                                    },
                                    child: Container(
                                      width: 25.0,
                                      height: 25.0,
                                      decoration: BoxDecoration(
                                        color: Color(0x4C252525),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
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
          padding: EdgeInsets.only(left: 16.0, top: 10.0, right: 16.0),
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
      ],
    );
  }

  Widget _buildBasicInfoSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Basic Information'),
        _fieldLabel('Product Title'),
        Padding(
          padding: EdgeInsets.only(top: 8.0),
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
              obscureText: false,
              decoration: _inputDecoration('Enter product title'),
              style: _textFieldStyle,
              cursorColor: AppColors.textPrimary,
              enableInteractiveSelection: true,
            ),
          ),
        ),
        _fieldLabel('Category'),
        _selectorBox(
          placeholder: 'Select category',
          selectedValue: category?.name,
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
                  child: DismissKeyboard(
                    child: Padding(
                      padding: MediaQuery.viewInsetsOf(context),
                      child: HomeDashoardInventoryAddCategoryWidget(
                        category: category,
                      ),
                    ),
                  ),
                );
              },
            ).then((value) {
              if (value == null) return;
              setState(() {
                if (category?.id != value.id) {
                  subcategory = null;
                }
                category = value;
              });
            });
          },
        ),
        _fieldLabel('Subcategory'),
        _selectorBox(
          placeholder: 'Select subcategory',
          selectedValue: subcategory?.name,
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
                    child: DismissKeyboard(
                      child: Padding(
                        padding: MediaQuery.viewInsetsOf(context),
                        child: HomeDashoardInventoryAddSubCategoryWidget(
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
        ),
        _fieldLabel('SKU'),
        Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Row(
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
                        getNextSkuNumber = await actions.getNextSkuNumber(
                          skuPrefixTextController?.text ?? '',
                          widget.productId,
                        );
                        setState(() {
                          skuNumberTextController?.text =
                              (getNextSkuNumber is Map
                                      ? getNextSkuNumber['nextNumber']
                                      : null)
                                  .toString();
                        });
                        setState(() {});
                      },
                    ),
                    autofocus: false,
                    obscureText: false,
                    decoration: _inputDecoration('Enter Prefix'),
                    style: _textFieldStyle,
                    cursorColor: AppColors.textPrimary,
                    enableInteractiveSelection: true,
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
                    obscureText: false,
                    decoration: _inputDecoration('SKU number'),
                    style: _textFieldStyle,
                    keyboardType: TextInputType.number,
                    cursorColor: AppColors.textPrimary,
                    enableInteractiveSelection: true,
                  ),
                ),
              ),
            ].divide(SizedBox(width: 12.0)),
          ),
        ),
        _fieldLabel('Quantity'),
        Padding(
          padding: EdgeInsets.only(top: 8.0),
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
              obscureText: false,
              decoration: _inputDecoration('Enter quantity'),
              style: _textFieldStyle,
              keyboardType: TextInputType.number,
              cursorColor: AppColors.textPrimary,
              enableInteractiveSelection: true,
              inputFormatters: [quantityMask],
            ),
          ),
        ),
        _fieldLabel('Condition'),
        Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: InkWell(
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
                    child: DismissKeyboard(
                      child: Padding(
                        padding: MediaQuery.viewInsetsOf(context),
                        child: HomeDashoardInventoryAddConditionWidget(
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
                borderRadius: _borderRadius,
                border: Border.all(color: AppColors.neutral700),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: conditionsList.isNotEmpty
                          ? Row(
                              children: List.generate(conditionsList.length,
                                  (conditionsIndex) {
                                final conditionsItem =
                                    conditionsList[conditionsIndex];
                                return Text(
                                  '${conditionsItem.name}${conditionsIndex == (conditionsList.length - 1) ? '' : ', '}',
                                  style: Theme.of(context).textTheme.bodyLarge!,
                                );
                              }),
                            )
                          : Text(
                              'Select condition',
                              style: Theme.of(context).textTheme.bodyLarge!,
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
          padding: EdgeInsets.only(top: 16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Year (Optional)',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15.0),
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
                        obscureText: false,
                        decoration: _inputDecoration('Enter year'),
                        style: _textFieldStyle,
                        keyboardType: TextInputType.number,
                        cursorColor: AppColors.textPrimary,
                        enableInteractiveSelection: true,
                        inputFormatters: [yearMask],
                      ),
                    ),
                  ].divide(SizedBox(height: 8.0)),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Issue # (Optional)',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15.0),
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
                        obscureText: false,
                        decoration: _inputDecoration('Enter issue #'),
                        style: _textFieldStyle,
                        keyboardType: TextInputType.number,
                        cursorColor: AppColors.textPrimary,
                        enableInteractiveSelection: true,
                        inputFormatters: [issueMask],
                      ),
                    ),
                  ].divide(SizedBox(height: 8.0)),
                ),
              ),
            ].divide(SizedBox(width: 12.0)),
          ),
        ),
      ],
    );
  }

  Widget _buildPricingSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Pricing'),
        _fieldLabel('Price'),
        Padding(
          padding: EdgeInsets.only(top: 8.0),
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
              obscureText: false,
              decoration: _inputDecoration('0.00', prefix: _dollarPrefix),
              style: _textFieldStyle,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              cursorColor: AppColors.textPrimary,
              enableInteractiveSelection: true,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*[.,]?\d{0,2}')),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 16.0),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      'Flash Sale',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15.0),
                    ),
                    if (switchFlashSaleValue ?? true)
                      AppDropDown<int>(
                        controller: flashDropDownValueController ??=
                            FormFieldController<int>(
                          flashDropDownValue ??= 1,
                        ),
                        options: List<int>.from([1, 20, 24]),
                        optionLabels: ['1 hour', '20 hours', '24 hours'],
                        onChanged: (val) =>
                            setState(() => flashDropDownValue = val),
                        width: 115.0,
                        height: 50.0,
                        textStyle: Theme.of(context).textTheme.bodyMedium!,
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
                        margin: EdgeInsets.symmetric(horizontal: 12.0),
                        hidesUnderline: true,
                        isOverButton: true,
                        isSearchable: false,
                        isMultiSelect: false,
                      ),
                  ].divide(SizedBox(width: 8.0)),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Switch.adaptive(
                  value: switchFlashSaleValue!,
                  onChanged: (newValue) async {
                    setState(() => switchFlashSaleValue = newValue);
                  },
                  activeThumbColor: AppColors.primary,
                  activeTrackColor: AppColors.primary,
                  inactiveTrackColor: AppColors.alternate,
                  inactiveThumbColor: AppColors.backgroundSecondary,
                ),
              ),
            ],
          ),
        ),
        if (switchFlashSaleValue ?? true) _buildDiscountFields(),
      ],
    );
  }

  Widget _buildDiscountFields() {
    return Padding(
      padding: EdgeInsets.only(top: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Amount',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15.0),
                ),
                discount == 'percentage'
                    ? Container(
                        width: double.infinity,
                        child: TextFormField(
                          controller: percentageDiscountTextController,
                          focusNode: percentageDiscountFocusNode,
                          onChanged: (_) => EasyDebounce.debounce(
                            'percentageDiscountTextController',
                            Duration(milliseconds: 100),
                            () => setState(() {}),
                          ),
                          autofocus: false,
                          obscureText: false,
                          decoration:
                              _inputDecoration('0', prefix: _percentPrefix),
                          style: _textFieldStyle,
                          keyboardType: TextInputType.number,
                          cursorColor: AppColors.textPrimary,
                          enableInteractiveSelection: true,
                          inputFormatters: [percentageDiscountMask],
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        child: TextFormField(
                          controller: dollarDiscountTextController,
                          focusNode: dollarDiscountFocusNode,
                          onChanged: (_) => EasyDebounce.debounce(
                            'dollarDiscountTextController',
                            Duration(milliseconds: 100),
                            () => setState(() {}),
                          ),
                          autofocus: false,
                          obscureText: false,
                          decoration:
                              _inputDecoration('0.00', prefix: _dollarPrefix),
                          style: _textFieldStyle,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          cursorColor: AppColors.textPrimary,
                          enableInteractiveSelection: true,
                        ),
                      ),
                Row(
                  children: [
                    Expanded(
                      child: _radioOption(
                        label: 'Percentage Discount',
                        groupValue: discount,
                        value: 'percentage',
                        onSelected: (val) {
                          discount = val;
                          setState(() {});
                        },
                      ),
                    ),
                    Expanded(
                      child: _radioOption(
                        label: 'Dollar Discount',
                        groupValue: discount,
                        value: 'dollar',
                        onSelected: (val) {
                          discount = val;
                          setState(() {});
                        },
                      ),
                    ),
                  ].divide(SizedBox(width: 24.0)),
                ),
              ].divide(SizedBox(height: 8.0)),
            ),
          ),
        ].divide(SizedBox(width: 12.0)),
      ),
    );
  }

  Widget _buildShippingCostSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: _sectionTitle('Shipping Cost'),
        ),
        _radioOption(
          label: 'Use Seller Default Shipping Rule',
          groupValue: shippingCost,
          value: 'Use Seller Default Shipping Rule',
          onSelected: (val) {
            shippingCost = val;
            setState(() {});
          },
        ),
        _radioOption(
          label: 'Set Custom Shipping For This Product',
          groupValue: shippingCost,
          value: 'Set Custom Shipping For This Product',
          onSelected: (val) {
            shippingCost = val;
            setState(() {});
          },
        ),
        if (shippingCost == 'Set Custom Shipping For This Product')
          Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Flat Shipping Cost',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15.0),
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
                    obscureText: false,
                    decoration: _inputDecoration('0.00', prefix: _dollarPrefix),
                    style: _textFieldStyle,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    cursorColor: AppColors.textPrimary,
                    enableInteractiveSelection: true,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 4.0),
                  child: Text(
                    'Additional Item Fee',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15.0),
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
                    obscureText: false,
                    decoration: _inputDecoration('0.00', prefix: _dollarPrefix),
                    style: _textFieldStyle,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    cursorColor: AppColors.textPrimary,
                    enableInteractiveSelection: true,
                  ),
                ),
              ].divide(SizedBox(height: 8.0)),
            ),
          ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style:
              Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15.0),
        ),
        Padding(
          padding: EdgeInsets.only(top: 8.0),
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
              obscureText: false,
              decoration: _inputDecoration('Describe your item in detail'),
              style: _textFieldStyle,
              maxLines: 10,
              minLines: 4,
              maxLength: 500,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              buildCounter: (context,
                      {required currentLength,
                      required isFocused,
                      maxLength}) =>
                  null,
              cursorColor: AppColors.textPrimary,
              enableInteractiveSelection: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTagsSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add Product Tags',
          style:
              Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15.0),
        ),
        Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: InkWell(
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
                borderRadius: _borderRadius,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Add Tags',
                        style: Theme.of(context).textTheme.bodyLarge!,
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
        if (choosenTags.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(choosenTags.length, (tagsIndex) {
                  final tagsItem = choosenTags[tagsIndex];
                  return InkWell(
                    onTap: () async {
                      choosenTags.remove(tagsItem);
                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF252525),
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 12.0, top: 2.0, right: 12.0, bottom: 4.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              tagsItem.name,
                              style: Theme.of(context).textTheme.bodyMedium!,
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
          ),
      ],
    );
  }

  Widget _buildAiScanButton() {
    return Container(
      width: double.infinity,
      height: 56.0,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF7D56FF), Color(0xFF6187F1)],
          stops: [0.0, 1.0],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
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
    );
  }

  Widget _buildConventionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Convention Settings'),
        Row(
          children: [
            Expanded(
              child: Text(
                'Add to Convention Shortlist',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15.0),
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
              activeThumbColor: AppColors.primary,
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.alternate,
              inactiveThumbColor: AppColors.backgroundSecondary,
            ),
          ].divide(SizedBox(width: 8.0)),
        ),
        if (switchConventionSettingsValue ?? true)
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              'Select Convention',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15.0),
            ),
          ),
        if (switchConventionSettingsValue ?? true)
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: AppDropDown<String>(
              controller: dropDownValueController ??=
                  FormFieldController<String>(null),
              options: userShortlists.map((s) => s.id).toList(),
              optionLabels: userShortlists.map((s) => s.name).toList(),
              onChanged: (val) => setState(() => dropDownValue = val),
              width: double.infinity,
              height: 50.0,
              textStyle: Theme.of(context).textTheme.bodyMedium!,
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
              margin: EdgeInsets.symmetric(horizontal: 12.0),
              hidesUnderline: true,
              isOverButton: true,
              isSearchable: false,
              isMultiSelect: false,
            ),
          ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        AppGradientButton(
          text: 'Save & Publish',
          onPressed: () async {
            await _submitProduct('active');
          },
        ),
        if ((widget.productId != null && widget.productId != '') &&
            (getProduct?.status != 'active'))
          Builder(
            builder: (context) => Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: SizedBox(
                width: double.infinity,
                height: 56.0,
                child: AppOutlineButton(
                  text: 'Save as Draft',
                  onPressed: () async {
                    await _submitProduct('draft');
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

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
                  style: Theme.of(context).textTheme.titleMedium!,
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
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPhotosSection(),
                Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBasicInfoSection(),
                        _sectionDivider,
                        _buildPricingSection(),
                        _sectionDivider,
                        _buildShippingCostSection(),
                        _sectionDivider,
                        _buildDescriptionSection(),
                        _sectionDivider,
                        _buildTagsSection(),
                        _sectionDivider,
                        _buildAiScanButton(),
                        _sectionDivider,
                        _buildConventionSection(),
                        _sectionDivider,
                        _buildActionButtons(),
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
