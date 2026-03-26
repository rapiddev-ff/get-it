import '/features/home/domain/models/seller_model.dart';
import '/features/home/domain/models/seller_product_model.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/keyboard_visibility_mixin.dart';
import '/core/constants/app_constants.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/app_gradient_button.dart';
import '/core/utils/value_utils.dart';
import '/core/widgets/dismiss_keyboard.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '/core/utils/uploaded_file.dart' show UploadedFile;

class HomeSellerProfileReviewsStep2Widget extends StatefulWidget {
  const HomeSellerProfileReviewsStep2Widget({
    super.key,
    required this.sellerDataType,
    required this.product,
    this.reviewRole = 'as_buyer',
  });

  final Seller? sellerDataType;
  final SellerProduct? product;
  final String reviewRole;

  static const String routeName = 'homeSellerProfileReviewsStep2';
  static const String routePath = 'homeSellerProfileReviewsStep2';

  @override
  State<HomeSellerProfileReviewsStep2Widget> createState() =>
      _HomeSellerProfileReviewsStep2WidgetState();
}

class _HomeSellerProfileReviewsStep2WidgetState
    extends State<HomeSellerProfileReviewsStep2Widget>
    with KeyboardVisibilityMixin {
  // Inlined from model
  List<Uint8List> images = [];
  double? ratingBarValue2;
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  List<String>? uploadReviewImages;

  @override
  void initState() {
    super.initState();

    textController ??= TextEditingController();
    textFieldFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    EasyDebounce.cancelAll();
    textFieldFocusNode?.dispose();
    textController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                style: IconButton.styleFrom(
                  minimumSize: Size(40.0, 40.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                icon: Icon(
                  Icons.arrow_back,
                  color: AppColors.info,
                  size: 24.0,
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
              Text(
                'Write Review',
                style: Theme.of(context).textTheme.titleMedium!,
              ),
              Opacity(
                opacity: 0.0,
                child: IconButton(
                  style: IconButton.styleFrom(
                    minimumSize: Size(40.0, 40.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  icon: Icon(
                    Icons.more_vert,
                    color: AppColors.info,
                    size: 20.0,
                  ),
                  onPressed: null,
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16.0, top: 28.0, right: 16.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundSecondary,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 10.0, top: 16.0, right: 16.0, bottom: 16.0),
                      child: Row(
                        children: [
                          if ((widget.product?.mainImageUrl ?? '').isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4.0),
                              child: CachedNetworkImage(
                                imageUrl: widget.product!.mainImageUrl,
                                width: 64.0,
                                height: 84.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  valueOrDefault<String>(
                                    widget.product?.title,
                                    'n/a',
                                  ),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          fontWeight: FontWeight.w500,
                                          height: 1.5),
                                ),
                                if (widget.product?.conditionName.isNotEmpty ==
                                    true)
                                  Text(
                                    widget.product!.conditionName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(height: 1.5),
                                  ),
                                Padding(
                                  padding: EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '\$${NumberFormat('#,##0.00', 'en_US').format(widget.product?.price ?? 0)}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  height: 1.5),
                                        ),
                                      ),
                                      Text(
                                        widget.product?.createdAt != null
                                            ? 'Purchased ${DateFormat('MMM dd, yyyy').format(widget.product!.createdAt!)}'
                                            : '',
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall!
                                            .copyWith(height: 1.5),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ].divide(SizedBox(height: 2.0)),
                            ),
                          ),
                        ].divide(SizedBox(width: 12.0)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.0, top: 24.0, right: 16.0),
                  child: Row(
                    children: [
                      Container(
                        width: 80.0,
                        height: 80.0,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: CachedNetworkImage(
                          fadeInDuration: Duration(milliseconds: 100),
                          fadeOutDuration: Duration(milliseconds: 100),
                          imageUrl: valueOrDefault<String>(
                            widget.sellerDataType?.avatarUrl,
                            'https://media.istockphoto.com/id/1223671392/vector/default-profile-picture-avatar-photo-placeholder-vector-illustration.jpg?s=612x612&w=0&k=20&c=s0aTdmT5aU6b8ot7VKm11DeID6NctRCpB755rA1BIP0=',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              valueOrDefault<String>(
                                widget.sellerDataType?.username,
                                'n/a',
                              ),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: [
                                  RatingBarIndicator(
                                    itemBuilder: (context, index) => Icon(
                                      Icons.star_rounded,
                                      color: AppColors.statusYellow,
                                    ),
                                    direction: Axis.horizontal,
                                    rating: valueOrDefault<double>(
                                      widget.reviewRole == 'as_buyer'
                                          ? widget.sellerDataType?.ratingAsBuyer
                                          : widget
                                              .sellerDataType?.ratingAsSeller,
                                      0.0,
                                    ),
                                    unratedColor: AppColors.neutral700,
                                    itemCount: 5,
                                    itemSize: 15.0,
                                  ),
                                  Text(
                                    valueOrDefault<String>(
                                      (widget.reviewRole == 'as_buyer'
                                              ? widget
                                                  .sellerDataType?.ratingAsBuyer
                                              : widget.sellerDataType
                                                  ?.ratingAsSeller)
                                          ?.toString(),
                                      '0',
                                    ),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    '${(widget.reviewRole == 'as_buyer' ? widget.sellerDataType?.totalReviewsAsBuyer : widget.sellerDataType?.totalReviewsAsSeller)?.toString() ?? '0'} reviews',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!,
                                  ),
                                ].divide(SizedBox(width: 8.0)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ].divide(SizedBox(width: 12.0)),
                  ),
                ),
                Divider(
                  height: 56.0,
                  thickness: 1.0,
                  color: AppColors.alternate,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundSecondary,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Rate Your Experience',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(height: 1.5),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 24.0, bottom: 16.0),
                            child: RatingBar.builder(
                              onRatingUpdate: (newValue) =>
                                  setState(() => ratingBarValue2 = newValue),
                              itemBuilder: (context, index) => Icon(
                                Icons.star_rounded,
                                color: AppColors.statusYellow,
                              ),
                              direction: Axis.horizontal,
                              initialRating: ratingBarValue2 ??= 0.0,
                              itemCount: 5,
                              itemSize: 28.0,
                              glowColor: AppColors.statusYellow,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.0, top: 20.0, right: 16.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundSecondary,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Write Your Review',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(height: 1.5),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 16.0),
                            child: Container(
                              width: double.infinity,
                              child: TextFormField(
                                controller: textController,
                                focusNode: textFieldFocusNode,
                                onChanged: (_) => EasyDebounce.debounce(
                                  '_textController',
                                  Duration(milliseconds: 100),
                                  () => setState(() {}),
                                ),
                                autofocus: false,
                                enabled: true,
                                obscureText: false,
                                decoration: InputDecoration(
                                  isDense: false,
                                  hintText:
                                      'Share your experience with this seller. How  was the item condition, packaging, and communication?',
                                  hintStyle:
                                      Theme.of(context).textTheme.labelLarge!,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.neutral700,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        AppConstants.radiusTextField4),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.secondary,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        AppConstants.radiusTextField4),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.error,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        AppConstants.radiusTextField4),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.error,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        AppConstants.radiusTextField4),
                                  ),
                                ),
                                style: Theme.of(context).textTheme.bodyMedium!,
                                maxLines: null,
                                minLines: 5,
                                maxLength: 500,
                                maxLengthEnforcement:
                                    MaxLengthEnforcement.enforced,
                                buildCounter: (context,
                                        {required currentLength,
                                        required isFocused,
                                        maxLength}) =>
                                    null,
                                keyboardType: TextInputType.emailAddress,
                                cursorColor: AppColors.textPrimary,
                                enableInteractiveSelection: true,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Minimum 20 characters',
                                    maxLines: 1,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(height: 1.5),
                                  ),
                                ),
                                Text(
                                  '${textController?.text.length ?? 0}/500',
                                  maxLines: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .copyWith(height: 1.5),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.0, top: 20.0, right: 16.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundSecondary,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Add Photos (Optional)',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(height: 1.5),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 16.0),
                            child: InkWell(
                              onTap: () async {
                                if (images.length >= 3) {
                                  await actions.toastificationshow(
                                    context,
                                    'Limit Reached',
                                    'You can upload up to 3 photos.',
                                    'error',
                                  );
                                  return;
                                }
                                final picker = ImagePicker();
                                final pickedFile = await picker.pickImage(
                                  source: ImageSource.gallery,
                                );
                                if (pickedFile != null) {
                                  final bytes = await pickedFile.readAsBytes();
                                  if (!mounted) return;
                                  setState(() {
                                    images.add(bytes);
                                  });
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4.0),
                                  border: Border.all(
                                    color: AppColors.neutral700,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20.0),
                                  child: Column(
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.camera,
                                        color: AppColors.textPrimary,
                                        size: 24.0,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 12.0),
                                        child: Text(
                                          'Upload photos of the item you received 3 LIMIT\n',
                                          maxLines: 1,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium!
                                              .copyWith(height: 1.5),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 4.0),
                                        child: Text(
                                          'Choose Photos',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall!
                                              .copyWith(
                                                color: AppColors.primary,
                                                height: 1.5,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (images.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(top: 12.0),
                              child: Builder(
                                builder: (context) {
                                  final image = images.toList();

                                  return SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: List.generate(image.length,
                                          (imageIndex) {
                                        final imageItem = image[imageIndex];
                                        return ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.memory(
                                            imageItem,
                                            width: 80.0,
                                            height: 80.0,
                                            fit: BoxFit.cover,
                                          ),
                                        );
                                      }).divide(SizedBox(width: 8.0)),
                                    ),
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (!isKeyboardShowing(context))
                  Padding(
                    padding:
                        EdgeInsets.only(left: 16.0, top: 32.0, right: 16.0),
                    child: AppGradientButton(
                      text: 'Submit Review',
                      onPressed: () async {
                        if (ratingBarValue2 == null || ratingBarValue2! < 1) {
                          await actions.toastificationshow(
                            context,
                            'Rating Required',
                            'Please select at least 1 star.',
                            'error',
                          );
                          return;
                        }
                        if ((textController?.text.trim().length ?? 0) > 0 &&
                            (textController?.text.trim().length ?? 0) < 20) {
                          await actions.toastificationshow(
                            context,
                            'Review Too Short',
                            'Please write at least 20 characters.',
                            'error',
                          );
                          return;
                        }
                        uploadReviewImages = await actions.uploadReviewImages(
                          images
                              .map((bytes) => UploadedFile(
                                    bytes: bytes,
                                    name: 'review_image.jpg',
                                  ))
                              .toList(),
                        );
                        final result = await actions.submitReview(
                          widget.product!.orderId,
                          widget.product!.id,
                          widget.reviewRole,
                          ratingBarValue2!.round(),
                          textController!.text,
                          widget.product?.title,
                          uploadReviewImages?.toList(),
                        );
                        if (!mounted) return;
                        if (result is Map && result['success'] == false) {
                          await actions.toastificationshow(
                            context,
                            'Error',
                            result['error']?.toString() ??
                                'Failed to submit review.',
                            'error',
                          );
                          return;
                        }
                        await actions.toastificationshow(
                          context,
                          'Review Submitted',
                          'Thank you for your feedback!',
                          'success',
                        );
                        if (!mounted) return;
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ),
              ].addToEnd(SizedBox(height: 32.0)),
            ),
          ),
        ),
      ),
    );
  }
}
