import 'package:flutter/material.dart';
import 'package:manoy_app/widgets/styledButton.dart';
import 'package:manoy_app/widgets/styledTextfield.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: const ChangePasswordForm(),
    );
  }
}

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({super.key});

  @override
  _ChangePasswordFormState createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _retypeNewPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 90),
            StyledTextField(
              controller: _currentPasswordController,
              hintText: 'Current Password',
              obscureText: true,
            ),
            const SizedBox(height: 10),
            StyledTextField(
              controller: _newPasswordController,
              hintText: 'New Password',
              obscureText: true,
            ),
            const SizedBox(height: 10),
            StyledTextField(
              controller: _retypeNewPasswordController,
              hintText: 'Retype New Password',
              obscureText: true,
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StyledButton(
                  btnText: 'Cancel',
                  onClick: () {
                    Navigator.pop(context);
                  },
                ),
                StyledButton(
                  btnText: 'Save',
                  onClick: () {
                    if (_formKey.currentState!.validate()) {}
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: ChangePasswordPage(),
  ));
}
