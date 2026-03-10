import '/custom_code/actions/index.dart' as actions;
import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeSellerProfileMoreWidget extends StatefulWidget {
  const HomeSellerProfileMoreWidget({
    super.key,
    required this.userId,
  });

  final String? userId;

  @override
  State<HomeSellerProfileMoreWidget> createState() =>
      _HomeSellerProfileMoreWidgetState();
}

class _HomeSellerProfileMoreWidgetState
    extends State<HomeSellerProfileMoreWidget> {
  dynamic blockUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 203.0,
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: FaIcon(
                    FontAwesomeIcons.share,
                    color: AppColors.textPrimary,
                    size: 20.0,
                  ),
                ),
                Text(
                  'Share Profile',
                  style: Theme.of(context).textTheme.bodyMedium!,
                ),
              ].divide(SizedBox(width: 16.0)),
            ),
            Divider(
              height: 1.0,
              thickness: 1.0,
              color: AppColors.neutral800,
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Icon(
                    Icons.person_add_alt,
                    color: AppColors.textPrimary,
                    size: 20.0,
                  ),
                ),
                Text(
                  'Follow User',
                  style: Theme.of(context).textTheme.bodyMedium!,
                ),
              ].divide(SizedBox(width: 16.0)),
            ),
            Divider(
              height: 1.0,
              thickness: 1.0,
              color: AppColors.neutral800,
            ),
            InkWell(
              onTap: () async {
                blockUser = await actions.callRpc(
                  context,
                  'block_user',
                  <String, String>{
                    'p_blocked_id': widget.userId!,
                  },
                );

                setState(() {});
              },
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Icon(
                      Icons.block_sharp,
                      color: AppColors.textPrimary,
                      size: 20.0,
                    ),
                  ),
                  Text(
                    'Block User',
                    style: Theme.of(context).textTheme.bodyMedium!,
                  ),
                ].divide(SizedBox(width: 16.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
