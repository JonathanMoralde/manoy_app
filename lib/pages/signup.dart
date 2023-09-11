import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manoy_app/pages/loginScreen.dart';
import 'package:manoy_app/provider/signup/isNext_provider.dart';
import 'package:manoy_app/widgets/signup_details.dart';
import 'package:manoy_app/widgets/signup_next.dart';
import 'package:manoy_app/widgets/styledButton.dart';

// PROVIDER
import "package:flutter_riverpod/flutter_riverpod.dart";

import '../provider/signup/signup_provider.dart';

class SignupPage extends ConsumerWidget {
  SignupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isNext = ref.watch(isNextProvider);
    bool isTermsAccepted = false;
    void resetState() {
      ref.read(firstNameControllerProvider('first_name')).clear();
      ref.read(lastNameControllerProvider('last_name')).clear();
      ref.read(phoneNumControllerProvider('phoneNum')).clear();
      ref.read(addressControllerProvider('address')).clear();
      ref.read(genderProvider.notifier).state = null;
      ref.read(selectedDateProvider.notifier).state = null;
      ref.read(isNextProvider.notifier).state = false;
      ref.read(emailControllerProvider('email')).clear();
      ref.read(passwordControllerProvider('password')).clear();
    }

    Future addUser(
        authResult,
        String firstName,
        String lastName,
        String phoneNum,
        String address,
        String gender,
        DateTime birthday) async {
      try {
        final userUid = authResult.user!.uid;
        final email = authResult.user!.email; // Get the email from authResult
        if (userUid != null && email != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userUid)
              .set({
            'UID': userUid, // Store the UID
            'Email': email, // Store the email
            'First Name': firstName,
            'Last Name': lastName,
            'Phone Number': int.parse(phoneNum),
            'Address': address,
            'Gender': gender,
            'Birthday': birthday,
          }).then((value) async {
            await FirebaseFirestore.instance
                .collection('bookmarks')
                .doc(userUid)
                .set({'shops': []}).then((value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Signed Up successfully!")),
              );
              resetState();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (BuildContext context) {
                return LoginScreen();
              }));
            });
          }).catchError((error) {
            print("Error adding user to Firestore: $error");
          });
        } else {
          print("User UID or email is null");
        }
      } catch (e) {
        print("Exception while adding user to Firestore: $e");
      }
    }

    Future signUp() async {
      // CREATE ACC
      final emailValue = ref.watch(emailControllerProvider('email')).text;
      final passwordValue =
          ref.watch(passwordControllerProvider('password')).text;

      // ACCOUNT DETAILS
      final firstNameValue =
          ref.watch(firstNameControllerProvider('first_name')).text;
      final lastNameValue =
          ref.watch(lastNameControllerProvider('last_name')).text;
      final phoneNumValue =
          ref.watch(phoneNumControllerProvider('phoneNum')).text;
      final addressValue = ref.watch(addressControllerProvider('address')).text;

      final gender = ref.watch(genderProvider);

      final selectedDate = ref.watch(selectedDateProvider);
      try {
        final authResult =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailValue,
          password: passwordValue,
        );

        addUser(authResult, firstNameValue, lastNameValue, phoneNumValue,
            addressValue, gender!, selectedDate!);
      } catch (e) {
        print(e);
      }
    }

    return WillPopScope(
      onWillPop: () async {
        resetState();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isNext
                      ? SizedBox(
                          height: 200,
                        )
                      : SizedBox(
                          height: 50,
                        ),
                  Text(
                    "CREATE NEW ACCOUNT",
                    style: TextStyle(fontSize: 24, letterSpacing: 1),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: isNext ? SignupNext() : SignupDetails(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isNext
                          ? StyledButton(
                              btnText: "BACK",
                              onClick: () {
                                ref.read(isNextProvider.notifier).state = false;
                              })
                          : SizedBox(),
                      isNext
                          ? SizedBox(
                              width: 10,
                            )
                          : SizedBox(),
                      StyledButton(
                        btnText: isNext ? "SUBMIT" : "NEXT",
                        onClick: () {
                          if (isNext == false) {
                            ref.read(isNextProvider.notifier).state = true;
                          } else {
                            // Show terms and conditions dialog before submitting
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return TermsAndConditionsDialog(
                                  onAccept: () {
                                    // Callback to enable the "SUBMIT" button and call signUp
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                    signUp(); // Call signUp after accepting terms
                                    // ScaffoldMessenger.of(context).showSnackBar(
                                    //     SnackBar(
                                    //         content: Text(
                                    //             'User Sign Up Successfully!')));
                                  },
                                );
                              },
                            );
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final isTermsAcceptedProvider = StateProvider<bool>((ref) => false);

class TermsAndConditionsDialog extends StatefulWidget {
  final VoidCallback onAccept;

  TermsAndConditionsDialog({required this.onAccept});

  @override
  _TermsAndConditionsDialogState createState() =>
      _TermsAndConditionsDialogState();
}

class _TermsAndConditionsDialogState extends State<TermsAndConditionsDialog> {
  bool isTermsAccepted = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Terms and Conditions"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Please read and accept the terms and conditions.",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              "Welcome to Manoy App, your dedicated platform for automobile services. By using our app, you agree to adhere to these terms and conditions. As a user, you can explore a wide range of automotive service providers, book appointments, message shop owners, view their locations, and rate their shops based on your experience. Accurate registration is essential to access these specialized automobile services. Service listings must faithfully represent the services provided. It's essential to maintain respectful conduct on our platform to ensure a positive experience for all users. We act as a connecting bridge between you and automotive service providers, but we don't assume responsibility for their services. Please review our Privacy Policy for data practices. All content on our app is our intellectual property, so refrain from unauthorized use. We reserve the right to terminate accounts for violations. Keep an eye out for updates to these terms as your continued use implies acceptance.",
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Checkbox(
                  value: isTermsAccepted,
                  onChanged: (value) {
                    setState(() {
                      isTermsAccepted = value ?? false;
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    if (isTermsAccepted) {
                      widget.onAccept();
                    } else {
                      print('ERROR');
                    }
                  },
                  child: Text("Accept"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
