import 'package:flutter/material.dart';
import 'package:manoy_app/widgets/styledTextfield.dart';







class MessageBottomAppBar extends StatefulWidget {
  const MessageBottomAppBar({Key? key}) : super(key: key);
      
  @override
  State<MessageBottomAppBar> createState() => _MessageBottomAppBarState();
}

class _MessageBottomAppBarState extends State<MessageBottomAppBar> {
  final messageController = TextEditingController();

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Close the keyboard when tapping outside the text field
      },
      child: Container(
        color: Colors.blue, // Light blue background color
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Row(
            children: [
              Expanded(
                child: StyledTextField(
                  controller: messageController,
                  hintText: 'Type a message',
                obscureText: false,
                height: 45,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, size: 35, color: Colors.black),
                onPressed: () {
                  String typedMessage = messageController.text;
                  if (typedMessage.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(typedMessage)),
                    );
                    messageController.clear();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
