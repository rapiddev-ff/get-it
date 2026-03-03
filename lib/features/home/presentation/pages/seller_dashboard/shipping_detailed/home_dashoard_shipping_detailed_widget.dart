import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '/core/constants/app_constants.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';

class HomeDashoardShippingDetailedWidget extends StatefulWidget {
  const HomeDashoardShippingDetailedWidget({super.key});

  static String routeName = 'homeDashoardShippingDetailed';
  static String routePath = 'homeDashoardShippingDetailed';

  @override
  State<HomeDashoardShippingDetailedWidget> createState() =>
      _HomeDashoardShippingDetailedWidgetState();
}

class _HomeDashoardShippingDetailedWidgetState
    extends State<HomeDashoardShippingDetailedWidget> {
  String state = 'Shop';
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    textFieldFocusNode = FocusNode();
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
                  'Shipping',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                    color: AppColors.textPrimary,
                  ),
                ),
                Opacity(
                  opacity: 0.0,
                  child: IconButton(
                    icon: Icon(
                      Icons.notifications_none,
                      color: AppColors.info,
                      size: 20.0,
                    ),
                    iconSize: 40.0,
                    onPressed: null,
                  ),
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
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(1.0, 0.0, 0.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF111111),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 24.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundSecondary,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            10.0, 16.0, 16.0, 16.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4.0),
                              child: Image.network(
                                'https://picsum.photos/seed/357/600',
                                width: 66.0,
                                height: 66.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sold: Jan 28, 2025',
                                    maxLines: 1,
                                    style: GoogleFonts.inter(
                                      fontSize: 12.0,
                                      color: AppColors.textSecondary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '1998 Pok\u00e9mon Base Set Charizard',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.0,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    'PSA 9 Mint Condition',
                                    maxLines: 1,
                                    style: GoogleFonts.inter(
                                      fontSize: 12.0,
                                      color: AppColors.textSecondary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 4.0, 0.0, 0.0),
                                    child: Text(
                                      '\$2,450.00',
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.0,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                ].divide(SizedBox(height: 4.0)),
                              ),
                            ),
                          ].divide(SizedBox(width: 12.0)),
                        ),
                      ),
                    ),
                  ),
                ),
                Divider(
                  height: 1.0,
                  thickness: 1.0,
                  color: Color(0xFF363636),
                ),
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Text(
                          'Shipping Address',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_back,
                        color: AppColors.secondary,
                        size: 14.0,
                      ),
                      Text(
                        'Edit',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.0,
                          color: AppColors.secondary,
                        ),
                      ),
                    ].divide(SizedBox(width: 4.0)),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundSecondary,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'John Smith',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontSize: 14.0,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '123 Main Street, Apt 4B',
                            maxLines: 1,
                            style: GoogleFonts.inter(
                              fontSize: 12.0,
                              color: AppColors.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'New York, NY 10001',
                            maxLines: 1,
                            style: GoogleFonts.inter(
                              fontSize: 12.0,
                              color: AppColors.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'United States',
                            maxLines: 1,
                            style: GoogleFonts.inter(
                              fontSize: 12.0,
                              color: AppColors.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ].divide(SizedBox(height: 4.0)),
                      ),
                    ),
                  ),
                ),
                Divider(
                  height: 32.0,
                  thickness: 1.0,
                  color: Color(0xFF363636),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                  child: Text(
                    'Add Tracking #',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.normal,
                      fontSize: 15.0,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 0.0),
                  child: Container(
                    width: double.infinity,
                    child: TextFormField(
                      controller: textController,
                      focusNode: textFieldFocusNode,
                      onChanged: (_) => EasyDebounce.debounce(
                        'textController',
                        Duration(milliseconds: 100),
                        () => setState(() {}),
                      ),
                      autofocus: false,
                      enabled: true,
                      obscureText: false,
                      decoration: InputDecoration(
                        isDense: false,
                        hintText: 'Tracking number',
                        hintStyle: GoogleFonts.inter(
                          fontWeight: FontWeight.normal,
                          fontSize: 16.0,
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
                      ),
                      style: GoogleFonts.inter(
                        fontSize: 14.0,
                        color: AppColors.textPrimary,
                      ),
                      cursorColor: AppColors.textPrimary,
                      enableInteractiveSelection: true,
                    ),
                  ),
                ),
                Divider(
                  height: 48.0,
                  thickness: 1.0,
                  color: Color(0xFF363636),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.secondary, Color(0xFF6187F1)],
                          stops: [0.0, 1.0],
                          begin: AlignmentDirectional(0.0, -1.0),
                          end: AlignmentDirectional(0, 1.0),
                        ),
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 8.0, 16.0, 8.0),
                        child: Text(
                          'Requested',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 15.0,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ]
                      .addToStart(SizedBox(width: 16.0))
                      .addToEnd(SizedBox(width: 16.0)),
                ),
              ].addToEnd(SizedBox(height: 32.0)),
            ),
          ),
        ),
      ),
    );
  }
}
