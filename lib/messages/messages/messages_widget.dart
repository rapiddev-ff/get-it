import '/backend/schema/structs/index.dart';
import '/core/empty_state/empty_state_widget.dart';
import '/core/nav_bar/nav_bar_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/messages/message_item/message_item_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'messages_model.dart';
export 'messages_model.dart';

class MessagesWidget extends StatefulWidget {
  const MessagesWidget({super.key});

  static String routeName = 'messages';
  static String routePath = 'messages';

  @override
  State<MessagesWidget> createState() => _MessagesWidgetState();
}

class _MessagesWidgetState extends State<MessagesWidget> {
  late MessagesModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MessagesModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.loadConversations = await actions.loadConversations(
        'all',
      );
      FFAppState().conversations =
          _model.loadConversations!.toList().cast<ConversationStruct>();
      safeSetState(() {});
      await actions.subscribeToConversations();
    });
  }

  @override
  void dispose() {
    // On page dispose action.
    () async {
      await actions.unsubscribeFromConversations();
    }();

    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56.0),
          child: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FlutterFlowIconButton(
                  borderRadius: 8.0,
                  buttonSize: 40.0,
                  icon: Icon(
                    FFIcons.kmenu,
                    color: FlutterFlowTheme.of(context).info,
                    size: 24.0,
                  ),
                  onPressed: () async {
                    context.pushNamed(SettingsWidget.routeName);
                  },
                ),
                Text(
                  FFAppConstants.appName,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                        fontSize: 18.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        lineHeight: 1.5,
                      ),
                ),
                FlutterFlowIconButton(
                  borderRadius: 8.0,
                  buttonSize: 40.0,
                  icon: Icon(
                    FFIcons.knotifications,
                    color: FlutterFlowTheme.of(context).info,
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
                color: FlutterFlowTheme.of(context).secondaryBackground,
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          _model.state = 'All';
                          safeSetState(() {});
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 10.0),
                              child: Text(
                                'All',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.normal,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      color: _model.state == 'All'
                                          ? FlutterFlowTheme.of(context)
                                              .primaryText
                                          : Color(0xFFAFAFB4),
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                      lineHeight: 1.5,
                                    ),
                              ),
                            ),
                            Opacity(
                              opacity:
                                  (_model.state == 'All' ? 1 : 0).toDouble(),
                              child: Container(
                                width: double.infinity,
                                height: 2.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).secondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          _model.state = 'Buying';
                          safeSetState(() {});
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 10.0),
                              child: Text(
                                'Buying',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      color: _model.state == 'Buying'
                                          ? FlutterFlowTheme.of(context)
                                              .primaryText
                                          : Color(0xFFAFAFB4),
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                      lineHeight: 1.5,
                                    ),
                              ),
                            ),
                            Opacity(
                              opacity:
                                  (_model.state == 'Buying' ? 1 : 0).toDouble(),
                              child: Container(
                                width: double.infinity,
                                height: 2.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).secondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (FFAppState().userData.isSeller)
                      Expanded(
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            _model.state = 'Selling';
                            safeSetState(() {});
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 10.0),
                                child: Text(
                                  'Selling',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        color: _model.state == 'Selling'
                                            ? FlutterFlowTheme.of(context)
                                                .primaryText
                                            : Color(0xFFAFAFB4),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                        lineHeight: 1.5,
                                      ),
                                ),
                              ),
                              Opacity(
                                opacity: (_model.state == 'Selling' ? 1 : 0)
                                    .toDouble(),
                                child: Container(
                                  width: double.infinity,
                                  height: 2.0,
                                  decoration: BoxDecoration(
                                    color:
                                        FlutterFlowTheme.of(context).secondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (_model.state == 'All') {
                    return Builder(
                      builder: (context) {
                        final converstations =
                            FFAppState().conversations.toList();
                        if (converstations.isEmpty) {
                          return Center(
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              child: EmptyStateWidget(
                                icon: FaIcon(
                                  FontAwesomeIcons.solidCommentAlt,
                                  color:
                                      FlutterFlowTheme.of(context).neutral800,
                                  size: 100.0,
                                ),
                                title: 'No messages yet',
                                description:
                                    'When you contact a seller or a buyer, your chats will show up here.',
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
                            final converstationsItem =
                                converstations[converstationsIndex];
                            return InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                FFAppState().currentConversation =
                                    converstationsItem;
                                safeSetState(() {});

                                context.pushNamed(
                                  ChatPageWidget.routeName,
                                  queryParameters: {
                                    'conversation': serializeParam(
                                      converstationsItem,
                                      ParamType.DataStruct,
                                    ),
                                  }.withoutNulls,
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
                      },
                    );
                  } else if (_model.state == 'Buying') {
                    return Builder(
                      builder: (context) {
                        final converstations = FFAppState()
                            .conversations
                            .where((e) => e.role == 'buyer')
                            .toList();
                        if (converstations.isEmpty) {
                          return Container(
                            width: double.infinity,
                            height: double.infinity,
                            child: EmptyStateWidget(
                              icon: FaIcon(
                                FontAwesomeIcons.solidCommentAlt,
                                color: FlutterFlowTheme.of(context).neutral800,
                                size: 100.0,
                              ),
                              title: 'No buying chats yet',
                              description:
                                  'Message a seller from an item page to ask a question or make an offer.',
                              hasButton: false,
                              sidePadding: 16.0,
                              buttonAction: () async {},
                            ),
                          );
                        }

                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: converstations.length,
                          itemBuilder: (context, converstationsIndex) {
                            final converstationsItem =
                                converstations[converstationsIndex];
                            return InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                FFAppState().currentConversation =
                                    converstationsItem;
                                safeSetState(() {});

                                context.pushNamed(
                                  ChatPageWidget.routeName,
                                  queryParameters: {
                                    'conversation': serializeParam(
                                      converstationsItem,
                                      ParamType.DataStruct,
                                    ),
                                  }.withoutNulls,
                                );
                              },
                              child: MessageItemWidget(
                                key: Key(
                                    'Keywfg_${converstationsIndex}_of_${converstations.length}'),
                                conversationDataType: converstationsItem,
                              ),
                            );
                          },
                        );
                      },
                    );
                  } else {
                    return Builder(
                      builder: (context) {
                        final converstations = FFAppState()
                            .conversations
                            .where((e) => e.role == 'seller')
                            .toList();
                        if (converstations.isEmpty) {
                          return Center(
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              child: EmptyStateWidget(
                                icon: FaIcon(
                                  FontAwesomeIcons.solidCommentAlt,
                                  color:
                                      FlutterFlowTheme.of(context).neutral800,
                                  size: 100.0,
                                ),
                                title: 'No selling chats yet',
                                description:
                                    ' When buyers message you about your listings, you’ll see them here.',
                                hasButton: false,
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
                            final converstationsItem =
                                converstations[converstationsIndex];
                            return InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                FFAppState().currentConversation =
                                    converstationsItem;
                                safeSetState(() {});

                                context.pushNamed(
                                  ChatPageWidget.routeName,
                                  queryParameters: {
                                    'conversation': serializeParam(
                                      converstationsItem,
                                      ParamType.DataStruct,
                                    ),
                                  }.withoutNulls,
                                );
                              },
                              child: MessageItemWidget(
                                key: Key(
                                    'Key4if_${converstationsIndex}_of_${converstations.length}'),
                                conversationDataType: converstationsItem,
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
            wrapWithModel(
              model: _model.navBarModel,
              updateCallback: () => safeSetState(() {}),
              child: NavBarWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
