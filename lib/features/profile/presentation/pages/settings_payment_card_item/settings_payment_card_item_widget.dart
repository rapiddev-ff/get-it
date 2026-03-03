import '/backend/schema/structs/index.dart';
import '/features/home/presentation/widgets/dialog/dialog_widget.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/core/utils/value_utils.dart';
import '/custom_code/actions/index.dart' as actions;
import '/features/profile/presentation/pages/settings_payment_method_edit/settings_payment_method_edit_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'settings_payment_card_item_model.dart';
export 'settings_payment_card_item_model.dart';

class SettingsPaymentCardItemWidget extends StatefulWidget {
  const SettingsPaymentCardItemWidget({
    super.key,
    required this.paymentMethod,
    required this.index,
  });

  final PaymentMethodStruct? paymentMethod;
  final int? index;

  @override
  State<SettingsPaymentCardItemWidget> createState() =>
      _SettingsPaymentCardItemWidgetState();
}

class _SettingsPaymentCardItemWidgetState
    extends State<SettingsPaymentCardItemWidget> {
  late SettingsPaymentCardItemModel _model;

  @override
  void initState() {
    super.initState();
    _model = SettingsPaymentCardItemModel();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 21.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  FaIcon(
                    FontAwesomeIcons.ccVisa,
                    color: AppColors.textPrimary,
                    size: 24.0,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '\u2022\u2022\u2022\u2022 \u2022\u2022\u2022\u2022 \u2022\u2022\u2022\u2022 ${widget.paymentMethod?.card.last4}',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.normal,
                            fontSize: 14.0,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Expires ${widget.paymentMethod?.card.expMonth.toString()}/${widget.paymentMethod?.card.expYear.toString()}',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.normal,
                            fontSize: 12.0,
                            color: Color(0xFFAFAFB4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.paymentMethod?.isDefault ?? true)
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.backgroundSecondary,
                        borderRadius: BorderRadius.circular(4.0),
                        border: Border.all(
                          color: Colors.white,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Default',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.normal,
                            fontSize: 14.0,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                ].divide(SizedBox(width: 12.0)),
              ),
            ),
            Divider(
              height: 1.0,
              thickness: 1.0,
              color: Color(0xFF363636),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
              child: Text(
                'Billing Address:',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.normal,
                  fontSize: 12.0,
                  color: Color(0xFFAFAFB4),
                ),
              ),
            ),
            Text(
              valueOrDefault<String>(
                widget.paymentMethod?.billingDetails.name,
                'N/A',
              ),
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              '${valueOrDefault<String>(
                widget.paymentMethod?.billingDetails.addressLine1,
                'n/a',
              )}, ${valueOrDefault<String>(
                widget.paymentMethod?.billingDetails.addressLine2,
                'n/a',
              )}',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.normal,
                fontSize: 15.0,
                color: AppColors.textPrimary,
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 21.0, 0.0, 0.0),
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
                        context.pushNamed(
                          SettingsPaymentMethodEditWidget.routeName,
                          queryParameters: {
                            'paymentMethod':
                                widget.paymentMethod?.serialize().toString(),
                            'index': widget.index?.toString(),
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF363636),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Edit',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.normal,
                              fontSize: 14.0,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Builder(
                      builder: (context) => InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          await showDialog(
                            context: context,
                            builder: (dialogContext) {
                              return Dialog(
                                elevation: 0,
                                insetPadding: EdgeInsets.zero,
                                backgroundColor: Colors.transparent,
                                alignment: AlignmentDirectional(0.0, 0.0)
                                    .resolve(Directionality.of(context)),
                                child: DialogWidget(
                                  title: 'Delete Payment Method',
                                  subtitle:
                                      'Are you sure you want to remove this card? This action cannot be undone.',
                                  bgColor: Color(0x338E6CFF),
                                  icon: FaIcon(
                                    FontAwesomeIcons.trash,
                                    color: Color(0xFF8E6CFF),
                                    size: 20.0,
                                  ),
                                  actionText: 'Remove Card',
                                  action: () async {
                                    _model.deletePayment =
                                        await actions.deletePaymentMethod(
                                      widget.paymentMethod!.id,
                                    );
                                    if (_model.deletePayment!) {
                                      Navigator.pop(context);
                                    }
                                  },
                                ),
                              );
                            },
                          );

                          setState(() {});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            border: Border.all(
                              color: Color(0xFF545454),
                              width: 1.0,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Remove',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.normal,
                                fontSize: 14.0,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ].divide(SizedBox(width: 8.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
