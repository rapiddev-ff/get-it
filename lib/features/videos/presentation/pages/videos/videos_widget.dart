import '/features/home/presentation/widgets/nav_bar/nav_bar_widget.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/dismiss_keyboard.dart';
import 'package:flutter/material.dart';
import 'videos_model.dart';
export 'videos_model.dart';

class VideosWidget extends StatefulWidget {
  const VideosWidget({super.key});

  static String routeName = 'videos';
  static String routePath = 'videos';

  @override
  State<VideosWidget> createState() => _VideosWidgetState();
}

class _VideosWidgetState extends State<VideosWidget> {
  late VideosModel _model;

  @override
  void initState() {
    super.initState();
    _model = VideosModel();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        backgroundColor: AppColors.backgroundPrimary,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[]
                        .addToStart(SizedBox(height: 24.0))
                        .addToEnd(SizedBox(height: 24.0)),
                  ),
                ),
              ),
            ),
            NavBarWidget(),
          ],
        ),
      ),
    );
  }
}
