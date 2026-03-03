import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/backend/schema/structs/index.dart';

class MessagesState {
  MessagesState({
    this.conversations = const [],
    this.currentChatMessages = const [],
    ConversationStruct? currentConversation,
    this.totalUnreadCount = 0,
  }) : currentConversation = currentConversation ?? ConversationStruct();

  final List<ConversationStruct> conversations;
  final List<MessageStruct> currentChatMessages;
  final ConversationStruct currentConversation;
  final int totalUnreadCount;

  MessagesState copyWith({
    List<ConversationStruct>? conversations,
    List<MessageStruct>? currentChatMessages,
    ConversationStruct? currentConversation,
    int? totalUnreadCount,
  }) {
    return MessagesState(
      conversations: conversations ?? this.conversations,
      currentChatMessages: currentChatMessages ?? this.currentChatMessages,
      currentConversation: currentConversation ?? this.currentConversation,
      totalUnreadCount: totalUnreadCount ?? this.totalUnreadCount,
    );
  }
}

class MessagesNotifier extends Notifier<MessagesState> {
  @override
  MessagesState build() => MessagesState();

  // --- Conversations ---

  void setConversations(List<ConversationStruct> conversations) {
    state = state.copyWith(conversations: conversations);
  }

  void addToConversations(ConversationStruct conversation) {
    state = state.copyWith(
      conversations: [...state.conversations, conversation],
    );
  }

  void removeFromConversations(ConversationStruct conversation) {
    state = state.copyWith(
      conversations:
          state.conversations.where((c) => c != conversation).toList(),
    );
  }

  void removeAtIndexFromConversations(int index) {
    final list = [...state.conversations]..removeAt(index);
    state = state.copyWith(conversations: list);
  }

  void updateConversationsAtIndex(
    int index,
    ConversationStruct Function(ConversationStruct) updateFn,
  ) {
    final list = [...state.conversations];
    list[index] = updateFn(list[index]);
    state = state.copyWith(conversations: list);
  }

  void insertAtIndexInConversations(
      int index, ConversationStruct conversation) {
    final list = [...state.conversations]..insert(index, conversation);
    state = state.copyWith(conversations: list);
  }

  // --- Current Chat Messages ---

  void setCurrentChatMessages(List<MessageStruct> messages) {
    state = state.copyWith(currentChatMessages: messages);
  }

  void addToCurrentChatMessages(MessageStruct message) {
    state = state.copyWith(
      currentChatMessages: [...state.currentChatMessages, message],
    );
  }

  void removeFromCurrentChatMessages(MessageStruct message) {
    state = state.copyWith(
      currentChatMessages:
          state.currentChatMessages.where((m) => m != message).toList(),
    );
  }

  void removeAtIndexFromCurrentChatMessages(int index) {
    final list = [...state.currentChatMessages]..removeAt(index);
    state = state.copyWith(currentChatMessages: list);
  }

  void updateCurrentChatMessagesAtIndex(
    int index,
    MessageStruct Function(MessageStruct) updateFn,
  ) {
    final list = [...state.currentChatMessages];
    list[index] = updateFn(list[index]);
    state = state.copyWith(currentChatMessages: list);
  }

  void insertAtIndexInCurrentChatMessages(int index, MessageStruct message) {
    final list = [...state.currentChatMessages]..insert(index, message);
    state = state.copyWith(currentChatMessages: list);
  }

  // --- Current Conversation ---

  void setCurrentConversation(ConversationStruct conversation) {
    state = state.copyWith(currentConversation: conversation);
  }

  void updateCurrentConversation(Function(ConversationStruct) updateFn) {
    updateFn(state.currentConversation);
    state = state.copyWith(currentConversation: state.currentConversation);
  }

  // --- Total Unread Count ---

  void setTotalUnreadCount(int count) {
    state = state.copyWith(totalUnreadCount: count);
  }

  void clear() {
    state = MessagesState();
  }
}

final messagesProvider =
    NotifierProvider<MessagesNotifier, MessagesState>(
  MessagesNotifier.new,
);
