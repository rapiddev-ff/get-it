import 'package:easy_debounce/easy_debounce.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import '/core/providers/current_user_provider.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';

import '/features/browse/domain/models/category_model.dart';
import '/features/home/domain/models/product_details_model.dart';
import '/core/constants/app_constants.dart';
import '/features/home/presentation/widgets/empty_state/empty_state_widget.dart';
import '/features/home/presentation/widgets/nav_bar/nav_bar_widget.dart';
import '/core/router/app_router.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/dismiss_keyboard.dart';
import '/custom_code/actions/index.dart' as actions;
import '/features/browse/presentation/providers/browse_provider.dart';
import '/features/wishlist/presentation/pages/wishlist_item/wishlist_item_widget.dart';
import '/features/wishlist/presentation/providers/wishlist_provider.dart';
import '/features/profile/presentation/pages/settings/settings_widget.dart';
import '/features/notifications/presentation/pages/notification/notification_widget.dart';
import '/features/checkout/presentation/pages/checkout/checkout_widget.dart';
import '/features/home/domain/models/feed_product_model.dart';
import '/features/home/presentation/pages/home_product/home_product_widget.dart';
import '/features/browse/presentation/pages/browse/browse_widget.dart';

class WishlistWidget extends ConsumerStatefulWidget {
  const WishlistWidget({super.key});

  static const String routeName = 'wishlist';
  static const String routePath = 'wishlist';

  @override
  ConsumerState<WishlistWidget> createState() => _WishlistWidgetState();
}

class _WishlistWidgetState extends ConsumerState<WishlistWidget> {
  final _textController = TextEditingController();
  final _textFieldFocusNode = FocusNode();
  Category? _chosenCategory;
  bool _hadProducts = false;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await actions.initWishlistStream(ref, ref.read(currentUserIdProvider));
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    EasyDebounce.cancelAll();
    actions.disposeWishlistStream();
    _textFieldFocusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  static List<ProductDetails> _filterProducts(
    List<ProductDetails> products,
    String? searchQuery,
    String? categoryId,
  ) {
    if (products.isEmpty) return [];
    return products.where((product) {
      if (categoryId != null && categoryId.isNotEmpty) {
        if (product.category?.id != categoryId) return false;
      }
      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final query = searchQuery.toLowerCase().trim();
        final title = product.title.toLowerCase();
        final description = product.description.toLowerCase();
        if (!title.contains(query) && !description.contains(query)) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  Widget _buildShimmerGrid() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.68,
          crossAxisSpacing: 24.0,
          mainAxisSpacing: 24.0,
        ),
        itemCount: 6,
        itemBuilder: (context, index) => Shimmer.fromColors(
          baseColor: const Color(0xFF2A2A2A),
          highlightColor: const Color(0xFF3A3A3A),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 90.0,
                        height: 12.0,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          Container(
                            width: 50.0,
                            height: 12.0,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2A2A2A),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            width: 55.0,
                            height: 24.0,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2A2A2A),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wishlistState = ref.watch(wishlistProvider);
    final wishlistProducts = wishlistState.products;
    final isLoading = wishlistState.isLoading;
    final categoriesAsync = ref.watch(categoriesProvider);
    final categories = categoriesAsync.valueOrNull ?? [];

    return DismissKeyboard(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  style: IconButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    fixedSize: const Size(40.0, 40.0),
                  ),
                  icon:
                      const Icon(Icons.menu, color: AppColors.info, size: 24.0),
                  onPressed: () {
                    context.pushNamed(SettingsWidget.routeName);
                  },
                ),
                Text(
                  'Wishlist',
                  style: Theme.of(context).textTheme.titleMedium!,
                ),
                IconButton(
                  style: IconButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    fixedSize: const Size(40.0, 40.0),
                  ),
                  icon: const Icon(Icons.notifications_none,
                      color: AppColors.info, size: 20.0),
                  onPressed: () {
                    context.pushNamed(NotificationWidget.routeName);
                  },
                ),
              ],
            ),
            actions: const [],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Builder(
                builder: (context) {
                  if (isLoading) {
                    return _buildShimmerGrid();
                  }
                  if (wishlistProducts.isNotEmpty) {
                    _hadProducts = true;
                  }
                  if (wishlistProducts.isNotEmpty || _hadProducts) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: TextFormField(
                              controller: _textController,
                              focusNode: _textFieldFocusNode,
                              onChanged: (_) => EasyDebounce.debounce(
                                '_textController',
                                const Duration(milliseconds: 300),
                                () => setState(() {}),
                              ),
                              autofocus: false,
                              obscureText: false,
                              decoration: InputDecoration(
                                isDense: false,
                                hintText:
                                    'Search products, characters, years...',
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(fontSize: 15.0),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: AppColors.neutral700,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      AppConstants.radiusTextField4),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: AppColors.secondary,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      AppConstants.radiusTextField4),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: AppColors.error,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      AppConstants.radiusTextField4),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: AppColors.error,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      AppConstants.radiusTextField4),
                                ),
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: Colors.white,
                                  size: 24.0,
                                ),
                              ),
                              style: Theme.of(context).textTheme.bodyMedium!,
                              cursorColor: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _chosenCategory = null;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          _chosenCategory == null
                                              ? AppColors.brandPurple
                                              : AppColors.backgroundSecondary,
                                          _chosenCategory == null
                                              ? AppColors.brandBlue
                                              : AppColors.backgroundSecondary,
                                        ],
                                        stops: const [0.0, 1.0],
                                        begin: const AlignmentDirectional(
                                            0.0, -1.0),
                                        end: Alignment.bottomCenter,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 8.0),
                                      child: Text(
                                        'All (${wishlistProducts.length})',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13.0),
                                      ),
                                    ),
                                  ),
                                ),
                                ...List.generate(categories.length,
                                    (categoriesIndex) {
                                  final categoriesItem =
                                      categories[categoriesIndex];
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        _chosenCategory = categoriesItem;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            _chosenCategory == categoriesItem
                                                ? AppColors.brandPurple
                                                : AppColors.backgroundSecondary,
                                            _chosenCategory == categoriesItem
                                                ? AppColors.brandBlue
                                                : AppColors.backgroundSecondary,
                                          ],
                                          stops: const [0.0, 1.0],
                                          begin: const AlignmentDirectional(
                                              0.0, -1.0),
                                          end: const AlignmentDirectional(
                                              0, 1.0),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 8.0),
                                        child: Text(
                                          categoriesItem.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 13.0),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ]
                                  .divide(const SizedBox(width: 8.0))
                                  .addToStart(const SizedBox(width: 16.0))
                                  .addToEnd(const SizedBox(width: 16.0)),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, top: 24.0, right: 16.0),
                            child: Builder(
                              builder: (context) {
                                final wishlist = _filterProducts(
                                  wishlistProducts,
                                  _textController.text,
                                  _chosenCategory?.id,
                                );
                                if (wishlist.isEmpty) {
                                  final hasSearch =
                                      _textController.text.trim().isNotEmpty;
                                  final hasCategory = _chosenCategory != null;
                                  final hasFilters = hasSearch || hasCategory;

                                  return Center(
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: EmptyStateWidget(
                                        icon: hasFilters
                                            ? Icon(
                                                hasSearch
                                                    ? Icons.search_off
                                                    : Icons.filter_list_off,
                                                color: AppColors.neutral800,
                                                size: 100.0,
                                              )
                                            : FaIcon(
                                                FontAwesomeIcons.solidHeart,
                                                color: AppColors.neutral800,
                                                size: 100.0,
                                              ),
                                        title: hasFilters
                                            ? 'No matches'
                                            : 'Your wishlist is empty',
                                        description: hasSearch
                                            ? 'We couldn\'t find anything matching "${_textController.text}".'
                                            : hasCategory
                                                ? 'No items in "${_chosenCategory?.name ?? ''}" category.'
                                                : 'Tap the heart on any item to save it here for later.',
                                        hasButton: true,
                                        sidePadding: 16.0,
                                        buttonText: hasFilters
                                            ? (hasSearch
                                                ? 'Clear Search'
                                                : 'Show All')
                                            : 'Browse Items',
                                        buttonAction: () async {
                                          if (hasFilters) {
                                            setState(() {
                                              if (hasSearch) {
                                                _textController.clear();
                                              }
                                              if (hasCategory) {
                                                _chosenCategory = null;
                                              }
                                            });
                                          } else {
                                            context.goNamed(
                                              BrowseWidget.routeName,
                                              extra: <String, dynamic>{
                                                kTransitionInfoKey:
                                                    TransitionInfo(
                                                  hasTransition: true,
                                                  transitionType:
                                                      PageTransitionType.fade,
                                                  duration: Duration.zero,
                                                ),
                                              },
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  );
                                }

                                return MasonryGridView.builder(
                                  gridDelegate:
                                      const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                  ),
                                  crossAxisSpacing: 24.0,
                                  mainAxisSpacing: 24.0,
                                  itemCount: wishlist.length,
                                  itemBuilder: (context, wishlistIndex) {
                                    final wishlistItem =
                                        wishlist[wishlistIndex];
                                    return InkWell(
                                      onTap: () {
                                        context.pushNamed(
                                          HomeProductWidget.routeName,
                                          queryParameters: {
                                            'productId': wishlistItem.id,
                                          },
                                        );
                                      },
                                      child: WishlistItemWidget(
                                        key: Key(
                                            'Key1b2_${wishlistIndex}_of_${wishlist.length}'),
                                        productDataType: wishlistItem,
                                        actionWishlish: () async {
                                          ref
                                              .read(wishlistProvider.notifier)
                                              .removeById(wishlistItem.id);
                                          await actions.toggleWishlist(
                                            ref.read(currentUserIdProvider),
                                            wishlistItem.id,
                                          );
                                        },
                                        onBuyNow: () {
                                          context.pushNamed(
                                            CheckoutWidget.routeName,
                                            queryParameters: {
                                              'feedProductItem': FeedProduct(
                                                id: wishlistItem.id,
                                                title: wishlistItem.title,
                                                description:
                                                    wishlistItem.description,
                                                price: wishlistItem.price,
                                                originalPrice:
                                                    wishlistItem.originalPrice,
                                                flashSaleEnabled: wishlistItem
                                                    .flashSaleEnabled,
                                                flashSalePrice:
                                                    wishlistItem.flashSalePrice,
                                                flashSaleEndsAt:
                                                    wishlistItem.flashSaleEndsAt,
                                                conditionName: wishlistItem
                                                        .conditions
                                                        .firstOrNull
                                                        ?.name ??
                                                    wishlistItem.conditionName,
                                                mainImageUrl: wishlistItem
                                                        .images
                                                        .firstOrNull
                                                        ?.imageUrl ??
                                                    wishlistItem.mainImageUrl,
                                                sellerId:
                                                    wishlistItem.seller?.id ??
                                                        wishlistItem.sellerId,
                                                sellerUsername: wishlistItem
                                                        .seller?.username ??
                                                    wishlistItem
                                                        .sellerUsername,
                                                sellerAvatarUrl: wishlistItem
                                                        .seller?.avatarUrl ??
                                                    wishlistItem
                                                        .sellerAvatarUrl,
                                                sellerRating: wishlistItem
                                                        .seller
                                                        ?.ratingAsSeller ??
                                                    0.0,
                                                sellerTotalReviews: wishlistItem
                                                        .seller
                                                        ?.totalReviewsAsSeller ??
                                                    0,
                                                isInWishlist: true,
                                                createdAt:
                                                    wishlistItem.createdAt,
                                                shippingPrice:
                                                    wishlistItem.shippingPrice,
                                                freeShipping:
                                                    wishlistItem.freeShipping,
                                                useSellerShipping: wishlistItem
                                                    .useSellerShipping,
                                                customFlatRate: wishlistItem
                                                    .customFlatRate,
                                                customAdditionalItemFee:
                                                    wishlistItem
                                                        .customAdditionalItemFee,
                                              ).serialize(),
                                            },
                                          );
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ]
                          .addToStart(const SizedBox(height: 24.0))
                          .addToEnd(const SizedBox(height: 24.0)),
                    );
                  } else {
                    return EmptyStateWidget(
                      icon: FaIcon(
                        FontAwesomeIcons.solidHeart,
                        color: AppColors.neutral800,
                        size: 100.0,
                      ),
                      title: 'Your wishlist is empty',
                      description:
                          'Tap the heart on any item to save it here for later.',
                      hasButton: true,
                      buttonText: 'Browse Items',
                      buttonAction: () async {
                        context.goNamed(
                          BrowseWidget.routeName,
                          extra: <String, dynamic>{
                            kTransitionInfoKey: TransitionInfo(
                              hasTransition: true,
                              transitionType: PageTransitionType.fade,
                              duration: Duration.zero,
                            ),
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
            NavBarWidget(),
          ],
        ),
      ),
    );
  }
}
