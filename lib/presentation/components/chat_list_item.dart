import 'package:chatapp/models/chat_model.dart';
import 'package:chatapp/presentation/chat/chat_screen.dart';
import 'package:flutter/material.dart';

class ChatListItem extends StatelessWidget {
  const ChatListItem({super.key, required this.chat, required this.loginUser});
  final ChatModel chat;
  final ChatModel loginUser;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatScreen(chatUser: chat, loginUser: loginUser),
          ),
        );
      },
      leading: CircleAvatar(
        radius: 30,
        child: Center(child: Text(chat.name!.characters.first)),
      ),
      title: Text(
        chat.name!,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      subtitle: Row(
        children: [
          Icon(Icons.done_all),
          SizedBox(width: 3),
          Text(chat.currentMessage!, style: TextStyle(fontSize: 13)),
        ],
      ),
      trailing: Text(chat.time!),
    );
  }
}
