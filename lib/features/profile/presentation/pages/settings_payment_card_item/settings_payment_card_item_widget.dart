import '/features/checkout/domain/models/payment_method_model.dart';
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

class SettingsPaymentCardItemWidget extends StatefulWidget {
  const SettingsPaymentCardItemWidget({
    super.key,
    required this.paymentMethod,
    required this.index,
  });

  final PaymentMethod? paymentMethod;
  final int? index;

  @override
  State<SettingsPaymentCardItemWidget> createState() =>
      _SettingsPaymentCardItemWidgetState();
}

class _SettingsPaymentCardItemWidgetState
    extends State<SettingsPaymentCardItemWidget> {
  bool? _deletePayment;

  @override
  void dispose() {
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
              padding: EdgeInsets.only(bottom: 21.0),
              child: Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.ccVisa,
                    color: AppColors.textPrimary,
                    size: 24.0,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '\u2022\u2022\u2022\u2022 \u2022\u2022\u2022\u2022 \u2022\u2022\u2022\u2022 ${widget.paymentMethod?.card?.last4 ?? ''}',
                          style: Theme.of(context).textTheme.bodyMedium!,
                        ),
                        Text(
                          'Expires ${widget.paymentMethod?.card?.expMonth.toString() ?? ''}/${widget.paymentMethod?.card?.expYear.toString() ?? ''}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  if (widget.paymentMethod?.isDefault ?? false)
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
                          style: Theme.of(context).textTheme.bodyMedium!,
                        ),
                      ),
                    ),
                ].divide(SizedBox(width: 12.0)),
              ),
            ),
            Divider(
              height: 1.0,
              thickness: 1.0,
              color: AppColors.surfaceDark,
            ),
            Padding(
              padding: EdgeInsets.only(top: 12.0),
              child: Text(
                'Billing Address:',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: AppColors.textSecondary),
              ),
            ),
            Text(
              valueOrDefault<String>(
                widget.paymentMethod?.billingDetails?.name,
                'N/A',
              ),
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.w500),
            ),
            Text(
              '${valueOrDefault<String>(
                widget.paymentMethod?.billingDetails?.addressLine1,
                'n/a',
              )}, ${valueOrDefault<String>(
                widget.paymentMethod?.billingDetails?.addressLine2,
                'n/a',
              )}',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.normal,
                fontSize: 15.0,
                color: AppColors.textPrimary,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 21.0),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
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
                          color: AppColors.surfaceDark,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Edit',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium!,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Builder(
                      builder: (context) => InkWell(
                        onTap: () async {
                          await showDialog(
                            context: context,
                            builder: (dialogContext) {
                              return Dialog(
                                elevation: 0,
                                insetPadding: EdgeInsets.zero,
                                backgroundColor: Colors.transparent,
                                alignment: Alignment.center
                                    .resolve(Directionality.of(context)),
                                child: DialogWidget(
                                  title: 'Delete Payment Method',
                                  subtitle:
                                      'Are you sure you want to remove this card? This action cannot be undone.',
                                  bgColor:
                                      AppColors.primary.withValues(alpha: 0.2),
                                  icon: FaIcon(
                                    FontAwesomeIcons.trash,
                                    color: AppColors.primary,
                                    size: 20.0,
                                  ),
                                  actionText: 'Remove Card',
                                  action: () async {
                                    _deletePayment =
                                        await actions.deletePaymentMethod(
                                      widget.paymentMethod!.id,
                                    );
                                    if (_deletePayment!) {
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
                              color: AppColors.neutral800,
                              width: 1.0,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Remove',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium!,
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
