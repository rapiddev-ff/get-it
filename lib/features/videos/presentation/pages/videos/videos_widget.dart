import '/features/home/presentation/widgets/nav_bar/nav_bar_widget.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/dismiss_keyboard.dart';
import 'package:flutter/material.dart';

class VideosWidget extends StatelessWidget {
  const VideosWidget({super.key});

  static String routeName = 'videos';
  static String routePath = 'videos';

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView(
                  child: Column(
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
