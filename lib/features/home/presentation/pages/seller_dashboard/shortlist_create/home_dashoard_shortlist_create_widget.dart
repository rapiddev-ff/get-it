import '/core/constants/app_constants.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/features/home/presentation/pages/seller_dashboard/shortlist_create_step2/home_dashoard_shortlist_create_step2_widget.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeDashoardShortlistCreateWidget extends StatefulWidget {
  const HomeDashoardShortlistCreateWidget({super.key});

  static String routeName = 'homeDashoardShortlistCreate';
  static String routePath = 'homeDashoardShortlistCreate';

  @override
  State<HomeDashoardShortlistCreateWidget> createState() =>
      _HomeDashoardShortlistCreateWidgetState();
}

class _HomeDashoardShortlistCreateWidgetState
    extends State<HomeDashoardShortlistCreateWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String state = 'Shop';

  TextEditingController? textController1;
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController2;
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController3;
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController4;
  FocusNode? textFieldFocusNode4;

  @override
  void initState() {
    super.initState();

    textController1 = TextEditingController();
    textFieldFocusNode1 = FocusNode();
    textFieldFocusNode1!.addListener(() => setState(() {}));
    textController2 = TextEditingController();
    textFieldFocusNode2 = FocusNode();
    textFieldFocusNode2!.addListener(() => setState(() {}));
    textController3 = TextEditingController();
    textFieldFocusNode3 = FocusNode();
    textFieldFocusNode3!.addListener(() => setState(() {}));
    textController4 = TextEditingController();
    textFieldFocusNode4 = FocusNode();
    textFieldFocusNode4!.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    textController1?.dispose();
    textFieldFocusNode1?.dispose();
    textController2?.dispose();
    textFieldFocusNode2?.dispose();
    textController3?.dispose();
    textFieldFocusNode3?.dispose();
    textController4?.dispose();
    textFieldFocusNode4?.dispose();
    super.dispose();
  }

  InputDecoration _buildInputDecoration(String hintText) {
    return InputDecoration(
      isDense: false,
      hintText: hintText,
      hintStyle: GoogleFonts.inter(
        fontSize: 16.0,
        color: AppColors.textSecondary,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.neutral700,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusTextField4),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.secondary,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusTextField4),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.error,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusTextField4),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.error,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusTextField4),
      ),
    );
  }

  TextStyle get _bodyStyle => GoogleFonts.inter(
        fontSize: 14.0,
        color: AppColors.textPrimary,
      );

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
                  style: IconButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  icon: Icon(
                    Icons.arrow_back,
                    color: AppColors.info,
                    size: 24.0,
                  ),
                  onPressed: () {
                    context.pop();
                  },
                ),
                Text(
                  'Create Shortlist',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                    color: AppColors.textPrimary,
                  ),
                ),
                Opacity(
                  opacity: 0.0,
                  child: IconButton(
                    style: IconButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
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
            actions: [],
            centerTitle: true,
            elevation: 0.0,
          ),
        ),
        body: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Shortlist Name',
                      style: GoogleFonts.inter(
                        fontSize: 15.0,
                        color: AppColors.textPrimary,
                        height: 1.5,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                      child: Container(
                        width: double.infinity,
                        child: TextFormField(
                          controller: textController1,
                          focusNode: textFieldFocusNode1,
                          onChanged: (_) => EasyDebounce.debounce(
                            '_model.textController1',
                            Duration(milliseconds: 100),
                            () => setState(() {}),
                          ),
                          autofocus: false,
                          enabled: true,
                          obscureText: false,
                          decoration:
                              _buildInputDecoration('e.g., Comic Con 2025'),
                          style: _bodyStyle,
                          cursorColor: AppColors.textPrimary,
                          enableInteractiveSelection: true,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                      child: Text(
                        'Event/Convention',
                        style: GoogleFonts.inter(
                          fontSize: 15.0,
                          color: AppColors.textPrimary,
                          height: 1.5,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                      child: Container(
                        width: double.infinity,
                        child: TextFormField(
                          controller: textController2,
                          focusNode: textFieldFocusNode2,
                          onChanged: (_) => EasyDebounce.debounce(
                            '_model.textController2',
                            Duration(milliseconds: 100),
                            () => setState(() {}),
                          ),
                          autofocus: false,
                          enabled: true,
                          obscureText: false,
                          decoration:
                              _buildInputDecoration('e.g., San Diego Comc Con'),
                          style: _bodyStyle,
                          cursorColor: AppColors.textPrimary,
                          enableInteractiveSelection: true,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Start Date',
                                  style: GoogleFonts.inter(
                                    fontSize: 15.0,
                                    color: AppColors.textPrimary,
                                    height: 1.5,
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  child: TextFormField(
                                    controller: textController3,
                                    focusNode: textFieldFocusNode3,
                                    onChanged: (_) => EasyDebounce.debounce(
                                      '_model.textController3',
                                      Duration(milliseconds: 100),
                                      () => setState(() {}),
                                    ),
                                    autofocus: false,
                                    enabled: true,
                                    obscureText: false,
                                    decoration:
                                        _buildInputDecoration('MM/DD/YYYY'),
                                    style: _bodyStyle,
                                    keyboardType: TextInputType.number,
                                    cursorColor: AppColors.textPrimary,
                                    enableInteractiveSelection: true,
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
                                  'End Date',
                                  style: GoogleFonts.inter(
                                    fontSize: 15.0,
                                    color: AppColors.textPrimary,
                                    height: 1.5,
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  child: TextFormField(
                                    controller: textController4,
                                    focusNode: textFieldFocusNode4,
                                    onChanged: (_) => EasyDebounce.debounce(
                                      '_model.textController4',
                                      Duration(milliseconds: 100),
                                      () => setState(() {}),
                                    ),
                                    autofocus: false,
                                    enabled: true,
                                    obscureText: false,
                                    decoration:
                                        _buildInputDecoration('MM/DD/YYYY'),
                                    style: _bodyStyle,
                                    keyboardType: TextInputType.number,
                                    cursorColor: AppColors.textPrimary,
                                    enableInteractiveSelection: true,
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
                      'Privacy Settings',
                      style: GoogleFonts.inter(
                        fontSize: 15.0,
                        color: AppColors.textPrimary,
                        height: 1.5,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: 22.0,
                            height: 22.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              border: Border.all(
                                color: AppColors.neutral700,
                              ),
                            ),
                          ),
                          Container(
                            width: 22.0,
                            height: 22.0,
                            decoration: BoxDecoration(
                              color: AppColors.secondary,
                              borderRadius: BorderRadius.circular(4.0),
                              border: Border.all(
                                color: AppColors.neutral700,
                              ),
                            ),
                            child: Align(
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Icon(
                                Icons.check_sharp,
                                color: Colors.white,
                                size: 12.0,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Allow public viewing',
                              style: GoogleFonts.inter(
                                fontSize: 14.0,
                                color: AppColors.textPrimary,
                              ),
                            ).animate().fade(duration: 600.ms),
                          ),
                        ].divide(SizedBox(width: 12.0)),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
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
                      onPressed: () {
                        context.pushNamed(
                            HomeDashoardShortlistCreateStep2Widget.routeName);
                      },
                      child: Text(
                        'Create Shortlist',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                    child: TextButton(
                      onPressed: () {
                        context.pop();
                      },
                      style: TextButton.styleFrom(
                        minimumSize: Size(double.infinity, 56.0),
                        backgroundColor: AppColors.backgroundPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          side: BorderSide(color: Color(0xFF545454)),
                        ),
                      ),
                      child: Text(
                        'Save as Draft',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 17.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ]
                .addToStart(SizedBox(height: 24.0))
                .addToEnd(SizedBox(height: 32.0)),
          ),
        ),
      ),
    );
  }
}
