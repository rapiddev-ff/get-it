import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

import '/core/theme/app_colors.dart';
import '/core/constants/app_constants.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/app_gradient_button.dart';
import '/core/widgets/dismiss_keyboard.dart';
import '/features/home/presentation/pages/seller_dashboard/promote_step2/home_dashoard_promote_step2_widget.dart';

class HomeDashoardPromoteStep1Widget extends StatefulWidget {
  const HomeDashoardPromoteStep1Widget({super.key});

  static String routeName = 'homeDashoardPromoteStep1';
  static String routePath = 'homeDashoardPromoteStep1';

  @override
  State<HomeDashoardPromoteStep1Widget> createState() =>
      _HomeDashoardPromoteStep1WidgetState();
}

class _HomeDashoardPromoteStep1WidgetState
    extends State<HomeDashoardPromoteStep1Widget> {
  // Inlined model state
  String state = 'Shop';
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;

  @override
  void initState() {
    super.initState();

    textController ??= TextEditingController();
    textFieldFocusNode ??= FocusNode();
    textFieldFocusNode!.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    textController?.dispose();
    textFieldFocusNode?.dispose();
    super.dispose();
  }

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
                  onPressed: () async {
                    context.pop();
                  },
                ),
                Text(
                  'Choose Product to Promote',
                  style: Theme.of(context).textTheme.titleMedium!,
                ),
                Opacity(
                  opacity: 0.0,
                  child: IconButton(
                    icon: Icon(
                      Icons.notifications_none,
                      color: AppColors.info,
                      size: 20.0,
                    ),
                    onPressed: null,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        width: double.infinity,
                        child: TextFormField(
                          controller: textController,
                          focusNode: textFieldFocusNode,
                          onChanged: (_) => EasyDebounce.debounce(
                            '_model.textController',
                            Duration(milliseconds: 100),
                            () => setState(() {}),
                          ),
                          autofocus: false,
                          enabled: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            isDense: false,
                            hintText: 'Search inventory...',
                            hintStyle: GoogleFonts.inter(
                              fontSize: 15.0,
                              color: AppColors.textSecondary,
                            ),
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
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 24.0,
                            ),
                          ),
                          style: Theme.of(context).textTheme.bodyMedium!,
                          cursorColor: AppColors.textPrimary,
                          enableInteractiveSelection: true,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.secondary,
                                  AppColors.brandBlue
                                ],
                                stops: [0.0, 1.0],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(100.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Text(
                                'Requested',
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500, fontSize: 15.0),
                              ),
                            ),
                          ),
                        ]
                            .addToStart(SizedBox(width: 16.0))
                            .addToEnd(SizedBox(width: 16.0)),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 16.0, top: 24.0, right: 16.0),
                      child: MasonryGridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            SliverSimpleGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        itemCount: 0,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return [][index]();
                        },
                      ),
                    ),
                  ]
                      .addToStart(SizedBox(height: 24.0))
                      .addToEnd(SizedBox(height: 24.0)),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: AppGradientButton(
                  text: 'Promote',
                  onPressed: () async {
                    context.pushNamed(HomeDashoardPromoteStep2Widget.routeName);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
