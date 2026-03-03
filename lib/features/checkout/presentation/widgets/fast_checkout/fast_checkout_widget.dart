import '/backend/schema/structs/index.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';

class FastCheckoutWidget extends StatefulWidget {
  const FastCheckoutWidget({
    super.key,
    required this.feedProduct,
    required this.orderId,
  });

  final FeedProductStruct? feedProduct;
  final String? orderId;

  @override
  State<FastCheckoutWidget> createState() => _FastCheckoutWidgetState();
}

class _FastCheckoutWidgetState extends State<FastCheckoutWidget> {
  String? cancelResult;

  @override
  void initState() {
    super.initState();

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(
        Duration(
          milliseconds: 10000,
        ),
      );
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 95.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
              child: Text(
                'Remaining Daily Budget \$1,201.00 / \$2,500.00',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                  color: AppColors.textPrimary,
                  height: 1.5,
                ),
              ),
            ),
            Divider(
              height: 1.0,
              thickness: 1.0,
              color: Color(0xFF363636),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 20.0, 16.0, 20.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: Image.network(
                      'https://picsum.photos/seed/357/600',
                      width: 60.0,
                      height: 80.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                8.0, 4.0, 8.0, 4.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.shopping_cart_outlined,
                                  color: Colors.black,
                                  size: 12.0,
                                ),
                                Text(
                                  'Purchased',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                    fontSize: 12.0,
                                    height: 1.5,
                                  ),
                                ),
                              ].divide(SizedBox(width: 4.0)),
                            ),
                          ),
                        ),
                        Text(
                          'Charizard Base Set Shadowless',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.normal,
                            fontSize: 12.0,
                            color: AppColors.textPrimary,
                            height: 1.5,
                          ),
                        ),
                        Text(
                          '\$1,299.00',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.0,
                            color: AppColors.textPrimary,
                            height: 1.5,
                          ),
                        ),
                      ].divide(SizedBox(height: 4.0)),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      cancelResult = await actions.refundOrderAction(
                        widget.orderId!,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            cancelResult!,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          duration: Duration(milliseconds: 4000),
                          backgroundColor: AppColors.secondary,
                        ),
                      );
                      Navigator.pop(context);

                      setState(() {});
                    },
                    child: Text(
                      'Undo',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                        fontSize: 14.0,
                        decoration: TextDecoration.underline,
                        height: 1.5,
                      ),
                    ),
                  ),
                ].divide(SizedBox(width: 12.0)),
              ),
            ),
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
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
                  topLeft: Radius.circular(0.0),
                  topRight: Radius.circular(0.0),
                ),
              ),
              child: TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topLeft: Radius.circular(0.0),
                      topRight: Radius.circular(0.0),
                    ),
                  ),
                ),
                child: Text(
                  'Close',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                    fontSize: 14.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
