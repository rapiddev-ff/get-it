import '/backend/schema/structs/index.dart';
import '/core/constants/app_constants.dart';
import '/core/empty_state/empty_state_widget.dart';
import '/core/nav_bar/nav_bar_widget.dart';
import '/core/theme/app_colors.dart';
import '/features/messages/presentation/providers/messages_provider.dart';
import '/features/messages/presentation/widgets/message_item/message_item_widget.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import '/custom_code/actions/index.dart' as actions;
import '/features/notifications/presentation/pages/notification/notification_widget.dart';
import '/features/profile/presentation/pages/settings/settings_widget.dart';
import '/features/messages/presentation/pages/chat_page/chat_page_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class MessagesWidget extends ConsumerStatefulWidget {
  const MessagesWidget({super.key});

  static String routeName = 'messages';
  static String routePath = 'messages';

  @override
  ConsumerState<MessagesWidget> createState() => _MessagesWidgetState();
}

class _MessagesWidgetState extends ConsumerState<MessagesWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String _state = 'All';

  @override
  void initState() {
    super.initState();

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final loadedConversations = await actions.loadConversations('all');
      ref.read(messagesProvider.notifier).setConversations(
            loadedConversations.toList().cast<ConversationStruct>(),
          );
      setState(() {});
      await actions.subscribeToConversations();
    });
  }

  @override
  void dispose() {
    // On page dispose action.
    () async {
      await actions.unsubscribeFromConversations();
    }();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final conversations = ref.watch(messagesProvider).conversations;
    final isSeller = ref.watch(authProvider).isSeller;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: AppColors.backgroundPrimary,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56.0),
          child: AppBar(
            backgroundColor: AppColors.backgroundSecondary,
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: AppColors.info,
                    size: 24.0,
                  ),
                  onPressed: () async {
                    context.pushNamed(SettingsWidget.routeName);
                  },
                ),
                Text(
                  AppConstants.appName,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                    height: 1.5,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.notifications_none,
                    color: AppColors.info,
                    size: 20.0,
                  ),
                  onPressed: () async {
                    context.pushNamed(NotificationWidget.routeName);
                  },
                ),
              ],
            ),
            actions: [],
            centerTitle: true,
            elevation: 0.0,
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: double.infinity,
              height: 53.0,
              decoration: BoxDecoration(
                color: AppColors.backgroundSecondary,
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    _buildTab('All'),
                    _buildTab('Buying'),
                    if (isSeller) _buildTab('Selling'),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (_state == 'All') {
                    return _buildConversationList(
                      conversations,
                      emptyTitle: 'No messages yet',
                      emptyDescription:
                          'When you contact a seller or a buyer, your chats will show up here.',
                    );
                  } else if (_state == 'Buying') {
                    return _buildConversationList(
                      conversations.where((e) => e.role == 'buyer').toList(),
                      emptyTitle: 'No buying chats yet',
                      emptyDescription:
                          'Message a seller from an item page to ask a question or make an offer.',
                    );
                  } else {
                    return _buildConversationList(
                      conversations.where((e) => e.role == 'seller').toList(),
                      emptyTitle: 'No selling chats yet',
                      emptyDescription:
                          ' When buyers message you about your listings, you\'ll see them here.',
                    );
                  }
                },
              ),
            ),
            NavBarWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label) {
    return Expanded(
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () async {
          _state = label;
          setState(() {});
        },
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.normal,
                  fontSize: 14.0,
                  color: _state == label
                      ? AppColors.textPrimary
                      : Color(0xFFAFAFB4),
                  height: 1.5,
                ),
              ),
            ),
            Opacity(
              opacity: (_state == label ? 1 : 0).toDouble(),
              child: Container(
                width: double.infinity,
                height: 2.0,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConversationList(
    List<ConversationStruct> converstations, {
    required String emptyTitle,
    required String emptyDescription,
  }) {
    if (converstations.isEmpty) {
      return Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: EmptyStateWidget(
            icon: FaIcon(
              FontAwesomeIcons.solidCommentAlt,
              color: AppColors.neutral800,
              size: 100.0,
            ),
            title: emptyTitle,
            description: emptyDescription,
            hasButton: false,
            buttonText: 'n/a',
            sidePadding: 16.0,
            buttonAction: () async {},
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: converstations.length,
      itemBuilder: (context, converstationsIndex) {
        final converstationsItem = converstations[converstationsIndex];
        return InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () async {
            ref
                .read(messagesProvider.notifier)
                .setCurrentConversation(converstationsItem);
            setState(() {});

            context.pushNamed(
              ChatPageWidget.routeName,
              queryParameters: {
                'conversation': converstationsItem.serialize(),
              },
            );
          },
          child: MessageItemWidget(
            key: Key(
                'Keyb3z_${converstationsIndex}_of_${converstations.length}'),
            conversationDataType: converstationsItem,
          ),
        );
      },
    );
  }
}
