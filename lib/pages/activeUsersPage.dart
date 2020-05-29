import 'package:flutter/material.dart';
import 'package:flutter_chat_app/custom/messaging.dart';

class ActiveUsersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ActiveUsers(),
    );
  }
}
