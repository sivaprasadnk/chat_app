import 'package:chatapp/models/chat_model.dart';
import 'package:chatapp/presentation/chat_list/chat_list_screen.dart';
import 'package:flutter/material.dart';

class SelectUserScreen extends StatefulWidget {
  const SelectUserScreen({super.key});

  @override
  State<SelectUserScreen> createState() => _SelectUserScreenState();
}

class _SelectUserScreenState extends State<SelectUserScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Welcome to Chat App'),
          // actions: [
          //   IconButton(
          //     onPressed: () {
          //       //
          //     },
          //     icon: Icon(Icons.more_vert),
          //   ),
          // ],
        ),
        body: ListView.builder(
          shrinkWrap: true,
          itemCount: loginUsers.length,
          itemBuilder: (context, index) {
            var user = loginUsers[index];
            return ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ChatListScreen(user: user)),
                );
              },
              title: Text(user.name!),
              trailing: Icon(Icons.arrow_forward),
            );
          },
        ),
      ),
    );
  }
}
