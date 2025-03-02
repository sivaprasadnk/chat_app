import 'package:chatapp/models/chat_model.dart';
import 'package:flutter/material.dart';

class ChatModelProvider extends InheritedWidget {
  final ChatModel chatModel;

  const ChatModelProvider({
    super.key,
    required this.chatModel,
    required super.child,
  });

  static ChatModelProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ChatModelProvider>()!;
  }

  @override
  bool updateShouldNotify(ChatModelProvider oldWidget) {
    return chatModel != oldWidget.chatModel;
  }
}
