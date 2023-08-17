import 'package:flutter/material.dart';
import 'package:manoy_app/widgets/styledTextfield.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNumController = TextEditingController();
  final addressController = TextEditingController();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("CREATE NEW ACCOUNT"),
              Text("First Name"),
              StyledTextField(
                  controller: firstNameController,
                  hintText: "Enter First Name",
                  obscureText: false),
              Text("Last Name"),
              StyledTextField(
                  controller: lastNameController,
                  hintText: "Enter Last Name",
                  obscureText: false),
              Text("Phone Number"),
              StyledTextField(
                  controller: phoneNumController,
                  hintText: "Enter Phone Number",
                  obscureText: false),
              Text("Address"),
              StyledTextField(
                  controller: addressController,
                  hintText: "Enter Address",
                  obscureText: false),
              Text("Email"),
              StyledTextField(
                  controller: emailController,
                  hintText: "Enter Email",
                  obscureText: false),
              Text("Gender")
            ],
          ),
        ),
      ),
    );
  }
}
