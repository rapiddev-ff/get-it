import '/core/widgets/dismiss_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsTermsWidget extends StatelessWidget {
  const SettingsTermsWidget({super.key});

  static String routeName = 'settingsTerms';
  static String routePath = 'settingsTerms';

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(119.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              title: Padding(
                padding: EdgeInsets.only(bottom: 14.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_back_rounded,
                                color: Colors.white,
                                size: 24.0,
                              ),
                              iconSize: 44.0,
                              onPressed: () {
                                context.pop();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Text(
                        'Terms & Conditions',
                        style:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  fontSize: 28.0,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                      ),
                    ),
                  ],
                ),
              ),
              expandedTitleScale: 1.0,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 16.0, top: 32.0, right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Accepting The Terms',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.w500),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam sit amet ex mattis, lobortis ante vitae, bibendum ex. Vestibulum feugiat mi eu tincidunt congue. Nam viverra. Lorem ipsum dolor ',
                    style: Theme.of(context).textTheme.labelLarge!,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 24.0),
                  child: Text(
                    'Using CardSmart App',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam sit amet ex mattis, lobortis ante vitae, bibendum ex. Vestibulum feugiat mi eu tincidunt congue. Nam viverra. Lorem ipsum dolor ',
                    style: Theme.of(context).textTheme.labelLarge!,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
