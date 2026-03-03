import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/features/messages/domain/models/conversation_model.dart';
import '/features/messages/domain/models/message_model.dart';

class MessagesState {
  MessagesState({
    this.conversations = const [],
    this.currentChatMessages = const [],
    Conversation? currentConversation,
    this.totalUnreadCount = 0,
  }) : currentConversation = currentConversation ?? Conversation();

  final List<Conversation> conversations;
  final List<Message> currentChatMessages;
  final Conversation currentConversation;
  final int totalUnreadCount;

  MessagesState copyWith({
    List<Conversation>? conversations,
    List<Message>? currentChatMessages,
    Conversation? currentConversation,
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

  void setConversations(List<Conversation> conversations) {
    state = state.copyWith(conversations: conversations);
  }

  void addToConversations(Conversation conversation) {
    state = state.copyWith(
      conversations: [...state.conversations, conversation],
    );
  }

  void removeFromConversations(Conversation conversation) {
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
    Conversation Function(Conversation) updateFn,
  ) {
    final list = [...state.conversations];
    list[index] = updateFn(list[index]);
    state = state.copyWith(conversations: list);
  }

  void insertAtIndexInConversations(
      int index, Conversation conversation) {
    final list = [...state.conversations]..insert(index, conversation);
    state = state.copyWith(conversations: list);
  }

  // --- Current Chat Messages ---

  void setCurrentChatMessages(List<Message> messages) {
    state = state.copyWith(currentChatMessages: messages);
  }

  void addToCurrentChatMessages(Message message) {
    state = state.copyWith(
      currentChatMessages: [...state.currentChatMessages, message],
    );
  }

  void removeFromCurrentChatMessages(Message message) {
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
    Message Function(Message) updateFn,
  ) {
    final list = [...state.currentChatMessages];
    list[index] = updateFn(list[index]);
    state = state.copyWith(currentChatMessages: list);
  }

  void insertAtIndexInCurrentChatMessages(int index, Message message) {
    final list = [...state.currentChatMessages]..insert(index, message);
    state = state.copyWith(currentChatMessages: list);
  }

  // --- Current Conversation ---

  void setCurrentConversation(Conversation conversation) {
    state = state.copyWith(currentConversation: conversation);
  }

  void updateCurrentConversation(Function(Conversation) updateFn) {
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
