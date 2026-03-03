import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/features/auth/presentation/providers/auth_provider.dart';

class SettingsReferralWidget extends ConsumerStatefulWidget {
  const SettingsReferralWidget({super.key});

  static String routeName = 'settingsReferral';
  static String routePath = 'settingsReferral';

  @override
  ConsumerState<SettingsReferralWidget> createState() =>
      _SettingsReferralWidgetState();
}

class _SettingsReferralWidgetState
    extends ConsumerState<SettingsReferralWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(authProvider);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: AppColors.backgroundPrimary,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundPrimary,
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
            'Referral Code',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 18.0,
              color: Colors.white,
            ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.backgroundSecondary,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                20.0, 33.0, 20.0, 33.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                BarcodeWidget(
                                  data: userData.referralCode,
                                  barcode: Barcode.qrCode(),
                                  width: 250.0,
                                  height: 250.0,
                                  color: AppColors.textPrimary,
                                  backgroundColor: Colors.transparent,
                                  errorBuilder: (_context, _error) => SizedBox(
                                    width: 250.0,
                                    height: 250.0,
                                  ),
                                  drawText: true,
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 28.0, 0.0, 0.0),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF111111),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 25.0, 16.0, 25.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            'Get Paid To Share CardSmart',
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                          Text(
                                            'Share CardSmart with other vendors and earn commission every time they make a sale. ',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14.0,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ].divide(SizedBox(height: 8.0)),
                                      ),
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
                          print('Button pressed ...');
                        },
                        style: TextButton.styleFrom(
                          minimumSize: Size(double.infinity, 56.0),
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                        child: Text(
                          'Print QR Code',
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
                        onPressed: () {
                          print('Button pressed ...');
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
                          'Share Shortlist',
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
