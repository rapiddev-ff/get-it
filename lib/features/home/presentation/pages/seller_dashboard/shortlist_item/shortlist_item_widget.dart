import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/features/home/presentation/pages/seller_dashboard/shortlist_add/home_dashoard_shortlist_add_widget.dart';

class ShortlistItemWidget extends StatelessWidget {
  const ShortlistItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(24.0, 20.0, 24.0, 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                          height: 1.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ].divide(SizedBox(height: 4.0)),
                  ),
                ),
                FaIcon(
                  FontAwesomeIcons.qrcode,
                  color: AppColors.primary,
                  size: 24.0,
                ),
              ].divide(SizedBox(width: 12.0)),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF363636),
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(12.0, 4.0, 12.0, 4.0),
                    child: Text(
                      'X-Men',
                      maxLines: 1,
                      style: GoogleFonts.inter(
                        fontSize: 12.0,
                        color: AppColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      context
                          .pushNamed(HomeDashoardShortlistAddWidget.routeName);
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF7D56FF), Color(0xFF6187F1)],
                          stops: [0.0, 1.0],
                          begin: AlignmentDirectional(0.0, -1.0),
                          end: AlignmentDirectional(0, 1.0),
                        ),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            0.0, 11.0, 0.0, 11.0),
                        child: Text(
                          'View',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 15.0,
                            color: AppColors.textPrimary,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xFF363636),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 11.0, 0.0, 11.0),
                      child: Text(
                        'Share',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 15.0,
                          color: AppColors.textPrimary,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xFF363636),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 11.0, 0.0, 11.0),
                      child: Text(
                        'Download',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 15.0,
                          color: AppColors.textPrimary,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ].divide(SizedBox(width: 12.0)),
            ),
          ].divide(SizedBox(height: 20.0)),
        ),
      ),
    );
  }
}
