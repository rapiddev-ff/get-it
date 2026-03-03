import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '/backend/schema/structs/index.dart';
import '/core/constants/app_constants.dart';
import '/features/home/presentation/widgets/empty_state/empty_state_widget.dart';
import '/features/home/presentation/widgets/nav_bar/nav_bar_widget.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/custom_code/actions/index.dart' as actions;
import '/features/auth/data/supabase_auth/auth_util.dart';
import '/features/browse/presentation/providers/browse_provider.dart';
import '/features/wishlist/presentation/pages/wishlist_item/wishlist_item_widget.dart';
import '/features/wishlist/presentation/providers/wishlist_provider.dart';
import '/index.dart';

class WishlistWidget extends ConsumerStatefulWidget {
  const WishlistWidget({super.key});

  static String routeName = 'wishlist';
  static String routePath = 'wishlist';

  @override
  ConsumerState<WishlistWidget> createState() => _WishlistWidgetState();
}

class _WishlistWidgetState extends ConsumerState<WishlistWidget> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _textController = TextEditingController();
  final _textFieldFocusNode = FocusNode();
  CategoryStruct? _choosenCategory;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await actions.initWishlistStream(currentUserUid);
    });
    _textFieldFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _textFieldFocusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  static List<ProductDetailsStruct> _filterProducts(
    List<ProductDetailsStruct> products,
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
        final title = (product.title ?? '').toLowerCase();
        final description = (product.description ?? '').toLowerCase();
        if (!title.contains(query) && !description.contains(query)) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final wishlistProducts = ref.watch(wishlistProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final categories = categoriesAsync.valueOrNull ?? [];

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.backgroundPrimary,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56.0),
          child: AppBar(
            backgroundColor: AppColors.backgroundSecondary,
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
                  icon: const Icon(Icons.menu, color: AppColors.info, size: 24.0),
                  onPressed: () {
                    context.pushNamed(SettingsWidget.routeName);
                  },
                ),
                Text(
                  'Wishlist',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                    color: AppColors.textPrimary,
                  ),
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
            centerTitle: true,
            elevation: 0.0,
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Builder(
                builder: (context) {
                  if (wishlistProducts.isNotEmpty) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 0.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: TextFormField(
                              controller: _textController,
                              focusNode: _textFieldFocusNode,
                              onChanged: (_) => EasyDebounce.debounce(
                                '_textController',
                                const Duration(milliseconds: 100),
                                () => setState(() {}),
                              ),
                              autofocus: false,
                              obscureText: false,
                              decoration: InputDecoration(
                                isDense: false,
                                hintText:
                                    'Search products, characters, years...',
                                hintStyle: GoogleFonts.inter(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15.0,
                                  color: AppColors.textSecondary,
                                ),
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
                              style: GoogleFonts.inter(
                                fontSize: 14.0,
                                color: AppColors.textPrimary,
                              ),
                              cursorColor: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 24.0, 0.0, 0.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    setState(() {
                                      _choosenCategory = null;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          _choosenCategory == null
                                              ? const Color(0xFF7D56FF)
                                              : AppColors.backgroundSecondary,
                                          _choosenCategory == null
                                              ? const Color(0xFF6187F1)
                                              : AppColors.backgroundSecondary,
                                        ],
                                        stops: const [0.0, 1.0],
                                        begin: const AlignmentDirectional(
                                            0.0, -1.0),
                                        end: const AlignmentDirectional(0, 1.0),
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              16.0, 8.0, 16.0, 8.0),
                                      child: Text(
                                        'All (${wishlistProducts.length})',
                                        style: GoogleFonts.inter(
                                          fontSize: 14.0,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                ...List.generate(categories.length,
                                    (categoriesIndex) {
                                  final categoriesItem =
                                      categories[categoriesIndex];
                                  return InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      setState(() {
                                        _choosenCategory = categoriesItem;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            _choosenCategory == categoriesItem
                                                ? const Color(0xFF7D56FF)
                                                : AppColors.backgroundSecondary,
                                            _choosenCategory == categoriesItem
                                                ? const Color(0xFF6187F1)
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
                                        padding:
                                            const EdgeInsetsDirectional.fromSTEB(
                                                16.0, 8.0, 16.0, 8.0),
                                        child: Text(
                                          categoriesItem.name,
                                          style: GoogleFonts.inter(
                                            fontSize: 14.0,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).divide(const SizedBox(width: 8.0)),
                              ]
                                  .divide(const SizedBox(width: 8.0))
                                  .addToStart(const SizedBox(width: 16.0))
                                  .addToEnd(const SizedBox(width: 16.0)),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16.0, 24.0, 16.0, 0.0),
                            child: Builder(
                              builder: (context) {
                                final wishlist = _filterProducts(
                                  wishlistProducts,
                                  _textController.text,
                                  _choosenCategory?.id,
                                );
                                if (wishlist.isEmpty) {
                                  return Center(
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: EmptyStateWidget(
                                        icon: Icon(
                                          Icons.search_off,
                                          color: AppColors.neutral800,
                                          size: 100.0,
                                        ),
                                        title: 'No matches',
                                        description:
                                            'We couldn\'t find anyone matching "${_textController.text}".',
                                        hasButton: true,
                                        sidePadding: 16.0,
                                        buttonText: 'Clear Search',
                                        buttonAction: () async {
                                          setState(() {
                                            _textController.clear();
                                          });
                                        },
                                      ),
                                    ),
                                  );
                                }

                                return MasonryGridView.builder(
                                  physics:
                                      const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                  ),
                                  crossAxisSpacing: 24.0,
                                  mainAxisSpacing: 24.0,
                                  itemCount: wishlist.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, wishlistIndex) {
                                    final wishlistItem =
                                        wishlist[wishlistIndex];
                                    return InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () {
                                        context.pushNamed(
                                          HomeProductWidget.routeName,
                                          queryParameters: {
                                            'productId':
                                                wishlistItem.id ?? '',
                                          },
                                        );
                                      },
                                      child: WishlistItemWidget(
                                        key: Key(
                                            'Key1b2_${wishlistIndex}_of_${wishlist.length}'),
                                        productDataType: wishlistItem,
                                        actionWishlish: () async {
                                          await actions.toggleWishlist(
                                            currentUserUid,
                                            wishlistItem.id,
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
                        context.goNamed(BrowseWidget.routeName);
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
