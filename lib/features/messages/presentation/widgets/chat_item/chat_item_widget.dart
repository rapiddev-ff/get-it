import '/features/messages/domain/models/message_model.dart';
import '/core/constants/app_constants.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/date_utils.dart';
import '/core/utils/value_utils.dart';
import '/core/widgets/expanded_image_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import '/core/providers/current_user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:octo_image/octo_image.dart';

class ChatItemWidget extends ConsumerWidget {
  const ChatItemWidget({
    super.key,
    required this.messageDataType,
    this.onEdit,
    this.onDelete,
  });

  final Message? messageDataType;
  final void Function(Message message)? onEdit;
  final void Function(Message message)? onDelete;

  static const _defaultAvatar =
      'https://media.istockphoto.com/id/1223671392/vector/default-profile-picture-avatar-photo-placeholder-vector-illustration.jpg?s=612x612&w=0&k=20&c=s0aTdmT5aU6b8ot7VKm11DeID6NctRCpB755rA1BIP0=';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final message = messageDataType;
    if (message == null) return const SizedBox.shrink();

    final isMe = message.senderId == ref.read(currentUserIdProvider);
    final isImage = message.messageType == 'image';

    if (isMe) {
      return _buildOwnMessage(context, message, isImage);
    } else {
      return _buildOtherMessage(context, message, isImage);
    }
  }

  Widget _buildOwnMessage(BuildContext context, Message message, bool isImage) {
    return GestureDetector(
      onLongPress: (onEdit != null || onDelete != null) && message.messageType == 'text'
          ? () => _showMessageActions(context, message)
          : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isImage)
            _buildImageBubble(context, message)
          else
            Container(
              width: MediaQuery.sizeOf(context).width * 0.8,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
                  topLeft: Radius.circular(8.0),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Text(
                  message.content.isEmpty ? 'N/A' : message.content,
                  style: Theme.of(context).textTheme.bodyMedium!,
                ),
              ),
            ),
          _buildTimestamp(context, message),
        ],
      ),
    );
  }

  Widget _buildOtherMessage(
      BuildContext context, Message message, bool isImage) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAvatar(message.senderAvatar),
        const SizedBox(width: 12.0),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isImage)
                _buildImageBubble(context, message)
              else
                Container(
                  width: MediaQuery.sizeOf(context).width * 0.8,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundSecondary,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(8.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    child: Text(
                      message.content.isEmpty ? 'N/A' : message.content,
                      style: Theme.of(context).textTheme.bodyMedium!,
                    ),
                  ),
                ),
              _buildTimestamp(context, message),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar(String? avatarUrl) {
    return Container(
      width: 32.0,
      height: 32.0,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: CachedNetworkImage(
        imageUrl: valueOrDefault<String>(avatarUrl, _defaultAvatar),
        fit: BoxFit.cover,
        placeholder: (_, __) => const ColoredBox(color: AppColors.neutral800),
        errorWidget: (_, __, ___) =>
            const Icon(Icons.person, size: 20, color: AppColors.neutral700),
      ),
    );
  }

  Widget _buildTimestamp(BuildContext context, Message message) {
    final time = dateTimeFormat("jm", message.createdAt, locale: 'en');
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        message.isEdited ? '$time · edited' : time,
        style: Theme.of(context).textTheme.labelSmall!,
      ),
    );
  }

  void _showMessageActions(BuildContext context, Message message) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundSecondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onEdit != null)
              ListTile(
                leading: const Icon(Icons.edit, color: AppColors.textPrimary),
                title: Text('Edit', style: Theme.of(context).textTheme.bodyMedium),
                onTap: () {
                  Navigator.pop(ctx);
                  onEdit!(message);
                },
              ),
            if (onDelete != null)
              ListTile(
                leading: const Icon(Icons.delete_outline, color: AppColors.error),
                title: Text('Delete', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.error)),
                onTap: () {
                  Navigator.pop(ctx);
                  onDelete!(message);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageBubble(BuildContext context, Message message) {
    final imageUrl = message.imageUrl ?? '';
    return InkWell(
      onTap: () => Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          child: ExpandedImageView(
            image: OctoImage(
              placeholderBuilder: (_) => SizedBox.expand(
                child: Image(
                  image: BlurHashImage(AppConstants.blurHash),
                  fit: BoxFit.cover,
                ),
              ),
              image: CachedNetworkImageProvider(imageUrl),
              fit: BoxFit.contain,
            ),
            allowRotation: false,
            tag: imageUrl,
            useHeroAnimation: true,
          ),
        ),
      ),
      child: Hero(
        tag: imageUrl,
        transitionOnUserGestures: true,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: OctoImage(
            placeholderBuilder: (_) => SizedBox.expand(
              child: Image(
                image: BlurHashImage(AppConstants.blurHash),
                fit: BoxFit.cover,
              ),
            ),
            image: CachedNetworkImageProvider(imageUrl),
            width: MediaQuery.sizeOf(context).width * 0.8,
            height: 200.0,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
