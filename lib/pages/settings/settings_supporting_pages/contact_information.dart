import 'package:flutter/material.dart';
import 'package:manoy_app/widgets/styledTextfield.dart';

class ContactInfoPage extends StatefulWidget {
  const ContactInfoPage({super.key});

  @override
  State<ContactInfoPage> createState() => _nameState();
}

class _nameState extends State<ContactInfoPage> {
  @override
  final contactController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CONTACT INFORMATION')),
      body: Column(
        children: [
          Center(
            child: StyledTextField(
              hintText: 'Contact Number',
              obscureText: false,
              controller: contactController,
            ),
          ),
        ],
      ),
    );
  }
}
