import '/features/messages/domain/models/conversation_model.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/date_utils.dart';
import '/core/utils/list_extensions.dart';
import '/core/utils/value_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '/core/providers/current_user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _defaultAvatar =
    'https://media.istockphoto.com/id/1223671392/vector/default-profile-picture-avatar-photo-placeholder-vector-illustration.jpg?s=612x612&w=0&k=20&c=s0aTdmT5aU6b8ot7VKm11DeID6NctRCpB755rA1BIP0=';

class MessageItemWidget extends ConsumerWidget {
  const MessageItemWidget({
    super.key,
    required this.conversationDataType,
  });

  final Conversation? conversationDataType;

  bool _hasUnread(WidgetRef ref) {
    final uid = ref.read(currentUserIdProvider);
    if ((conversationDataType?.buyerId == uid) &&
        (conversationDataType!.buyerUnreadCount > 0)) {
      return true;
    } else if ((conversationDataType?.sellerId == uid) &&
        (conversationDataType!.sellerUnreadCount > 0)) {
      return true;
    }
    return false;
  }

  String _unreadCount(WidgetRef ref) {
    final uid = ref.read(currentUserIdProvider);
    return valueOrDefault<String>(
      conversationDataType?.buyerId == uid
          ? conversationDataType?.buyerUnreadCount.toString()
          : conversationDataType?.sellerUnreadCount.toString(),
      '0',
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (conversationDataType?.productId != null &&
        conversationDataType?.productId != '') {
      return _buildProductConversation(context, ref);
    } else {
      return _buildDirectConversation(context, ref);
    }
  }

  Widget _buildProductConversation(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding:
              EdgeInsets.only(left: 10.0, top: 16.0, right: 16.0, bottom: 16.0),
          child: Row(
            children: [
              SizedBox(
                width: 65.0,
                height: 65.0,
                child: Stack(
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4.0),
                        child: CachedNetworkImage(
                          imageUrl: conversationDataType!.productImage ?? _defaultAvatar,
                          width: 56.0,
                          height: 56.0,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => const ColoredBox(color: AppColors.neutral800),
                          errorWidget: (_, __, ___) => const ColoredBox(color: AppColors.neutral800),
                        ),
                      ),
                    ),
                    if (_hasUnread(ref))
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          width: 20.0,
                          height: 20.0,
                          decoration: BoxDecoration(
                            color: AppColors.destructive500,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              _unreadCount(ref),
                              style: Theme.of(context).textTheme.bodySmall!,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 24.0,
                          height: 24.0,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: CachedNetworkImage(
                            imageUrl: conversationDataType?.otherUserAvatar ?? _defaultAvatar,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => const ColoredBox(color: AppColors.neutral800),
                            errorWidget: (_, __, ___) => const Icon(Icons.person, size: 16, color: AppColors.neutral700),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            valueOrDefault<String>(
                              conversationDataType?.otherUserUsername,
                              'N/A',
                            ),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(height: 1.5),
                          ),
                        ),
                        if (valueOrDefault<String>(
                              dateTimeFormat(
                                "relative",
                                conversationDataType?.lastMessageAt,
                                locale: 'en',
                              ),
                              '0 min',
                            ) !=
                            '')
                          Text(
                            valueOrDefault<String>(
                              dateTimeFormat(
                                "relative",
                                conversationDataType?.lastMessageAt,
                                locale: 'en',
                              ),
                              '0 min',
                            ),
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(height: 1.5),
                          ),
                      ].divide(SizedBox(width: 4.0)),
                    ),
                    if (valueOrDefault<String>(
                          conversationDataType?.productTitle,
                          'N/A',
                        ) !=
                        '')
                      Text(
                        valueOrDefault<String>(
                          conversationDataType?.productTitle,
                          'N/A',
                        ),
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontWeight: FontWeight.w500, height: 1.5),
                      ),
                    if (valueOrDefault<String>(
                          conversationDataType?.lastMessageText,
                          'n/a ',
                        ) !=
                        '')
                      Text(
                        conversationDataType!.lastMessageText ?? '',
                        maxLines: 1,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(height: 1.5),
                      ),
                  ].divide(SizedBox(height: 4.0)),
                ),
              ),
            ].divide(SizedBox(width: 12.0)),
          ),
        ),
        Divider(
          height: 1.0,
          thickness: 1.0,
          color: AppColors.surfaceDark,
        ),
      ],
    );
  }

  Widget _buildDirectConversation(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding:
              EdgeInsets.only(left: 10.0, top: 16.0, right: 16.0, bottom: 16.0),
          child: Row(
            children: [
              SizedBox(
                width: 65.0,
                height: 65.0,
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        width: 56.0,
                        height: 56.0,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Image.network(
                          valueOrDefault<String>(
                            conversationDataType?.otherUserAvatar,
                            'https://media.istockphoto.com/id/1223671392/vector/default-profile-picture-avatar-photo-placeholder-vector-illustration.jpg?s=612x612&w=0&k=20&c=s0aTdmT5aU6b8ot7VKm11DeID6NctRCpB755rA1BIP0=',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    if (_hasUnread(ref))
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          width: 20.0,
                          height: 20.0,
                          decoration: BoxDecoration(
                            color: AppColors.destructive500,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              _unreadCount(ref),
                              style: Theme.of(context).textTheme.bodySmall!,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            valueOrDefault<String>(
                              conversationDataType?.otherUserUsername,
                              'N/A',
                            ),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(height: 1.5),
                          ),
                        ),
                        Text(
                          valueOrDefault<String>(
                            dateTimeFormat(
                              "relative",
                              conversationDataType?.lastMessageAt,
                              locale: 'en',
                            ),
                            '0 min',
                          ),
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(height: 1.5),
                        ),
                      ].divide(SizedBox(width: 4.0)),
                    ),
                    Text(
                      valueOrDefault<String>(
                        conversationDataType?.lastMessageText,
                        'n/a ',
                      ),
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium!
                          .copyWith(height: 1.5),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ].divide(SizedBox(height: 4.0)),
                ),
              ),
            ].divide(SizedBox(width: 12.0)),
          ),
        ),
        Divider(
          height: 1.0,
          thickness: 1.0,
          color: AppColors.surfaceDark,
        ),
      ],
    );
  }
}
