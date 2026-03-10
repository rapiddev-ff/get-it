import '/features/auth/data/supabase_auth/auth_util.dart';
import '/features/messages/domain/models/conversation_model.dart';
import '/features/messages/domain/models/message_model.dart';
import '/features/home/presentation/widgets/empty_state/empty_state_widget.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/core/utils/value_utils.dart';
import '/core/utils/upload_data.dart';
import '/core/utils/uploaded_file.dart';
import '/core/widgets/dismiss_keyboard.dart';
import '/features/messages/presentation/widgets/chat_item/chat_item_widget.dart';
import '/features/messages/presentation/widgets/chat_more/chat_more_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/features/home/presentation/pages/home_seller_profile/home_seller_profile_widget.dart';
import '/features/messages/presentation/pages/chat_buyer_profile/chat_buyer_profile_widget.dart';
import '/features/home/presentation/pages/home_product/home_product_widget.dart';
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ChatPageWidget extends ConsumerStatefulWidget {
  const ChatPageWidget({
    super.key,
    required this.conversation,
  });

  final Conversation? conversation;

  static String routeName = 'chatPage';
  static String routePath = 'chatPage';

  @override
  ConsumerState<ChatPageWidget> createState() => _ChatPageWidgetState();
}

class _ChatPageWidgetState extends ConsumerState<ChatPageWidget> {
  final _textController = TextEditingController();
  final _textFieldFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _textFieldFocusNode.addListener(_onFocusChange);

    // Mark messages as read on page load.
    // InfiniteMessageList handles loading & realtime subscription internally.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await actions.markMessagesAsRead(
        ref,
        widget.conversation!.id,
      );
    });
  }

  void _onFocusChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _textFieldFocusNode.removeListener(_onFocusChange);
    _textFieldFocusNode.dispose();
    _textController.dispose();

    // Refresh conversations list in the background when leaving chat
    actions.refreshConversations(ref);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        backgroundColor: AppColors.backgroundSecondary,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56.0),
          child: AppBar(
            backgroundColor: AppColors.backgroundSecondary,
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: AppColors.info,
                    size: 24.0,
                  ),
                  onPressed: () async {
                    context.pop();
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 18.0),
                    child: InkWell(
                      onTap: () async {
                        if (widget.conversation?.buyerId == currentUserUid) {
                          context.pushNamed(
                            HomeSellerProfileWidget.routeName,
                            queryParameters: {
                              'sellerId': widget.conversation?.sellerId ?? '',
                            },
                          );
                        } else {
                          context.pushNamed(
                            ChatBuyerProfileWidget.routeName,
                            queryParameters: {
                              'buyerId': widget.conversation?.buyerId ?? '',
                            },
                          );
                        }
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 36.0,
                            height: 36.0,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Image.network(
                              valueOrDefault<String>(
                                widget.conversation?.otherUserAvatar,
                                'https://media.istockphoto.com/id/1223671392/vector/default-profile-picture-avatar-photo-placeholder-vector-illustration.jpg?s=612x612&w=0&k=20&c=s0aTdmT5aU6b8ot7VKm11DeID6NctRCpB755rA1BIP0=',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text(
                                valueOrDefault<String>(
                                  widget.conversation?.otherUserUsername,
                                  'N/A',
                                ),
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.0,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Builder(
                  builder: (context) => IconButton(
                    icon: Icon(
                      Icons.more_vert,
                      color: AppColors.info,
                      size: 20.0,
                    ),
                    onPressed: () async {
                      await showAlignedDialog(
                        context: context,
                        isGlobal: false,
                        avoidOverflow: true,
                        targetAnchor: AlignmentDirectional(-4.0, 5.5)
                            .resolve(Directionality.of(context)),
                        followerAnchor: Alignment.center
                            .resolve(Directionality.of(context)),
                        builder: (dialogContext) {
                          return Material(
                            color: Colors.transparent,
                            child: GestureDetector(
                              onTap: () {
                                FocusScope.of(dialogContext).unfocus();
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              child: ChatMoreWidget(
                                conversationId: widget.conversation!.id,
                                userId: widget.conversation!.otherUserId,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            if (widget.conversation?.productId != null &&
                widget.conversation?.productId != '')
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.backgroundSecondary,
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 10.0, top: 16.0, right: 16.0, bottom: 16.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4.0),
                        child: Image.network(
                          valueOrDefault<String>(
                            widget.conversation?.productImage,
                            'https://media.istockphoto.com/id/1223671392/vector/default-profile-picture-avatar-photo-placeholder-vector-illustration.jpg?s=612x612&w=0&k=20&c=s0aTdmT5aU6b8ot7VKm11DeID6NctRCpB755rA1BIP0=',
                          ),
                          width: 66.0,
                          height: 66.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              valueOrDefault<String>(
                                widget.conversation?.productTitle,
                                'N/A ',
                              ),
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 14.0,
                                height: 1.5,
                              ),
                            ),
                            Text(
                              valueOrDefault<String>(
                                widget.conversation?.productCondition,
                                'n/a',
                              ),
                              maxLines: 1,
                              style: GoogleFonts.inter(
                                color: AppColors.textSecondary,
                                fontSize: 12.0,
                                height: 1.5,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              NumberFormat('#,##0.##', 'en_US')
                                  .format(widget.conversation!.productPrice),
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 14.0,
                                height: 1.5,
                              ),
                            ),
                          ].divide(SizedBox(height: 2.0)),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          context.pushNamed(
                            HomeProductWidget.routeName,
                            queryParameters: {
                              'productId': widget.conversation?.productId ?? '',
                            },
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF7D56FF), Color(0xFF6187F1)],
                              stops: [0.0, 1.0],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 10.0),
                            child: Text(
                              'View Item',
                              style: GoogleFonts.inter(
                                fontSize: 14.0,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ].divide(SizedBox(width: 12.0)),
                  ),
                ),
              ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.backgroundPrimary,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: custom_widgets.InfiniteMessageList(
                      width: double.infinity,
                      height: double.infinity,
                      conversationId: widget.conversation!.id,
                      pageSize: 30,
                      loadMoreThreshold: 300.0,
                      itemBuilder: (Message message) => ChatItemWidget(
                        messageDataType: message,
                      ),
                      loadingIndicator: () => EmptyStateWidget(
                        icon: FaIcon(
                          FontAwesomeIcons.solidMessage,
                          color: Color(0xFF676767),
                          size: 100.0,
                        ),
                        title: 'No messages yet',
                        description: 'Send first message',
                        hasButton: false,
                        sidePadding: 0.0,
                        buttonAction: () async {},
                      ),
                      emptyWidget: () => EmptyStateWidget(
                        icon: FaIcon(
                          FontAwesomeIcons.solidMessage,
                          color: AppColors.neutral800,
                          size: 100.0,
                        ),
                        title: 'No messages yet',
                        description: 'Send first message',
                        hasButton: false,
                        sidePadding: 0.0,
                        buttonAction: () async {},
                      ),
                    ),
                  ),
                ),
              ),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 50.0,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      child: TextFormField(
                        controller: _textController,
                        focusNode: _textFieldFocusNode,
                        onChanged: (_) => setState(() {}),
                        autofocus: false,
                        obscureText: false,
                        decoration: InputDecoration(
                          isDense: false,
                          hintText: 'Type a message...',
                          hintStyle: GoogleFonts.inter(
                            fontWeight: FontWeight.normal,
                            fontSize: 16.0,
                            color: AppColors.textSecondary,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.neutral700,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.secondary,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.error,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.error,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                        ),
                        style: GoogleFonts.inter(fontSize: 14.0),
                        keyboardType: TextInputType.text,
                        cursorColor: AppColors.textPrimary,
                        enableInteractiveSelection: true,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 16.0),
                        child: InkWell(
                          onTap: () async {
                            final selectedMedia = await selectMedia(
                              mediaSource: MediaSource.photoGallery,
                              multiImage: true,
                            );
                            if (selectedMedia != null &&
                                selectedMedia.every((m) => validateFileFormat(
                                    m.storagePath, context))) {
                              final selectedUploadedFiles = selectedMedia
                                  .map((m) => UploadedFile(
                                        name: m.storagePath.split('/').last,
                                        bytes: m.bytes,
                                        height: m.dimensions?.height,
                                        width: m.dimensions?.width,
                                        blurHash: m.blurHash,
                                        originalFilename: m.originalFilename,
                                      ))
                                  .toList();

                              if (selectedUploadedFiles.isNotEmpty &&
                                  (selectedUploadedFiles
                                          .first.bytes?.isNotEmpty ??
                                      false)) {
                                await actions.uploadAndSendImages(
                                  ref,
                                  widget.conversation!.id,
                                  selectedUploadedFiles,
                                );
                              }
                            }
                          },
                          child: FaIcon(
                            FontAwesomeIcons.camera,
                            color: AppColors.textPrimary,
                            size: 24.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                final text = _textController.text.trim();
                if (text.isEmpty) return;
                _textController.clear();
                await actions.sendMessage(
                  ref,
                  widget.conversation!.id,
                  text,
                  [],
                );
              },
              child: Container(
                width: 38.0,
                height: 38.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF7D56FF), Color(0xFF6187F1)],
                    stops: [0.0, 1.0],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.send,
                    color: AppColors.textPrimary,
                    size: 14.0,
                  ),
                ),
              ),
            ),
          ].divide(SizedBox(width: 12.0)),
        ),
      ),
    );
  }
}
