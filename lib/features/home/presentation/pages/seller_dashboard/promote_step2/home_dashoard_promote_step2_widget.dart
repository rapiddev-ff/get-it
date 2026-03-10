import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:go_router/go_router.dart';

import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/app_gradient_button.dart';
import '/core/widgets/app_text_field.dart';
import '/core/widgets/dismiss_keyboard.dart';
import '/features/home/presentation/pages/home_page/home_page_widget.dart';

class HomeDashoardPromoteStep2Widget extends StatefulWidget {
  const HomeDashoardPromoteStep2Widget({super.key});

  static String routeName = 'homeDashoardPromoteStep2';
  static String routePath = 'homeDashoardPromoteStep2';

  @override
  State<HomeDashoardPromoteStep2Widget> createState() =>
      _HomeDashoardPromoteStep2WidgetState();
}

class _HomeDashoardPromoteStep2WidgetState
    extends State<HomeDashoardPromoteStep2Widget> {
  // Inlined model state
  String? state = '';
  String? dropDownValue;
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController3;

  @override
  void initState() {
    super.initState();

    textController1 ??= TextEditingController();
    textFieldFocusNode1 ??= FocusNode();
    textFieldFocusNode1!.addListener(() => setState(() {}));
    textController2 ??= TextEditingController();
    textFieldFocusNode2 ??= FocusNode();
    textFieldFocusNode2!.addListener(() => setState(() {}));
    textController3 ??= TextEditingController();
    textFieldFocusNode3 ??= FocusNode();
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

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        backgroundColor: AppColors.backgroundPrimary,
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
                  'Promote Product',
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
                    onPressed: null,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(1.0, 0.0, 0.0, 0.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              10.0, 16.0, 16.0, 16.0),
                          child: Row(
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
                                      '1998 Pokemon Base Set Charizard',
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
                                    Expanded(
                                      child: Padding(
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
                    child: Text(
                      'Choose Promotion Type',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                    child: InkWell(
                      onTap: () async {
                        state = 'Boost';
                        setState(() {});
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundSecondary,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Container(
                                width: 24.0,
                                height: 24.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Color(0xFF7B7B7B),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.arrow_back,
                                          color: AppColors.textPrimary,
                                          size: 16.0,
                                        ),
                                        Text(
                                          'Boost',
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16.0,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.secondary,
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                          ),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    8.0, 4.0, 8.0, 4.0),
                                            child: Text(
                                              'Popular',
                                              style: GoogleFonts.inter(
                                                fontSize: 12.0,
                                                color: AppColors.textPrimary,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ].divide(SizedBox(width: 8.0)),
                                    ),
                                    Text(
                                      'Increase visibility across the entire platform. Your product will appear more frequently in swipe feeds and search results.',
                                      style: GoogleFonts.inter(
                                        fontSize: 14.0,
                                        color: AppColors.textPrimary,
                                        height: 1.5,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.arrow_back,
                                          color: AppColors.textSecondary,
                                          size: 16.0,
                                        ),
                                        Text(
                                          'General reach boost',
                                          style: GoogleFonts.inter(
                                            fontSize: 14.0,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.secondary,
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                          ),
                                        ),
                                      ].divide(SizedBox(width: 8.0)),
                                    ),
                                  ].divide(SizedBox(height: 8.0)),
                                ),
                              ),
                            ].divide(SizedBox(width: 16.0)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundSecondary,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Container(
                              width: 24.0,
                              height: 24.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Color(0xFF7B7B7B),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.arrow_back,
                                        color: AppColors.textPrimary,
                                        size: 16.0,
                                      ),
                                      Text(
                                        'Sponsored Placement',
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16.0,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xFF3570FC),
                                          borderRadius:
                                              BorderRadius.circular(6.0),
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  8.0, 4.0, 8.0, 4.0),
                                          child: Text(
                                            'Targeted',
                                            style: GoogleFonts.inter(
                                              fontSize: 12.0,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ].divide(SizedBox(width: 8.0)),
                                  ),
                                  Text(
                                    'Target specific collectors interested in your product tags. Higher conversion rate for niche items.',
                                    style: GoogleFonts.inter(
                                      fontSize: 14.0,
                                      color: AppColors.textPrimary,
                                      height: 1.5,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.arrow_back,
                                        color: AppColors.textSecondary,
                                        size: 16.0,
                                      ),
                                      Text(
                                        'Tag-based targeting',
                                        style: GoogleFonts.inter(
                                          fontSize: 14.0,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.secondary,
                                          borderRadius:
                                              BorderRadius.circular(6.0),
                                        ),
                                      ),
                                    ].divide(SizedBox(width: 8.0)),
                                  ),
                                ].divide(SizedBox(height: 8.0)),
                              ),
                            ),
                          ].divide(SizedBox(width: 16.0)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 52.0, 16.0, 0.0),
                    child: Builder(
                      builder: (context) {
                        if (state == 'Boost') {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Select Duration',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18.0,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 16.0, 0.0, 0.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        width: 100.0,
                                        decoration: BoxDecoration(
                                          color: AppColors.secondary,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 12.0, 0.0, 16.0),
                                          child: Column(
                                            children: [
                                              Text(
                                                '3',
                                                style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 28.0,
                                                  color: AppColors.textPrimary,
                                                  height: 1.5,
                                                ),
                                              ),
                                              Text(
                                                'Days',
                                                style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16.0,
                                                  color: AppColors.textPrimary,
                                                  height: 1.5,
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 8.0, 0.0, 0.0),
                                                child: Text(
                                                  '\$9.99',
                                                  style: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 18.0,
                                                    color:
                                                        AppColors.textPrimary,
                                                    height: 1.5,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        width: 100.0,
                                        decoration: BoxDecoration(
                                          color: AppColors.secondary,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 12.0, 0.0, 16.0),
                                          child: Column(
                                            children: [
                                              Text(
                                                '7',
                                                style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 28.0,
                                                  color: AppColors.textPrimary,
                                                  height: 1.5,
                                                ),
                                              ),
                                              Text(
                                                'Days',
                                                style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14.0,
                                                  color: AppColors.textPrimary,
                                                  height: 1.5,
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 8.0, 0.0, 0.0),
                                                child: Text(
                                                  '\$19.99',
                                                  style: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 18.0,
                                                    color:
                                                        AppColors.textPrimary,
                                                    height: 1.5,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: AppColors.secondary,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 12.0, 0.0, 16.0),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    '14',
                                                    style: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 28.0,
                                                      color:
                                                          AppColors.textPrimary,
                                                      height: 1.5,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Days',
                                                    style: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 14.0,
                                                      color:
                                                          AppColors.textPrimary,
                                                      height: 1.5,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 8.0,
                                                                0.0, 0.0),
                                                    child: Text(
                                                      '\$34.99',
                                                      style: GoogleFonts.inter(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 18.0,
                                                        color: AppColors
                                                            .textPrimary,
                                                        height: 1.5,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Transform.translate(
                                            offset: Offset(0.0, -9.0),
                                            child: Align(
                                              alignment: AlignmentDirectional(
                                                  0.0, -1.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Color(0xFF7D56FF),
                                                      Color(0xFF6187F1)
                                                    ],
                                                    stops: [0.0, 1.0],
                                                    begin: AlignmentDirectional(
                                                        0.0, -1.0),
                                                    end: AlignmentDirectional(
                                                        0, 1.0),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.0),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          6.0, 2.0, 6.0, 2.0),
                                                  child: Text(
                                                    'Best Value',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 14.0,
                                                      color:
                                                          AppColors.textPrimary,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ].divide(SizedBox(width: 12.0)),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColors.backgroundSecondary,
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 24.0,
                                        height: 24.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Color(0xFF7B7B7B),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Product Update',
                                              style: GoogleFonts.inter(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.0,
                                                color: AppColors.textPrimary,
                                              ),
                                            ),
                                            Text(
                                              'Send updates about specific.\$0.25/recipient products',
                                              style: GoogleFonts.inter(
                                                fontSize: 14.0,
                                                color: AppColors.textPrimary,
                                                height: 1.5,
                                              ),
                                            ),
                                          ].divide(SizedBox(height: 8.0)),
                                        ),
                                      ),
                                    ].divide(SizedBox(width: 16.0)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 16.0, 0.0, 0.0),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: AppColors.backgroundSecondary,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 24.0,
                                          height: 24.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Color(0xFF7B7B7B),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'New Arrival Alert',
                                                style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16.0,
                                                  color: AppColors.textPrimary,
                                                ),
                                              ),
                                              Text(
                                                'Notify about new inventory',
                                                style: GoogleFonts.inter(
                                                  fontSize: 14.0,
                                                  color: AppColors.textPrimary,
                                                  height: 1.5,
                                                ),
                                              ),
                                            ].divide(SizedBox(height: 8.0)),
                                          ),
                                        ),
                                      ].divide(SizedBox(width: 16.0)),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 28.0, 0.0, 0.0),
                                child: Text(
                                  'Target Previous Buyers',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18.0,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 12.0, 0.0, 0.0),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: AppColors.backgroundSecondary,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 16.0, 16.0, 12.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Filter by:',
                                                style: GoogleFonts.inter(
                                                  fontSize: 16.0,
                                                  color: AppColors.textPrimary,
                                                  height: 1.5,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              '247 buyers found',
                                              style: GoogleFonts.inter(
                                                fontSize: 14.0,
                                                color: AppColors.textSecondary,
                                                height: 1.5,
                                              ),
                                            ),
                                          ].divide(SizedBox(width: 8.0)),
                                        ),
                                        Text(
                                          'Product Category',
                                          style: GoogleFonts.inter(
                                            fontSize: 15.0,
                                            color: AppColors.textPrimary,
                                            height: 1.5,
                                          ),
                                        ),
                                        DropdownButtonFormField<String>(
                                          initialValue: dropDownValue,
                                          items: [
                                            'Option 1',
                                            'Option 2',
                                            'Option 3'
                                          ]
                                              .map((e) => DropdownMenuItem(
                                                    value: e,
                                                    child: Text(e),
                                                  ))
                                              .toList(),
                                          onChanged: (val) => setState(
                                              () => dropDownValue = val),
                                          decoration: InputDecoration(
                                            hintText: 'Select category',
                                            hintStyle: GoogleFonts.inter(
                                              fontSize: 14.0,
                                              color: AppColors.textPrimary,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: AppColors.neutral700,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: AppColors.neutral700,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                            ),
                                            contentPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    12.0, 0.0, 12.0, 0.0),
                                          ),
                                          style: GoogleFonts.inter(
                                            fontSize: 14.0,
                                            color: AppColors.textPrimary,
                                          ),
                                          icon: Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: AppColors.textSecondary,
                                            size: 24.0,
                                          ),
                                          dropdownColor:
                                              AppColors.backgroundSecondary,
                                          isExpanded: true,
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 8.0, 0.0, 0.0),
                                          child: Text(
                                            'Character/Franchise',
                                            style: GoogleFonts.inter(
                                              fontSize: 15.0,
                                              color: AppColors.textPrimary,
                                              height: 1.5,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          child: TextFormField(
                                            controller: textController1,
                                            focusNode: textFieldFocusNode1,
                                            onChanged: (_) =>
                                                EasyDebounce.debounce(
                                              '_model.textController1',
                                              Duration(milliseconds: 100),
                                              () => setState(() {}),
                                            ),
                                            autofocus: false,
                                            enabled: true,
                                            obscureText: false,
                                            decoration: appInputDecoration(
                                              'e.g., Spider-Man, Pokemon',
                                            ),
                                            style: appTextFieldStyle,
                                            cursorColor: AppColors.textPrimary,
                                            enableInteractiveSelection: true,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 8.0, 0.0, 0.0),
                                          child: Text(
                                            'Purchase Date Range',
                                            style: GoogleFonts.inter(
                                              fontSize: 15.0,
                                              color: AppColors.textPrimary,
                                              height: 1.5,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                width: double.infinity,
                                                child: TextFormField(
                                                  controller: textController2,
                                                  focusNode:
                                                      textFieldFocusNode2,
                                                  onChanged: (_) =>
                                                      EasyDebounce.debounce(
                                                    '_model.textController2',
                                                    Duration(milliseconds: 100),
                                                    () => setState(() {}),
                                                  ),
                                                  autofocus: false,
                                                  enabled: true,
                                                  obscureText: false,
                                                  decoration:
                                                      appInputDecoration(
                                                    'MM/DD/YYYY',
                                                  ),
                                                  style: appTextFieldStyle,
                                                  cursorColor:
                                                      AppColors.textPrimary,
                                                  enableInteractiveSelection:
                                                      true,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                width: double.infinity,
                                                child: TextFormField(
                                                  controller: textController3,
                                                  focusNode:
                                                      textFieldFocusNode3,
                                                  onChanged: (_) =>
                                                      EasyDebounce.debounce(
                                                    '_model.textController3',
                                                    Duration(milliseconds: 100),
                                                    () => setState(() {}),
                                                  ),
                                                  autofocus: false,
                                                  enabled: true,
                                                  obscureText: false,
                                                  decoration:
                                                      appInputDecoration(
                                                    'MM/DD/YYYY',
                                                  ),
                                                  style: appTextFieldStyle,
                                                  cursorColor:
                                                      AppColors.textPrimary,
                                                  enableInteractiveSelection:
                                                      true,
                                                ),
                                              ),
                                            ),
                                          ].divide(SizedBox(width: 12.0)),
                                        ),
                                      ].divide(SizedBox(height: 8.0)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 32.0, 16.0, 0.0),
                    child: Text(
                      'Promotion Summary',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontSize: 18.0,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundSecondary,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 16.0, 16.0, 12.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Promotion Type',
                                    style: GoogleFonts.inter(
                                      fontSize: 15.0,
                                      color: AppColors.textPrimary,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                                Text(
                                  'Promotion Type',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0,
                                    color: AppColors.textPrimary,
                                    height: 1.5,
                                  ),
                                ),
                              ].divide(SizedBox(width: 8.0)),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Duration',
                                    style: GoogleFonts.inter(
                                      fontSize: 15.0,
                                      color: AppColors.textPrimary,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                                Text(
                                  '3 Days',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0,
                                    color: AppColors.textPrimary,
                                    height: 1.5,
                                  ),
                                ),
                              ].divide(SizedBox(width: 8.0)),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Estimated Reach',
                                    style: GoogleFonts.inter(
                                      fontSize: 15.0,
                                      color: AppColors.textPrimary,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                                Text(
                                  '2,500+ views',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0,
                                    color: AppColors.textPrimary,
                                    height: 1.5,
                                  ),
                                ),
                              ].divide(SizedBox(width: 8.0)),
                            ),
                            Divider(
                              height: 1.0,
                              thickness: 1.0,
                              color: Color(0xFF545454),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Total Cost',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18.0,
                                      color: AppColors.textPrimary,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                                Text(
                                  '\$9.99',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18.0,
                                    color: AppColors.textPrimary,
                                    height: 1.5,
                                  ),
                                ),
                              ].divide(SizedBox(width: 8.0)),
                            ),
                          ].divide(SizedBox(height: 12.0)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 48.0, 16.0, 0.0),
                    child: AppGradientButton(
                      text: 'Sponsor Product -\$86.45',
                      onPressed: () async {
                        context.goNamed(HomePageWidget.routeName);
                      },
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(0.0, -1.0),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                      child: Text(
                        'In-App Purchase',
                        style: GoogleFonts.inter(
                          fontSize: 14.0,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ].addToEnd(SizedBox(height: 32.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
