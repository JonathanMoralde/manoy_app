import 'package:flutter/material.dart';
import 'package:manoy_app/pages/forgotPasswordForm.dart';
import 'package:manoy_app/pages/signup.dart';
import 'package:manoy_app/widgets/styledButton.dart';
import 'package:manoy_app/widgets/styledTextfield.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final emailController =
      TextEditingController(); //* to access the input value for auth, usernameController.text
  final passwordController =
      TextEditingController(); //* passwordController.text

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 30),
                child: Image.asset(
                  "lib/images/logo.png",
                  scale: 2,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                "Welcome to Manoy!".toUpperCase(),
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1),
              ),
              const SizedBox(
                height: 20,
              ),
              StyledTextField(
                  controller: emailController,
                  hintText: "Enter your email",
                  obscureText: false),
              const SizedBox(
                height: 10,
              ),
              StyledTextField(
                  controller: passwordController,
                  hintText: "Enter your Password",
                  obscureText: true),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 250,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (BuildContext context) {
                        return ForgotPassPage();
                      }),
                    );
                  },
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(letterSpacing: 1),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              StyledButton(
                btnText: "SIGN IN",
                onClick: () {},
                btnWidth: 250,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(letterSpacing: 1),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    child: Text(
                      "SIGN UP",
                      style: TextStyle(
                          letterSpacing: 1, fontWeight: FontWeight.w700),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext) {
                          return SignupPage();
                        }),
                      );
                    },
                  ),
                ],
              )
            ]),
      ),
    );
  }
}
