import '/features/messages/domain/models/message_model.dart';
import '/features/home/presentation/widgets/empty_state/empty_state_widget.dart';
import '/core/theme/app_colors.dart';
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
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '/core/providers/current_user_provider.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '/features/messages/domain/models/conversation_model.dart';

class ChatPageWidget extends ConsumerStatefulWidget {
  const ChatPageWidget({
    super.key,
    required this.conversation,
  });

  final Conversation? conversation;

  static const String routeName = 'chatPage';
  static const String routePath = 'chatPage';

  @override
  ConsumerState<ChatPageWidget> createState() => _ChatPageWidgetState();
}

class _ChatPageWidgetState extends ConsumerState<ChatPageWidget> {
  final _textController = TextEditingController();
  final _textFieldFocusNode = FocusNode();
  bool _isSending = false;

  static const _defaultAvatar =
      'https://media.istockphoto.com/id/1223671392/vector/default-profile-picture-avatar-photo-placeholder-vector-illustration.jpg?s=612x612&w=0&k=20&c=s0aTdmT5aU6b8ot7VKm11DeID6NctRCpB755rA1BIP0=';

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await actions.markMessagesAsRead(
        ref,
        widget.conversation!.id,
      );
    });
  }

  @override
  void dispose() {
    _textFieldFocusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        backgroundColor: AppColors.backgroundSecondary,
        appBar: _buildAppBar(),
        body: Column(
          children: [
            if (_hasProduct) _buildProductBanner(),
            Expanded(
              child: ColoredBox(
                color: AppColors.backgroundPrimary,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: custom_widgets.InfiniteMessageList(
                    width: double.infinity,
                    height: double.infinity,
                    conversationId: widget.conversation!.id,
                    pageSize: 30,
                    loadMoreThreshold: 300.0,
                    itemBuilder: (Message message) => ChatItemWidget(
                      messageDataType: message,
                    ),
                    loadingIndicator: _buildEmptyState,
                    emptyWidget: _buildEmptyState,
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

  bool get _hasProduct =>
      widget.conversation?.productId != null &&
      widget.conversation!.productId!.isNotEmpty;

  PreferredSizeWidget _buildAppBar() {
    final conv = widget.conversation;
    return PreferredSize(
      preferredSize: const Size.fromHeight(56.0),
      child: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.info, size: 24.0),
              onPressed: () => context.pop(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: InkWell(
                  onTap: () => _navigateToProfile(),
                  child: Row(
                    children: [
                      Container(
                        width: 36.0,
                        height: 36.0,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: CachedNetworkImage(
                          imageUrl: valueOrDefault<String>(
                            conv?.otherUserAvatar,
                            _defaultAvatar,
                          ),
                          fit: BoxFit.cover,
                          placeholder: (_, __) =>
                              const ColoredBox(color: AppColors.neutral800),
                          errorWidget: (_, __, ___) => const Icon(
                            Icons.person,
                            size: 24,
                            color: AppColors.neutral700,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            valueOrDefault<String>(
                              conv?.otherUserUsername,
                              'N/A',
                            ),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(height: 1.5),
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
                icon: const Icon(Icons.more_vert, color: AppColors.info, size: 20.0),
                onPressed: () => _showMoreMenu(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToProfile() {
    if (widget.conversation?.buyerId == ref.read(currentUserIdProvider)) {
      context.pushNamed(
        HomeSellerProfileWidget.routeName,
        queryParameters: {'sellerId': widget.conversation?.sellerId ?? ''},
      );
    } else {
      context.pushNamed(
        ChatBuyerProfileWidget.routeName,
        queryParameters: {'buyerId': widget.conversation?.buyerId ?? ''},
      );
    }
  }

  Future<void> _showMoreMenu(BuildContext context) async {
    await showAlignedDialog(
      context: context,
      isGlobal: false,
      avoidOverflow: true,
      targetAnchor: Alignment.bottomRight,
      followerAnchor: Alignment.topRight,
      builder: (dialogContext) {
        return Material(
          color: Colors.transparent,
          child: ChatMoreWidget(
            conversationId: widget.conversation!.id,
            userId: widget.conversation!.otherUserId,
          ),
        );
      },
    );
  }

  Widget _buildProductBanner() {
    final conv = widget.conversation!;
    return Container(
      width: double.infinity,
      color: AppColors.backgroundSecondary,
      padding:
          const EdgeInsets.only(left: 10.0, top: 16.0, right: 16.0, bottom: 16.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: CachedNetworkImage(
              imageUrl: valueOrDefault<String>(
                conv.productImage,
                _defaultAvatar,
              ),
              width: 66.0,
              height: 66.0,
              fit: BoxFit.cover,
              placeholder: (_, __) =>
                  const ColoredBox(color: AppColors.neutral800),
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  valueOrDefault<String>(conv.productTitle, 'N/A'),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.w500, height: 1.5),
                ),
                const SizedBox(height: 2.0),
                Text(
                  valueOrDefault<String>(conv.productCondition, 'n/a'),
                  maxLines: 1,
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(height: 1.5),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2.0),
                Text(
                  NumberFormat('#,##0.##', 'en_US').format(conv.productPrice),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.w500, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12.0),
          InkWell(
            onTap: () => context.pushNamed(
              HomeProductWidget.routeName,
              queryParameters: {'productId': conv.productId ?? ''},
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.brandPurple, AppColors.brandBlue],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(6.0),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
              child: Text(
                'View Item',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(height: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() => EmptyStateWidget(
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
      );

  Widget _buildMessageInput() {
    return Container(
      color: AppColors.backgroundSecondary,
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 50.0,
              child: Stack(
                children: [
                  TextFormField(
                    controller: _textController,
                    focusNode: _textFieldFocusNode,
                    textInputAction: TextInputAction.send,
                    onFieldSubmitted: (_) => _sendTextMessage(),
                    decoration: InputDecoration(
                      isDense: false,
                      hintText: 'Type a message...',
                      hintStyle: Theme.of(context).textTheme.labelLarge!,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: AppColors.neutral700, width: 1.0),
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: AppColors.secondary, width: 1.0),
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: AppColors.error, width: 1.0),
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: AppColors.error, width: 1.0),
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                    ),
                    style: Theme.of(context).textTheme.bodyMedium!,
                    keyboardType: TextInputType.text,
                    cursorColor: AppColors.textPrimary,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: InkWell(
                        onTap: _pickAndSendImages,
                        child: const FaIcon(
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
          const SizedBox(width: 12.0),
          InkWell(
            onTap: _sendTextMessage,
            child: Container(
              width: 38.0,
              height: 38.0,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.brandPurple, AppColors.brandBlue],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Icons.send, color: AppColors.textPrimary, size: 14.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendTextMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty || _isSending) return;
    _isSending = true;
    _textController.clear();
    try {
      await actions.sendMessage(
        ref,
        widget.conversation!.id,
        text,
        [],
      );
    } finally {
      _isSending = false;
    }
  }

  Future<void> _pickAndSendImages() async {
    final selectedMedia = await selectMedia(
      mediaSource: MediaSource.photoGallery,
      multiImage: true,
    );
    if (selectedMedia != null &&
        selectedMedia
            .every((m) => validateFileFormat(m.storagePath, context))) {
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
          (selectedUploadedFiles.first.bytes?.isNotEmpty ?? false)) {
        await actions.uploadAndSendImages(
          ref,
          widget.conversation!.id,
          selectedUploadedFiles,
        );
      }
    }
  }
}
