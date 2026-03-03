import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '/core/theme/app_colors.dart';
import '/core/constants/app_constants.dart';
import '/core/utils/list_extensions.dart';
import '/custom_code/actions/index.dart' as actions;
import '/features/auth/domain/models/user_settings_model.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import 'settings_shipping_defaults_model.dart';
export 'settings_shipping_defaults_model.dart';

class SettingsShippingDefaultsWidget extends ConsumerStatefulWidget {
  const SettingsShippingDefaultsWidget({super.key});

  static String routeName = 'settingsShippingDefaults';
  static String routePath = 'settingsShippingDefaults';

  @override
  ConsumerState<SettingsShippingDefaultsWidget> createState() =>
      _SettingsShippingDefaultsWidgetState();
}

class _SettingsShippingDefaultsWidgetState
    extends ConsumerState<SettingsShippingDefaultsWidget> {
  late SettingsShippingDefaultsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  static String _formatDecimal(double? value) {
    if (value == null) return '';
    return NumberFormat('#,##0.##', 'en_US').format(value);
  }

  @override
  void initState() {
    super.initState();
    _model = SettingsShippingDefaultsModel();

    final userData = ref.read(authProvider);
    _model.textController1 ??= TextEditingController(
        text: _formatDecimal(
            userData.userSettings?.defaultFlatShippingRate));
    _model.textFieldFocusNode1 ??= FocusNode();
    _model.textFieldFocusNode1!.addListener(() => setState(() {}));
    _model.textController2 ??= TextEditingController(
        text: _formatDecimal(
            userData.userSettings?.defaultAdditionalItemFee));
    _model.textFieldFocusNode2 ??= FocusNode();
    _model.textFieldFocusNode2!.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

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
            'Shipping Defaults',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 18.0,
              color: Colors.white,
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
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 32.0, 16.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Shipping Cost',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 24.0,
                          height: 1.5,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                        child: Text(
                          'Applies to all your items by default. Products can override this.',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.normal,
                            fontSize: 14.0,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 0.0),
                        child: Text(
                          'Default Flat Shipping Rate',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.normal,
                            fontSize: 15.0,
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
                            controller: _model.textController1,
                            focusNode: _model.textFieldFocusNode1,
                            onChanged: (_) => EasyDebounce.debounce(
                              '_model.textController1',
                              Duration(milliseconds: 100),
                              () => setState(() {}),
                            ),
                            autofocus: false,
                            enabled: true,
                            obscureText: false,
                            decoration: InputDecoration(
                              isDense: false,
                              hintText: '\$ 0.00',
                              hintStyle: GoogleFonts.inter(
                                fontWeight: FontWeight.normal,
                                fontSize: 16.0,
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
                            ),
                            keyboardType: TextInputType.emailAddress,
                            cursorColor: AppColors.textPrimary,
                            enableInteractiveSelection: true,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                        child: Text(
                          'Charged once per order (first item).',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.normal,
                            fontSize: 14.0,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 0.0),
                        child: Text(
                          'Additional Item Fee',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.normal,
                            fontSize: 15.0,
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
                            controller: _model.textController2,
                            focusNode: _model.textFieldFocusNode2,
                            onChanged: (_) => EasyDebounce.debounce(
                              '_model.textController2',
                              Duration(milliseconds: 100),
                              () => setState(() {}),
                            ),
                            autofocus: false,
                            enabled: true,
                            obscureText: false,
                            decoration: InputDecoration(
                              isDense: false,
                              hintText: '\$ 0.00',
                              hintStyle: GoogleFonts.inter(
                                fontWeight: FontWeight.normal,
                                fontSize: 16.0,
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
                            ),
                            keyboardType: TextInputType.emailAddress,
                            cursorColor: AppColors.textPrimary,
                            enableInteractiveSelection: true,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                        child: Text(
                          'Added for each additional item.',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.normal,
                            fontSize: 14.0,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
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
                        onPressed: () async {
                          await Future.wait([
                            Future(() async {
                              _model.saveShippingSettings =
                                  await actions.callRpc(
                                context,
                                'save_seller_shipping_settings',
                                <String, double?>{
                                  'p_flat_rate': double.tryParse(
                                      _model.textController1!.text),
                                  'p_additional_item_fee': double.tryParse(
                                      _model.textController2!.text),
                                },
                              );
                            }),
                            Future(() async {
                              ref.read(authProvider.notifier).updateUser(
                                (e) => e.copyWith(
                                  userSettings: (e.userSettings ?? const UserSettings()).copyWith(
                                    defaultFlatShippingRate:
                                        double.tryParse(
                                            _model.textController1!.text) ?? 0.0,
                                    defaultAdditionalItemFee:
                                        double.tryParse(
                                            _model.textController2!.text) ?? 0.0,
                                  ),
                                ),
                              );
                              setState(() {});
                            }),
                          ]);
                          context.pop();

                          setState(() {});
                        },
                        style: TextButton.styleFrom(
                          minimumSize: Size(double.infinity, 56.0),
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                        child: Text(
                          'Save Shipping Cost',
                          style: GoogleFonts.inter(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                      child: OutlinedButton(
                        onPressed: () async {
                          context.pop();
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(double.infinity, 56.0),
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          backgroundColor: AppColors.backgroundPrimary,
                          side: BorderSide(
                            color: Color(0xFF545454),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 17.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ].addToEnd(SizedBox(height: 32.0)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
