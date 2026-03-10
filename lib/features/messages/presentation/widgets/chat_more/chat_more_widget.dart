import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class ChatMoreWidget extends ConsumerStatefulWidget {
  const ChatMoreWidget({
    super.key,
    required this.conversationId,
    required this.userId,
  });

  final String? conversationId;
  final String? userId;

  @override
  ConsumerState<ChatMoreWidget> createState() => _ChatMoreWidgetState();
}

class _ChatMoreWidgetState extends ConsumerState<ChatMoreWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 203.0,
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () async {
                await actions.callRpc(
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
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 16.0),
                    child: Icon(
                      Icons.block_sharp,
                      color: AppColors.textPrimary,
                      size: 20.0,
                    ),
                  ),
                  Text(
                    'Block user',
                    style: GoogleFonts.inter(fontSize: 14.0),
                  ),
                ].divide(SizedBox(width: 16.0)),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 16.0),
                  child: Icon(
                    Icons.person_add_alt,
                    color: AppColors.textPrimary,
                    size: 20.0,
                  ),
                ),
                Text(
                  'Follow',
                  style: GoogleFonts.inter(fontSize: 14.0),
                ),
              ].divide(SizedBox(width: 16.0)),
            ),
            InkWell(
              onTap: () async {
                await actions.callRpc(
                  context,
                  'delete_conversation',
                  <String, String?>{
                    'p_conversation_id': widget.conversationId,
                  },
                );
                await actions.refreshConversations(ref);
                await actions.unsubscribeFromMessages();
                Navigator.pop(context);
                context.pop();
              },
              child: Row(
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 16.0),
                    child: FaIcon(
                      FontAwesomeIcons.trashCan,
                      color: AppColors.textPrimary,
                      size: 20.0,
                    ),
                  ),
                  Text(
                    'Delete chat',
                    style: GoogleFonts.inter(fontSize: 14.0),
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
