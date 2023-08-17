import 'package:flutter/material.dart';
import 'package:manoy_app/widgets/emailWarning.dart';
import 'package:manoy_app/widgets/styledButton.dart';
import 'package:manoy_app/widgets/styledTextfield.dart';

class ForgotPassPage extends StatelessWidget {
  ForgotPassPage({super.key});

  final emailController = TextEditingController();

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
              StyledTextField(
                  controller: emailController,
                  hintText: "Enter a valid Email",
                  obscureText: false),
              const SizedBox(
                height: 20,
              ),
              StyledButton(
                btnText: "CONFIRM",
                onClick: () {},
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
