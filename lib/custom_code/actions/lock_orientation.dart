import 'package:flutter/services.dart';

Future lockOrientation() async {
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}
