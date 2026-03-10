import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/core/theme/app_colors.dart';
import '/core/constants/app_constants.dart';
import '/core/widgets/app_gradient_button.dart';
import 'settings_business_model.dart';
export 'settings_business_model.dart';

class SettingsBusinessWidget extends StatefulWidget {
  const SettingsBusinessWidget({
    super.key,
    required this.action,
    String? title,
    String? hintText,
    required this.initialVal,
  })  : this.title = title ?? 'N/A',
        this.hintText = hintText ?? 'n/a';

  final Future Function(String? val)? action;
  final String title;
  final String hintText;
  final String? initialVal;

  @override
  State<SettingsBusinessWidget> createState() => _SettingsBusinessWidgetState();
}

class _SettingsBusinessWidgetState extends State<SettingsBusinessWidget> {
  late SettingsBusinessModel _model;

  @override
  void initState() {
    super.initState();
    _model = SettingsBusinessModel();

    _model.textController ??= TextEditingController(text: widget.initialVal);
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
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0.0),
          bottomRight: Radius.circular(0.0),
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 20.0,
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
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
                  enabled: true,
                  obscureText: false,
                  decoration: InputDecoration(
                    isDense: false,
                    hintText: widget.hintText,
                    hintStyle: GoogleFonts.inter(
                      fontWeight: FontWeight.normal,
                      fontSize: 16.0,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.neutral700,
                        width: 1.0,
                      ),
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusTextField4),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.secondary,
                        width: 1.0,
                      ),
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusTextField4),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.error,
                        width: 1.0,
                      ),
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusTextField4),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.error,
                        width: 1.0,
                      ),
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusTextField4),
                    ),
                  ),
                  style: GoogleFonts.inter(
                    fontSize: 14.0,
                  ),
                  cursorColor: AppColors.textPrimary,
                  enableInteractiveSelection: true,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
              child: AppGradientButton(
                text: 'Save',
                onPressed: () async {
                  await widget.action?.call(
                    _model.textController!.text,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
