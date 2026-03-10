import 'package:flutter/material.dart';
import '/core/theme/app_colors.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '/core/utils/list_extensions.dart';

class PasswordComponentWidget extends StatelessWidget {
  const PasswordComponentWidget({
    super.key,
    bool? isActive,
    required this.text,
  }) : isActive = isActive ?? false;

  final bool isActive;
  final String? text;

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
              if (isActive) {
                return Icon(
                  Icons.check_sharp,
                  color: AppColors.statusSuccess,
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
          style: Theme.of(context).textTheme.bodyMedium!,
          duration: Duration(milliseconds: 600),
          curve: Curves.easeOut,
          child: Text(
            text ?? 'N/A',
          ),
        ),
      ].divide(SizedBox(width: 12.0)),
    );
  }
}
