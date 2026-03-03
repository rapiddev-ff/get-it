import '/core/constants/app_constants.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/features/home/presentation/pages/seller_dashboard/shortlist_add/home_dashoard_shortlist_add_widget.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class HomeDashoardShortlistCreateStep2Widget extends StatefulWidget {
  const HomeDashoardShortlistCreateStep2Widget({super.key});

  static String routeName = 'homeDashoardShortlistCreateStep2';
  static String routePath = 'homeDashoardShortlistCreateStep2';

  @override
  State<HomeDashoardShortlistCreateStep2Widget> createState() =>
      _HomeDashoardShortlistCreateStep2WidgetState();
}

class _HomeDashoardShortlistCreateStep2WidgetState
    extends State<HomeDashoardShortlistCreateStep2Widget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String state = 'Shop';
  bool? switchValue;

  TextEditingController? textController1;
  FocusNode? textFieldFocusNode1;
  late MaskTextInputFormatter textFieldMask1;
  TextEditingController? textController2;
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController3;
  FocusNode? textFieldFocusNode3;

  @override
  void initState() {
    super.initState();

    switchValue = true;
    textController1 = TextEditingController();
    textFieldFocusNode1 = FocusNode();
    textFieldFocusNode1!.addListener(() => setState(() {}));
    textFieldMask1 = MaskTextInputFormatter(mask: '##');
    textController2 = TextEditingController();
    textFieldFocusNode2 = FocusNode();
    textFieldFocusNode2!.addListener(() => setState(() {}));
    textController3 = TextEditingController();
    textFieldFocusNode3 = FocusNode();
    textFieldFocusNode3!.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    textController1?.dispose();
    textFieldFocusNode1?.dispose();
    textController2?.dispose();
    textFieldFocusNode2?.dispose();
    textController3?.dispose();
    textFieldFocusNode3?.dispose();
    super.dispose();
  }

  InputDecoration _buildInputDecoration(String hintText,
      {double fontSize = 16.0, Widget? prefixIcon}) {
    return InputDecoration(
      isDense: false,
      hintText: hintText,
      hintStyle: GoogleFonts.inter(
        fontSize: fontSize,
        color: AppColors.textSecondary,
      ),
      prefixIcon: prefixIcon,
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
                  'Shortlist',
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
                  ),
                  icon: Icon(
                    Icons.more_vert,
                    color: AppColors.info,
                    size: 20.0,
                  ),
                  onPressed: () {
                    print('IconButton pressed ...');
                  },
                ),
              ],
            ),
            actions: [],
            centerTitle: true,
            elevation: 0.0,
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF111111),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 24.0, 16.0, 24.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.backgroundSecondary,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                24.0, 20.0, 24.0, 20.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Comic Con 2025',
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20.0,
                                          color: AppColors.textPrimary,
                                          height: 1.5,
                                        ),
                                      ),
                                      Text(
                                        '24 items \u2022 Created Jan 15',
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
                                Icon(
                                  Icons.arrow_back,
                                  color: AppColors.textPrimary,
                                  size: 24.0,
                                ),
                              ].divide(SizedBox(width: 12.0)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Discount',
                                style: GoogleFonts.inter(
                                  fontSize: 15.0,
                                  color: AppColors.textPrimary,
                                  height: 1.5,
                                ),
                              ),
                              Switch.adaptive(
                                value: switchValue!,
                                onChanged: (newValue) async {
                                  setState(() => switchValue = newValue);
                                },
                                activeColor: AppColors.primary,
                                activeTrackColor: AppColors.primary,
                                inactiveTrackColor: AppColors.alternate,
                                inactiveThumbColor:
                                    AppColors.backgroundSecondary,
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 20.0, 0.0, 0.0),
                            child: Text(
                              'Discount Percentage',
                              style: GoogleFonts.inter(
                                fontSize: 15.0,
                                color: AppColors.textPrimary,
                                height: 1.5,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 8.0, 0.0, 0.0),
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
                                    _buildInputDecoration('% 0.00'),
                                style: _bodyStyle,
                                keyboardType: TextInputType.number,
                                cursorColor: AppColors.textPrimary,
                                enableInteractiveSelection: true,
                                inputFormatters: [textFieldMask1],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 24.0, 0.0, 0.0),
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
                                    _buildInputDecoration('Notes'),
                                style: _bodyStyle,
                                maxLines: null,
                                minLines: 4,
                                keyboardType: TextInputType.multiline,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Search Shortlist',
                                style: GoogleFonts.inter(
                                  fontSize: 15.0,
                                  color: AppColors.textPrimary,
                                  height: 1.5,
                                ),
                              ),
                              Text(
                                '0 Items',
                                style: GoogleFonts.inter(
                                  fontSize: 14.0,
                                  color: AppColors.textSecondary,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 16.0, 0.0, 0.0),
                            child: Container(
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
                                decoration: _buildInputDecoration(
                                  'Search your shortlist',
                                  fontSize: 15.0,
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Colors.white,
                                    size: 24.0,
                                  ),
                                ),
                                style: _bodyStyle,
                                cursorColor: AppColors.textPrimary,
                                enableInteractiveSelection: true,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 16.0, 0.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.secondary,
                                        Color(0xFF6187F1)
                                      ],
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
                              ],
                            ),
                          ),
                          Divider(
                            height: 44.0,
                            thickness: 1.0,
                            color: Color(0xFF363636),
                          ),
                          Text(
                            'Your Shortlist has no products added. ',
                            style: GoogleFonts.inter(
                              fontSize: 18.0,
                              color: AppColors.textPrimary,
                              height: 1.5,
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
                              onTap: () {
                                context.pushNamed(
                                    HomeDashoardShortlistAddWidget.routeName);
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.add_circle_outline,
                                    color: Color(0xFF9B85FF),
                                    size: 24.0,
                                  ),
                                  Text(
                                    'Add Products',
                                    style: GoogleFonts.inter(
                                      fontSize: 14.0,
                                      color: Color(0xFF9B85FF),
                                      height: 1.5,
                                    ),
                                  ),
                                ].divide(SizedBox(width: 8.0)),
                              ),
                            ),
                          ),
                        ].addToEnd(SizedBox(height: 24.0)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
              child: Column(
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
                        print('Button pressed ...');
                      },
                      child: Text(
                        'Create Shortlist',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 17.0,
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
            ),
          ].addToEnd(SizedBox(height: 32.0)),
        ),
      ),
    );
  }
}
