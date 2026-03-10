import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import 'password_component_model.dart';
export 'password_component_model.dart';

class PasswordComponentWidget extends StatefulWidget {
  const PasswordComponentWidget({
    super.key,
    bool? isActive,
    required this.text,
  }) : isActive = isActive ?? false;

  final bool isActive;
  final String? text;

  @override
  State<PasswordComponentWidget> createState() =>
      _PasswordComponentWidgetState();
}

class _PasswordComponentWidgetState extends State<PasswordComponentWidget> {
  late PasswordComponentModel _model;

  @override
  void initState() {
    super.initState();
    _model = PasswordComponentModel();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 22.0,
          height: 22.0,
          decoration: BoxDecoration(),
          child: Builder(
            builder: (context) {
              if (widget.isActive) {
                return Icon(
                  Icons.check_sharp,
                  color: Color(0xFF4ADE80),
                  size: 22.0,
                ).animate().fade(duration: 600.ms);
              } else {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Container(
                      width: 6.0,
                      height: 6.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ).animate().fade(duration: 600.ms),
                  ),
                );
              }
            },
          ),
        ),
        AnimatedDefaultTextStyle(
          style: GoogleFonts.inter(
            color: AppColors.textPrimary,
            fontSize: 14.0,
          ),
          duration: Duration(milliseconds: 600),
          curve: Curves.easeOut,
          child: Text(
            widget.text ?? 'N/A',
          ),
        ),
      ].divide(SizedBox(width: 12.0)),
    );
  }
}
