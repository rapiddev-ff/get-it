import '/features/home/presentation/widgets/components/follower_item_widget.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'settings_my_profile_followers_model.dart';
export 'settings_my_profile_followers_model.dart';

class SettingsMyProfileFollowersWidget extends StatefulWidget {
  const SettingsMyProfileFollowersWidget({super.key});

  static String routeName = 'settingsMyProfileFollowers';
  static String routePath = 'settingsMyProfileFollowers';

  @override
  State<SettingsMyProfileFollowersWidget> createState() =>
      _SettingsMyProfileFollowersWidgetState();
}

class _SettingsMyProfileFollowersWidgetState
    extends State<SettingsMyProfileFollowersWidget> {
  late SettingsMyProfileFollowersModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = SettingsMyProfileFollowersModel();

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();
    _model.textFieldFocusNode1!.addListener(() => setState(() {}));
    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();
    _model.textFieldFocusNode2!.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  InputDecoration _searchDecoration({required String hintText}) {
    return InputDecoration(
      isDense: false,
      hintText: hintText,
      hintStyle: GoogleFonts.inter(
        fontWeight: FontWeight.normal,
        fontSize: 15.0,
        color: AppColors.textSecondary,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.neutral700, width: 1.0),
        borderRadius: BorderRadius.circular(4.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.secondary, width: 1.0),
        borderRadius: BorderRadius.circular(4.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.error, width: 1.0),
        borderRadius: BorderRadius.circular(4.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.error, width: 1.0),
        borderRadius: BorderRadius.circular(4.0),
      ),
      prefixIcon: Icon(
        Icons.search,
        color: Colors.white,
        size: 24.0,
      ),
    );
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
        appBar: AppBar(
          backgroundColor: AppColors.backgroundSecondary,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 24.0,
            ),
            onPressed: () async {
              context.pop();
            },
          ),
          title: Text(
            'My Profile',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: double.infinity,
                height: 53.0,
                decoration: BoxDecoration(
                  color: AppColors.backgroundSecondary,
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            _model.state = 'Followers';
                            setState(() {});
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 10.0),
                                child: Text(
                                  'Followers',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.normal,
                                    color: _model.state == 'Followers'
                                        ? AppColors.textPrimary
                                        : Color(0xFFAFAFB4),
                                    height: 2.0,
                                  ),
                                ),
                              ),
                              Opacity(
                                opacity: (_model.state == 'Followers' ? 1 : 0)
                                    .toDouble(),
                                child: Container(
                                  width: double.infinity,
                                  height: 2.0,
                                  decoration: BoxDecoration(
                                    color: AppColors.secondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            _model.state = 'Following';
                            setState(() {});
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 10.0),
                                child: Text(
                                  'Following',
                                  style: GoogleFonts.inter(
                                    color: _model.state == 'Following'
                                        ? AppColors.textPrimary
                                        : Color(0xFFAFAFB4),
                                    height: 2.0,
                                  ),
                                ),
                              ),
                              Opacity(
                                opacity: (_model.state == 'Following' ? 1 : 0)
                                    .toDouble(),
                                child: Container(
                                  width: double.infinity,
                                  height: 2.0,
                                  decoration: BoxDecoration(
                                    color: AppColors.secondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                  child: Builder(
                    builder: (context) {
                      if (_model.state == 'Followers') {
                        return Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              child: TextFormField(
                                controller: _model.textController1,
                                focusNode: _model.textFieldFocusNode1,
                                onChanged: (_) => EasyDebounce.debounce(
                                  '_model.textController1',
                                  Duration(milliseconds: 100),
                                  () => setState(() {}),
                                ),
                                autofocus: false,
                                obscureText: false,
                                decoration:
                                    _searchDecoration(hintText: 'Search '),
                                style: GoogleFonts.inter(
                                  color: AppColors.textPrimary,
                                ),
                                cursorColor: AppColors.textPrimary,
                                enableInteractiveSelection: true,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 20.0, 0.0, 0.0),
                                child: ListView(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  children: [
                                    FollowerItemWidget(),
                                  ].divide(SizedBox(height: 16.0)),
                                ),
                              ),
                            ),
                          ].addToStart(SizedBox(height: 28.0)),
                        );
                      } else {
                        return Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              child: TextFormField(
                                controller: _model.textController2,
                                focusNode: _model.textFieldFocusNode2,
                                onChanged: (_) => EasyDebounce.debounce(
                                  '_model.textController2',
                                  Duration(milliseconds: 100),
                                  () => setState(() {}),
                                ),
                                autofocus: false,
                                obscureText: false,
                                decoration:
                                    _searchDecoration(hintText: 'Search'),
                                style: GoogleFonts.inter(
                                  color: AppColors.textPrimary,
                                ),
                                cursorColor: AppColors.textPrimary,
                                enableInteractiveSelection: true,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 20.0, 0.0, 0.0),
                                child: Center(
                                  child: Text(
                                    'No following users yet',
                                    style: GoogleFonts.inter(
                                      color: AppColors.textSecondary,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ].addToStart(SizedBox(height: 28.0)),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
