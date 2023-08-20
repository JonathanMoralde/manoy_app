import 'package:flutter/material.dart';

class MessageInbox extends StatelessWidget {
  const MessageInbox({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Messages/Inbox"),
      ),
    );
  }
}
