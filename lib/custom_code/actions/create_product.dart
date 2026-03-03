import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/core/utils/uploaded_file.dart';
import 'index.dart';
import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

bool _isValidUuid(String? value) {
  if (value == null || value.trim().isEmpty) return false;
  final uuidRegex = RegExp(
    r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
  );
  return uuidRegex.hasMatch(value.trim());
}

Future<dynamic> createProduct(
  String? productId,
  String title,
  String description,
  String? categoryId,
  String? subcategoryId,
  String skuPrefix,
  String? skuNumber,
  String? quantityStr,
  List<String>? conditionIds,
  String? yearStr,
  String? issueNumberStr,
  String? priceStr,
  bool? flashSaleEnabled,
  int? flashSaleHours,
  bool? isPercentageDiscount,
  String? discountAmountStr,
  List<String>? tagIds,
  String? shortlistId,
  bool? useSellerShipping,
  String? customFlatRateStr,
  String? customAdditionalItemFeeStr,
  String status,
  List<FFUploadedFile> uploadedImages,
) async {
  final bool isEditMode = _isValidUuid(productId);

  Map<String, dynamic> errorResult(String errTitle, String message) => {
        'success': false,
        'title': errTitle,
        'message': message,
        'productId': null,
      };

  try {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;

    if (userId == null) {
      return errorResult(
        'Not Logged In',
        'You must be logged in to ${isEditMode ? 'edit' : 'create'} a product.',
      );
    }

    // ─── Parse values ─────────────────────────────────────────────────────────
    final bool flashSale = flashSaleEnabled ?? false;
    final bool isPercentage = isPercentageDiscount ?? false;
    final bool useSellerShip = useSellerShipping ?? true;

    final int quantity = int.tryParse(quantityStr?.trim() ?? '') ?? 0;
    final double price = double.tryParse(priceStr?.trim() ?? '') ?? 0.0;
    final int? year = int.tryParse(yearStr?.trim() ?? '');
    final int? issueNumber = int.tryParse(issueNumberStr?.trim() ?? '');
    final double? discountAmount =
        double.tryParse(discountAmountStr?.trim() ?? '');
    final double? customFlatRate =
        double.tryParse(customFlatRateStr?.trim() ?? '');
    final double? customAdditionalItemFee =
        double.tryParse(customAdditionalItemFeeStr?.trim() ?? '');

    // ─── Photos ───────────────────────────────────────────────────────────────
    // uploadedImages содержит ВСЕ фото (старые + новые)
    // В edit режиме старые загружены в FFUploadedFile через networkImageToFile
    // RPC уже удалил все старые из БД, просто загружаем все заново
    final List<FFUploadedFile> validImages = uploadedImages
        .where((f) => f.bytes != null && f.bytes!.isNotEmpty)
        .toList();

    if (validImages.isEmpty) {
      return errorResult(
        'No Photos Added',
        'Please add at least 1 photo of your product.',
      );
    }

    if (validImages.length > 10) {
      return errorResult(
        'Too Many Photos',
        'Maximum 10 photos allowed. Please remove ${validImages.length - 10} photo(s).',
      );
    }

    const int maxFileSizeBytes = 10 * 1024 * 1024;
    for (int i = 0; i < validImages.length; i++) {
      final int fileSize = validImages[i].bytes!.length;
      if (fileSize > maxFileSizeBytes) {
        final double sizeMb = fileSize / (1024 * 1024);
        return errorResult(
          'Photo Too Large',
          'Photo ${i + 1} is ${sizeMb.toStringAsFixed(1)}MB. Maximum is 10MB per photo.',
        );
      }
    }

    // ─── Title ────────────────────────────────────────────────────────────────
    if (title.trim().isEmpty) {
      return errorResult('Missing Title', 'Product title is required.');
    }
    if (title.trim().length < 3) {
      return errorResult(
          'Title Too Short', 'Title must be at least 3 characters.');
    }
    if (title.trim().length > 200) {
      return errorResult(
        'Title Too Long',
        'Title must not exceed 200 characters. Current: ${title.trim().length}/200.',
      );
    }

    // ─── Description ──────────────────────────────────────────────────────────
    if (description.trim().isEmpty) {
      return errorResult('Missing Description', 'Please add a description.');
    }
    if (description.trim().length > 500) {
      return errorResult(
        'Description Too Long',
        'Max 500 characters. Current: ${description.trim().length}/500.',
      );
    }

    // ─── Category ─────────────────────────────────────────────────────────────
    if (!_isValidUuid(categoryId)) {
      return errorResult('No Category Selected', 'Please select a category.');
    }
    final String? cleanSubcategoryId =
        _isValidUuid(subcategoryId) ? subcategoryId : null;

    // ─── SKU ──────────────────────────────────────────────────────────────────
    if (skuPrefix.trim().isEmpty) {
      return errorResult(
        'Missing SKU Prefix',
        'SKU prefix is required (e.g. "A1", "BOX2").',
      );
    }
    final String skuPrefixClean = skuPrefix.trim().toUpperCase();
    final String? skuNumberClean =
        (skuNumber?.trim().isNotEmpty == true) ? skuNumber!.trim() : null;

    final String skuDisplay = skuNumberClean != null
        ? '$skuPrefixClean-$skuNumberClean'
        : skuPrefixClean;
    if (skuDisplay.length > 50) {
      return errorResult(
          'SKU Too Long', 'SKU "$skuDisplay" exceeds 50 characters.');
    }

    // ─── Quantity ─────────────────────────────────────────────────────────────
    if ((quantityStr?.trim() ?? '').isEmpty) {
      return errorResult('Missing Quantity', 'Please enter the quantity.');
    }
    if (quantity <= 0) {
      return errorResult('Invalid Quantity', 'Quantity must be at least 1.');
    }
    if (quantity > 99999) {
      return errorResult(
        'Quantity Too High',
        'Maximum allowed is 99,999. You entered $quantity.',
      );
    }

    // ─── Conditions ───────────────────────────────────────────────────────────
    final List<String> cleanConditionIds =
        (conditionIds ?? []).where((id) => _isValidUuid(id)).toList();
    if (cleanConditionIds.isEmpty) {
      return errorResult(
        'No Condition Selected',
        'Please select at least one condition.',
      );
    }

    // ─── Year ─────────────────────────────────────────────────────────────────
    if (year != null) {
      final int currentYear = DateTime.now().year;
      if (year < 1800 || year > currentYear) {
        return errorResult(
          'Invalid Year',
          'Year must be between 1800 and $currentYear.',
        );
      }
    }

    // ─── Issue Number ─────────────────────────────────────────────────────────
    if (issueNumber != null && issueNumber <= 0) {
      return errorResult(
        'Invalid Issue Number',
        'Issue number must be greater than 0.',
      );
    }

    // ─── Price ────────────────────────────────────────────────────────────────
    if ((priceStr?.trim() ?? '').isEmpty) {
      return errorResult('Missing Price', 'Please enter a price.');
    }
    if (price <= 0) {
      return errorResult('Invalid Price', 'Price must be greater than \$0.00.');
    }
    if (price > 999999.99) {
      return errorResult('Price Too High', 'Price cannot exceed \$999,999.99.');
    }

    // ─── Flash Sale ───────────────────────────────────────────────────────────
    String? discountType;
    double? finalDiscountAmount;

    if (flashSale) {
      if (flashSaleHours == null || ![1, 2, 24].contains(flashSaleHours)) {
        return errorResult(
            'Invalid Flash Sale Duration', 'Select 1, 2, or 24 hours.');
      }
      if (discountAmount == null || discountAmount <= 0) {
        return errorResult(
          'Missing Discount Amount',
          'Enter a discount amount greater than zero.',
        );
      }
      if (isPercentage) {
        if (discountAmount >= 100) {
          return errorResult(
            'Invalid Percentage Discount',
            'Discount must be less than 100%.',
          );
        }
        discountType = 'percentage';
      } else {
        if (discountAmount >= price) {
          return errorResult(
            'Discount Exceeds Price',
            'Discount (\$${discountAmount.toStringAsFixed(2)}) must be less than price (\$${price.toStringAsFixed(2)}).',
          );
        }
        discountType = 'dollar';
      }
      finalDiscountAmount = discountAmount;
    }

    // ─── Tags ─────────────────────────────────────────────────────────────────
    final List<String> cleanTagIds =
        (tagIds ?? []).where((id) => _isValidUuid(id)).toList();

    // ─── Shortlist ────────────────────────────────────────────────────────────
    final String? cleanShortlistId =
        _isValidUuid(shortlistId) ? shortlistId : null;

    // ─── Custom Shipping ──────────────────────────────────────────────────────
    if (!useSellerShip) {
      if (customFlatRate == null || customFlatRate <= 0) {
        return errorResult(
          'Missing Flat Shipping Rate',
          'Custom shipping requires a flat rate greater than \$0.00.',
        );
      }
      if (customFlatRate > 9999.99) {
        return errorResult(
            'Shipping Rate Too High', 'Flat rate cannot exceed \$9,999.99.');
      }
      if (customAdditionalItemFee != null && customAdditionalItemFee < 0) {
        return errorResult(
          'Invalid Additional Item Fee',
          'Additional item fee cannot be negative.',
        );
      }
    }

    // ─── Status ───────────────────────────────────────────────────────────────
    if (!['active', 'draft'].contains(status)) {
      return errorResult(
          'Invalid Status', 'Status must be "active" or "draft".');
    }

    // ─── Build RPC params ─────────────────────────────────────────────────────
    final Map<String, dynamic> params = {
      'p_title': title.trim(),
      'p_description': description.trim(),
      'p_category_id': categoryId,
      'p_sku': skuPrefixClean,
      'p_sku_number': skuNumberClean,
      'p_quantity': quantity,
      'p_price': price,
      'p_flash_sale_enabled': flashSale,
      'p_use_seller_shipping': useSellerShip,
      'p_status': status,
      'p_condition_ids': cleanConditionIds,
    };

    if (isEditMode) params['p_product_id'] = productId;
    if (cleanSubcategoryId != null)
      params['p_subcategory_id'] = cleanSubcategoryId;
    if (cleanShortlistId != null) params['p_shortlist_id'] = cleanShortlistId;
    if (year != null) params['p_year'] = year;
    if (issueNumber != null) params['p_issue_number'] = issueNumber;
    if (flashSale && flashSaleHours != null)
      params['p_flash_sale_hours'] = flashSaleHours;
    if (discountType != null) params['p_discount_type'] = discountType;
    if (finalDiscountAmount != null)
      params['p_discount_amount'] = finalDiscountAmount;
    if (cleanTagIds.isNotEmpty) params['p_tags'] = cleanTagIds;
    if (!useSellerShip) {
      if (customFlatRate != null) params['p_custom_flat_rate'] = customFlatRate;
      if (customAdditionalItemFee != null) {
        params['p_custom_additional_item_fee'] = customAdditionalItemFee;
      }
    }

    // ─── Call RPC ─────────────────────────────────────────────────────────────
    final String rpcName = isEditMode ? 'update_product' : 'create_product';
    final response = await supabase.rpc(rpcName, params: params);

    if (response == null) {
      return errorResult('Server Error',
          'No response from server. Please check your connection.');
    }
    if (response['success'] != true) {
      final String serverError =
          response['error']?.toString() ?? 'Unknown server error';
      return errorResult(
        isEditMode ? 'Failed to Update Product' : 'Failed to Create Product',
        serverError,
      );
    }

    final String? finalProductId =
        isEditMode ? productId : response['product_id']?.toString();

    if (finalProductId == null || finalProductId.isEmpty) {
      return errorResult(
        'Incomplete Response',
        'Operation may have succeeded but no product ID was returned.',
      );
    }

    // ─── Upload ALL images ────────────────────────────────────────────────────
    // edit: старые уже удалены через RPC, загружаем все заново
    // create: просто загружаем все
    int uploadedCount = 0;
    for (int i = 0; i < validImages.length; i++) {
      try {
        final String fileName =
            '$userId/${finalProductId}_${i}_${DateTime.now().millisecondsSinceEpoch}.jpg';

        await supabase.storage.from('product-images').uploadBinary(
              fileName,
              validImages[i].bytes!,
              fileOptions: const FileOptions(
                contentType: 'image/jpeg',
                upsert: false,
              ),
            );

        final String publicUrl =
            supabase.storage.from('product-images').getPublicUrl(fileName);

        await supabase.from('product_images').insert({
          'product_id': finalProductId,
          'image_url': publicUrl,
          'is_main': i == 0, // первое фото всегда главное
          'sort_order': i,
        });

        uploadedCount++;
      } catch (e) {
        debugPrint('Failed to upload image $i: $e');
      }
    }

    // ─── Success ──────────────────────────────────────────────────────────────
    final String successMessage = uploadedCount == validImages.length
        ? isEditMode
            ? 'Product updated with ${validImages.length} photo(s).'
            : 'Your product is live with ${validImages.length} photo(s).'
        : isEditMode
            ? 'Product updated. $uploadedCount of ${validImages.length} photo(s) saved.'
            : 'Product created. $uploadedCount of ${validImages.length} photo(s) uploaded.';

    return {
      'success': true,
      'title': isEditMode ? 'Product Updated! ✅' : 'Product Created! 🎉',
      'message': successMessage,
      'productId': finalProductId,
    };
  } catch (e) {
    return {
      'success': false,
      'title': 'Unexpected Error',
      'message': 'An unexpected error occurred: ${e.toString()}.',
      'productId': null,
    };
  }
}
