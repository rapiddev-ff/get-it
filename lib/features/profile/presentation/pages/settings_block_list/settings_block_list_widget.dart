import '/features/auth/data/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/features/profile/presentation/pages/settings_blocked_user_item/settings_blocked_user_item_widget.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'settings_block_list_model.dart';
export 'settings_block_list_model.dart';

class SettingsBlockListWidget extends StatefulWidget {
  const SettingsBlockListWidget({super.key});

  static String routeName = 'settingsBlockList';
  static String routePath = 'settingsBlockList';

  @override
  State<SettingsBlockListWidget> createState() =>
      _SettingsBlockListWidgetState();
}

class _SettingsBlockListWidgetState extends State<SettingsBlockListWidget> {
  late SettingsBlockListModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = SettingsBlockListModel();

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    _model.textFieldFocusNode!.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<BlockedUsersRow>>(
      stream: _model.settingsBlockListSupabaseStream ??= SupaFlow.client
          .from("blocked_users")
          .stream(primaryKey: ['id'])
          .eqOrNull(
            'blocker_id',
            currentUserUid,
          )
          .map((list) => list.map((item) => BlockedUsersRow(item)).toList()),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: AppColors.backgroundPrimary,
            body: Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primary,
                  ),
                ),
              ),
            ),
          );
        }
        List<BlockedUsersRow> settingsBlockListBlockedUsersRowList =
            snapshot.data!;

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
                'Block List',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
              actions: [],
              centerTitle: true,
              elevation: 0.0,
            ),
            body: SafeArea(
              top: true,
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Blocked Users',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                          height: 1.5,
                        ),
                      ),
                      Text(
                        'Manage who can contact and buy from you',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.normal,
                          color: AppColors.textSecondary,
                          fontSize: 14.0,
                          height: 1.5,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                        child: Container(
                          width: double.infinity,
                          child: TextFormField(
                            controller: _model.textController,
                            focusNode: _model.textFieldFocusNode,
                            onChanged: (_) => EasyDebounce.debounce(
                              '_model.textController',
                              Duration(milliseconds: 100),
                              () => setState(() {}),
                            ),
                            autofocus: false,
                            obscureText: false,
                            decoration: InputDecoration(
                              isDense: false,
                              hintText: 'Search blocked users...',
                              hintStyle: GoogleFonts.inter(
                                fontWeight: FontWeight.normal,
                                fontSize: 15.0,
                                color: AppColors.textSecondary,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.neutral700,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.secondary,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.error,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.error,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.white,
                                size: 24.0,
                              ),
                            ),
                            style: GoogleFonts.inter(
                              color: AppColors.textPrimary,
                            ),
                            cursorColor: AppColors.textPrimary,
                            enableInteractiveSelection: true,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                        child: Builder(
                          builder: (context) {
                            final blockedUsers =
                                settingsBlockListBlockedUsersRowList.toList();

                            return ListView.separated(
                              padding: EdgeInsets.zero,
                              primary: false,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: blockedUsers.length,
                              separatorBuilder: (_, __) =>
                                  SizedBox(height: 16.0),
                              itemBuilder: (context, blockedUsersIndex) {
                                return SettingsBlockedUserItemWidget(
                                  key: Key(
                                      'Key03s_${blockedUsersIndex}_of_${blockedUsers.length}'),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      Divider(
                        height: 48.0,
                        thickness: 2.0,
                        color: Color(0xFF363636),
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundSecondary,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: AppColors.primary,
                                size: 24.0,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'About Blocking',
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16.0,
                                        height: 1.5,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 8.0, 0.0, 0.0),
                                      child: Text(
                                        'Blocked users cannot send you messages, view your full profile, or purchase items from you. They won\'t be notified that they\'ve been blocked.',
                                        style: GoogleFonts.inter(
                                          fontSize: 14.0,
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ].divide(SizedBox(width: 12.0)),
                          ),
                        ),
                      ),
                    ].addToStart(SizedBox(height: 28.0)),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
