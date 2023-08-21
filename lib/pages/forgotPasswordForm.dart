import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manoy_app/widgets/emailWarning.dart';
import 'package:manoy_app/widgets/styledButton.dart';
import 'package:manoy_app/widgets/styledTextfield.dart';

class ForgotPassPage extends StatelessWidget {
  ForgotPassPage({super.key});

  final emailController = TextEditingController();

  Future<bool> handleConfirm(String email) async {
    try {
      FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return true;
    } catch (error) {
      print('error');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          // height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "RESET PASSWORD",
                style: TextStyle(letterSpacing: 1, fontSize: 24),
              ),
              const SizedBox(
                height: 30,
              ),
              StyledTextField(
                  controller: emailController,
                  hintText: "Enter a valid Email",
                  obscureText: false),
              const SizedBox(
                height: 20,
              ),
              StyledButton(
                btnText: "CONFIRM",
                onClick: () {
                  final email = emailController.text;

                  handleConfirm(email).then((success) {
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Password Reset Link has been sent to your email')));
                      emailController.clear();
                    }
                  });
                },
                btnWidth: 250,
              ),
              const SizedBox(
                height: 20,
              ),
              EmailWarning(),
            ],
          ),
        ),
      ),
    );
  }
}
