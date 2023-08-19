import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manoy_app/pages/loginScreen.dart';
import 'package:manoy_app/provider/signup/isNext_provider.dart';
import 'package:manoy_app/widgets/signup_details.dart';
import 'package:manoy_app/widgets/signup_next.dart';
import 'package:manoy_app/widgets/styledButton.dart';
import 'package:manoy_app/widgets/styledDatapicker.dart';
import 'package:manoy_app/widgets/styledDropdown.dart';
import 'package:manoy_app/widgets/styledTextfield.dart';

// PROVIDER
import "package:flutter_riverpod/flutter_riverpod.dart";

import '../provider/signup/signup_provider.dart';

class SignupPage extends ConsumerWidget {
  SignupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isNext = ref.watch(isNextProvider);

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
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({
          'First Name': firstName,
          'Last Name': lastName,
          'Phone Number': int.parse(phoneNum),
          'Address': address,
          'Gender': gender,
          'Birthday': birthday,
        }).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Signed Up successfully!")),
          );
          resetState();
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) {
            return LoginScreen();
          }));
        }).catchError((error) {
          print(error);
          print("test");
        });
      } catch (e) {
        print(e);
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
                            //TODO SIGN UP SUBMIT HERE
                            signUp();
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
