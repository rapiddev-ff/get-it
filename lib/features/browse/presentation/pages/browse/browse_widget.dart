import '/features/browse/domain/models/browse_product_model.dart';
import '/features/browse/presentation/widgets/browse_products_item/browse_products_item_widget.dart';
import '/features/home/presentation/widgets/empty_state/empty_state_widget.dart';
import '/features/home/presentation/widgets/nav_bar/nav_bar_widget.dart';
import '/features/home/presentation/pages/home_product/home_product_widget.dart';
import '/features/notifications/presentation/pages/notification/notification_widget.dart';
import '/features/profile/presentation/pages/settings/settings_widget.dart';
import '/core/theme/app_colors.dart';
import '/core/constants/app_constants.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/dismiss_keyboard.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import '/core/providers/current_user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class BrowseWidget extends ConsumerStatefulWidget {
  const BrowseWidget({super.key});

  static String routeName = 'browse';
  static String routePath = 'browse';

  @override
  ConsumerState<BrowseWidget> createState() => _BrowseWidgetState();
}

class _BrowseWidgetState extends ConsumerState<BrowseWidget> {
  final _textController = TextEditingController();
  final _textFieldFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _textFieldFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _textFieldFocusNode.removeListener(_onFocusChange);
    _textFieldFocusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  ),
                  iconSize: 24.0,
                  icon: const Icon(
                    Icons.menu,
                    color: AppColors.info,
                  ),
                  onPressed: () {
                    context.pushNamed(SettingsWidget.routeName);
                  },
                ),
                Text(
                  AppConstants.appName,
                  style: Theme.of(context).textTheme.titleMedium!,
                ),
                IconButton(
                  style: IconButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  iconSize: 20.0,
                  icon: const FaIcon(
                    FontAwesomeIcons.solidBell,
                    color: AppColors.info,
                  ),
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: TextFormField(
                        controller: _textController,
                        focusNode: _textFieldFocusNode,
                        onChanged: (_) => setState(() {}),
                        autofocus: false,
                        decoration: InputDecoration(
                          hintText: 'Search products, characters, years...',
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
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 24.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: custom_widgets.BrowseProductsGrid(
                            width: double.infinity,
                            height: double.infinity,
                            userId: ref.read(currentUserIdProvider),
                            searchQuery: _textController.text,
                            categoryId: null,
                            subcategoryId: null,
                            crossAxisCount: 2,
                            childAspectRatio: 0.67,
                            crossAxisSpacing: 16.0,
                            mainAxisSpacing: 16.0,
                            paddingLeft: 0.0,
                            paddingRight: 0.0,
                            paddingTop: 0.0,
                            paddingBottom: 0.0,
                            pageSize: 20,
                            onProductTap: (productId) async {
                              HapticFeedback.lightImpact();

                              context.pushNamed(
                                HomeProductWidget.routeName,
                                queryParameters: {
                                  'productId': productId.toString(),
                                },
                              );
                            },
                            onTotalChanged: (total) async {},
                            itemBuilder: (BrowseProduct product) =>
                                BrowseProductsItemWidget(
                              browseDataType: product,
                            ),
                            emptyStateWidget: () => EmptyStateWidget(
                              icon: const Icon(
                                Icons.search_off,
                                color: AppColors.neutral800,
                                size: 140.0,
                              ),
                              title: 'No results for "${_textController.text}"',
                              description:
                                  'Try a different keyword or use fewer words.',
                              hasButton: true,
                              sidePadding: 0.0,
                              buttonText: 'Clear Search',
                              buttonAction: () async {
                                setState(() {
                                  _textController.clear();
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]
                      .addToStart(const SizedBox(height: 24.0))
                      .addToEnd(const SizedBox(height: 24.0)),
                ),
              ),
            ),
            NavBarWidget(),
          ],
        ),
      ),
    );
  }
}
