import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import 'index.dart';
import 'package:flutter/material.dart';

import 'package:toastification/toastification.dart';

Future toastificationshow(
  // Add your function code here!
  BuildContext context,
  String title,
  String description,
  String? typeMessage,
) async {
  ToastificationType mapTypeToToastificationType(String? type) {
    if (type == null) return ToastificationType.success;
    switch (type.toLowerCase()) {
      case 'success':
        return ToastificationType.success;
      case 'error':
        return ToastificationType.error;
      case 'warning':
        return ToastificationType.warning;
      case 'info':
        return ToastificationType.info;
      default:
        return ToastificationType.success;
    }
  }

  toastification.show(
    context: context,
    type: mapTypeToToastificationType(typeMessage),
    style: ToastificationStyle.fillColored,
    title: Text(title),
    description: Text(description),
    icon: const Icon(Icons.done),
    alignment: Alignment.topCenter,
    autoCloseDuration: const Duration(seconds: 4),
    showProgressBar: false,
    animationBuilder: (
      BuildContext context,
      Animation<double> animation,
      Alignment alignment,
      Widget? child,
    ) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
    closeButtonShowType: CloseButtonShowType.onHover,
  );
}
