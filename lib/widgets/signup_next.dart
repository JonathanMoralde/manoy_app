import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manoy_app/widgets/styledTextfield.dart';

import '../provider/signup/signup_provider.dart';

class SignupNext extends ConsumerWidget {
  const SignupNext({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = ref.watch(emailControllerProvider('email'));
    final passwordController =
        ref.watch(passwordControllerProvider('password'));
    return Column(
      children: [
        Text("Email Address"),
        StyledTextField(
            controller: emailController,
            hintText: "Enter Email",
            obscureText: false),
        const SizedBox(
          height: 10,
        ),
        Text("Password"),
        StyledTextField(
            controller: passwordController,
            hintText: "Enter Password",
            obscureText: true),
      ],
    );
  }
}
