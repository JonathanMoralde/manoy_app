import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manoy_app/pages/forgotPasswordForm.dart';
import 'package:manoy_app/pages/home/home.dart';
import 'package:manoy_app/pages/settings/settings_page.dart';
import 'package:manoy_app/pages/signup.dart';
import 'package:manoy_app/widgets/styledButton.dart';
import 'package:manoy_app/widgets/styledTextfield.dart';

// sharedpreference
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final emailController =
      TextEditingController(); //* to access the input value for auth, usernameController.text
  final passwordController =
      TextEditingController(); //* passwordController.text

  @override
  Widget build(BuildContext context) {
    Future handleSignIn() async {
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please enter both email and password")),
        );
        return;
      }

      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text)
          .then((value) async {
        // store role in sharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('isLogged', true);

        // NAVIGATE TO HOMEPAGE
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return HomePage();
            },
          ),
        );
      }).catchError((error) {
        print(error);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Incorrect Email or Password")),
        );
      });
    }

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
                style: const TextStyle(
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
                  child: const Text(
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
                onClick: () {
                  // TODO AUTH
                  handleSignIn();
                },
                btnWidth: 250,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(letterSpacing: 1),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    child: const Text(
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
