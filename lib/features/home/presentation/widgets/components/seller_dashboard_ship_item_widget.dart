import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SellerDashboardShipItemWidget extends StatelessWidget {
  const SellerDashboardShipItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        context.pushNamed(HomeDashoardShippingDetailedWidget.routeName);
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
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
                      'X-Men #1 (1963)',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Sold to @collector_mike',
                      maxLines: 1,
                      style: GoogleFonts.inter(
                        color: AppColors.textSecondary,
                        fontSize: 12.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    RichText(
                      textScaler: MediaQuery.of(context).textScaler,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Order #XM001',
                            style: GoogleFonts.inter(
                              fontSize: 12.0,
                            ),
                          ),
                          TextSpan(
                            text: ' • ',
                            style: TextStyle(),
                          ),
                          TextSpan(
                            text: '\$450.00',
                            style: GoogleFonts.inter(
                              color: Color(0xFF689FFF),
                              fontSize: 12.0,
                            ),
                          )
                        ],
                        style: GoogleFonts.inter(),
                      ),
                    ),
                  ].divide(SizedBox(height: 2.0)),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(12.0, 8.0, 12.0, 8.0),
                  child: Text(
                    'Ship',
                    style: GoogleFonts.inter(),
                  ),
                ),
              ),
            ].divide(SizedBox(width: 12.0)),
          ),
        ),
      ),
    );
  }
}
