import '/core/constants/app_constants.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeDashoardShortlistAddWidget extends StatefulWidget {
  const HomeDashoardShortlistAddWidget({super.key});

  static String routeName = 'homeDashoardShortlistAdd';
  static String routePath = 'homeDashoardShortlistAdd';

  @override
  State<HomeDashoardShortlistAddWidget> createState() =>
      _HomeDashoardShortlistAddWidgetState();
}

class _HomeDashoardShortlistAddWidgetState
    extends State<HomeDashoardShortlistAddWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String state = 'Shop';
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;

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
                  'Add to Shortlist',
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
                      Icons.more_vert,
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
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
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
                              hintText: 'Search products, characters, years...',
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
                            style: GoogleFonts.inter(
                              fontSize: 14.0,
                              color: AppColors.textPrimary,
                            ),
                            cursorColor: AppColors.textPrimary,
                            enableInteractiveSelection: true,
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
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 24.0, 0.0, 0.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.backgroundSecondary,
                              borderRadius: BorderRadius.circular(100.0),
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  7.0, 7.0, 16.0, 7.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 22.0,
                                    height: 22.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Color(0xFF7B7B7B),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Select All',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15.0,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ].divide(SizedBox(width: 8.0)),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 24.0, 0.0, 0.0),
                          child: ListView(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColors.backgroundSecondary,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 12.0, 16.0, 12.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                        child: Image.network(
                                          'https://picsum.photos/seed/357/600',
                                          width: 56.0,
                                          height: 56.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'X-Men #1 (1963)',
                                              style: GoogleFonts.inter(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.0,
                                                color: AppColors.textPrimary,
                                              ),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  '\$3,200',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 14.0,
                                                    color: AppColors.textPrimary,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    'Qty 4',
                                                    maxLines: 1,
                                                    style: GoogleFonts.inter(
                                                      fontSize: 14.0,
                                                      color: AppColors.textSecondary,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ].divide(SizedBox(width: 32.0)),
                                            ),
                                          ].divide(SizedBox(height: 12.0)),
                                        ),
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Icon(
                                            Icons.remove_circle,
                                            color: AppColors.textPrimary,
                                            size: 24.0,
                                          ),
                                          Text(
                                            '0',
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16.0,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                          Icon(
                                            Icons.add_circle,
                                            color: AppColors.textPrimary,
                                            size: 24.0,
                                          ),
                                        ].divide(SizedBox(height: 12.0)),
                                      ),
                                    ].divide(SizedBox(width: 12.0)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]
                          .addToStart(SizedBox(height: 24.0))
                          .addToEnd(SizedBox(height: 24.0)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                child: Container(
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
                      'Add Product',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ].addToEnd(SizedBox(height: 32.0)),
          ),
        ),
      ),
    );
  }
}
