import '/features/messages/domain/models/message_model.dart';
import '/core/constants/app_constants.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/date_utils.dart';
import '/core/utils/list_extensions.dart';
import '/core/utils/value_utils.dart';
import '/core/widgets/expanded_image_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import '/core/providers/current_user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:octo_image/octo_image.dart';

class ChatItemWidget extends ConsumerWidget {
  const ChatItemWidget({
    super.key,
    required this.messageDataType,
  });

  final Message? messageDataType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Other user text message
        if ((messageDataType?.senderId != ref.read(currentUserIdProvider)) &&
            (messageDataType?.messageType == 'text'))
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32.0,
                height: 32.0,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Image.network(
                  valueOrDefault<String>(
                    messageDataType?.senderAvatar,
                    'https://media.istockphoto.com/id/1223671392/vector/default-profile-picture-avatar-photo-placeholder-vector-illustration.jpg?s=612x612&w=0&k=20&c=s0aTdmT5aU6b8ot7VKm11DeID6NctRCpB755rA1BIP0=',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width * 0.8,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundSecondary,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8.0),
                          bottomRight: Radius.circular(8.0),
                          topLeft: Radius.circular(0.0),
                          topRight: Radius.circular(8.0),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                        child: Text(
                          valueOrDefault<String>(
                            messageDataType?.content,
                            'N/A',
                          ),
                          style: GoogleFonts.inter(fontSize: 14.0),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        dateTimeFormat(
                          "jm",
                          messageDataType!.createdAt!,
                          locale: 'en',
                        ),
                        style: GoogleFonts.inter(
                          color: AppColors.textSecondary,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ].divide(SizedBox(width: 12.0)),
          ),

        // Other user image message
        if ((messageDataType?.senderId != ref.read(currentUserIdProvider)) &&
            (messageDataType?.messageType == 'image'))
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32.0,
                height: 32.0,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Image.network(
                  valueOrDefault<String>(
                    messageDataType?.senderAvatar,
                    'https://media.istockphoto.com/id/1223671392/vector/default-profile-picture-avatar-photo-placeholder-vector-illustration.jpg?s=612x612&w=0&k=20&c=s0aTdmT5aU6b8ot7VKm11DeID6NctRCpB755rA1BIP0=',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () async {
                        await Navigator.push(
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
                                image: CachedNetworkImageProvider(
                                  messageDataType!.imageUrl ?? '',
                                ),
                                fit: BoxFit.contain,
                              ),
                              allowRotation: false,
                              tag: messageDataType!.imageUrl ?? '',
                              useHeroAnimation: true,
                            ),
                          ),
                        );
                      },
                      child: Hero(
                        tag: messageDataType!.imageUrl ?? '',
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
                            image: CachedNetworkImageProvider(
                              messageDataType!.imageUrl ?? '',
                            ),
                            width: MediaQuery.sizeOf(context).width * 0.8,
                            height: 200.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        dateTimeFormat(
                          "jm",
                          messageDataType!.createdAt!,
                          locale: 'en',
                        ),
                        style: GoogleFonts.inter(
                          color: AppColors.textSecondary,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ].divide(SizedBox(width: 12.0)),
          ),

        // Current user text message
        if ((messageDataType?.senderId == ref.read(currentUserIdProvider)) &&
            (messageDataType?.messageType == 'text'))
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width * 0.8,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(0.0),
                  ),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Text(
                    valueOrDefault<String>(
                      messageDataType?.content,
                      'N/A',
                    ),
                    style: GoogleFonts.inter(fontSize: 14.0),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  dateTimeFormat(
                    "jm",
                    messageDataType!.createdAt!,
                    locale: 'en',
                  ),
                  style: GoogleFonts.inter(
                    color: AppColors.textSecondary,
                    fontSize: 12.0,
                  ),
                ),
              ),
            ],
          ),

        // Current user image message
        if ((messageDataType?.senderId == ref.read(currentUserIdProvider)) &&
            (messageDataType?.messageType == 'image'))
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              InkWell(
                onTap: () async {
                  await Navigator.push(
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
                          image: CachedNetworkImageProvider(
                            messageDataType!.imageUrl ?? '',
                          ),
                          fit: BoxFit.contain,
                        ),
                        allowRotation: false,
                        tag: messageDataType!.imageUrl ?? '',
                        useHeroAnimation: true,
                      ),
                    ),
                  );
                },
                child: Hero(
                  tag: messageDataType!.imageUrl ?? '',
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
                      image: CachedNetworkImageProvider(
                        messageDataType!.imageUrl ?? '',
                      ),
                      width: MediaQuery.sizeOf(context).width * 0.8,
                      height: 200.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  dateTimeFormat(
                    "jm",
                    messageDataType!.createdAt!,
                    locale: 'en',
                  ),
                  style: GoogleFonts.inter(
                    color: AppColors.textSecondary,
                    fontSize: 12.0,
                  ),
                ),
              ),
            ],
          ),
      ].divide(SizedBox(height: 24.0)),
    );
  }
}
