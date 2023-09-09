import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manoy_app/pages/forgotPasswordForm.dart';
import 'package:manoy_app/pages/admin/admin_page.dart';
import 'package:manoy_app/pages/home/home.dart';
import 'package:manoy_app/pages/signup.dart';
import 'package:manoy_app/provider/userDetails/address_provider.dart';
import 'package:manoy_app/provider/userDetails/birthday_provider.dart';
import 'package:manoy_app/provider/userDetails/fullname_provider.dart';
import 'package:manoy_app/provider/userDetails/gender_provider.dart';
import 'package:manoy_app/provider/userDetails/phoneNum_provider.dart';
import 'package:manoy_app/provider/userDetails/uid_provider.dart';
import 'package:manoy_app/widgets/styledButton.dart';
import 'package:manoy_app/widgets/styledTextfield.dart';

import '../provider/serviceProviderDetails/serviceProviderDetails_provider.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key});

  final emailController =
      TextEditingController(); //* to access the input value for auth, usernameController.text
  final passwordController =
      TextEditingController(); //* passwordController.text

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        // final User? user = await FirebaseAuth.instance.currentUser;

        final uid = value.user!.uid;

        // print(uid);

        DocumentSnapshot userSnapshot =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();

        String fullname =
            userSnapshot['First Name'] + " " + userSnapshot['Last Name'];
        int phoneNum = userSnapshot['Phone Number'];
        String address = userSnapshot['Address'];
        String gender = userSnapshot['Gender'];
        Timestamp birthday = userSnapshot['Birthday'];

        // store user details in provider
        ref.read(fullnameProvider.notifier).state = fullname;
        ref.read(phoneNumProvider.notifier).state = phoneNum;
        ref.read(addressProvider.notifier).state = address;
        ref.read(genderProvider.notifier).state = gender;
        ref.read(birthdayProvider.notifier).state = birthday;
        ref.read(uidProvider.notifier).state = uid;

        try {
          DocumentSnapshot serviceSnapshot = await FirebaseFirestore.instance
              .collection('service_provider')
              .doc(uid)
              .get();

          String serviceName = serviceSnapshot['Service Name'];
          String serviceAddress = serviceSnapshot['Service Address'];
          String description = serviceSnapshot['Description'];
          String businessHours = serviceSnapshot['Business Hours'];
          String category = serviceSnapshot['Category'];
          String profilePhoto = serviceSnapshot['Profile Photo'];
          String coverPhoto = serviceSnapshot['Cover Photo'];

          if (serviceName.isNotEmpty &&
              serviceAddress.isNotEmpty &&
              description.isNotEmpty &&
              businessHours.isNotEmpty &&
              category.isNotEmpty &&
              profilePhoto.isNotEmpty &&
              coverPhoto.isNotEmpty) {
            ref.read(serviceNameProvider.notifier).state = serviceName;
            ref.read(serviceAddressProvider.notifier).state = serviceAddress;
            ref.read(descriptionProvider.notifier).state = description;
            ref.read(businessHoursProvider.notifier).state = businessHours;
            ref.read(categoryProvider.notifier).state = category;
            ref.read(profilePhotoProvider.notifier).state = profilePhoto;
            ref.read(coverPhotoProvider.notifier).state = coverPhoto;
          }
        } catch (e) {
          print(e);
        }

        // store role in sharedPreferences
        // SharedPreferences prefs = await SharedPreferences.getInstance();
        // prefs.setBool('isLogged', true);

        // NAVIGATE TO HOMEPAGE
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailController.text.trim(),
                password: passwordController.text)
            .then((value) async {
          final uid = value.user!.uid;
          final email = value.user!.email;

          // Check if the user is an admin
          if (email == "admin@manoy.com" &&
              uid == "jyuds0USSQdUbu61aO6CKPONsBM2") {
            // Navigate to the admin panel page
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return AdminPage();
                },
              ),
            );
          } else {
            // User is not an admin, continue with regular user login

            // ... (your existing code for fetching user details)

            // Navigate to the user's home page
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return HomePage();
                },
              ),
            );
          }
        }).catchError((error) {
          print(error);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Incorrect Email or Password")),
          );
        });
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
