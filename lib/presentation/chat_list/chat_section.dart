import 'package:chatapp/models/chat_model.dart';
import 'package:chatapp/presentation/components/chat_list_item.dart';
import 'package:flutter/material.dart';

class ChatSection extends StatelessWidget {
  const ChatSection({super.key, required this.chats, required this.loginUser});
  final List<ChatModel> chats;
  final ChatModel loginUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //
        },
        child: Icon(Icons.chat),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: chats.length,
        itemBuilder: (context, index) {
          var item = chats[index];
          return ChatListItem(chat: item, loginUser: loginUser);
        },
      ),
    );
  }
}
