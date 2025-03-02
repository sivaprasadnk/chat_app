import 'package:chatapp/presentation/select_user/select_user_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Color(0xFF075E54)),
      home: const SelectUserScreen(),
    );
  }
}
