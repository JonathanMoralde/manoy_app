import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:manoy_app/pages/forgotPasswordForm.dart';
import 'package:manoy_app/pages/admin/admin_page.dart';
import 'package:manoy_app/pages/home/home.dart';
import 'package:manoy_app/pages/signup.dart';
import 'package:manoy_app/provider/isLoading/isLoading_provider.dart';
import 'package:manoy_app/provider/userDetails/address_provider.dart';
import 'package:manoy_app/provider/userDetails/birthday_provider.dart';
import 'package:manoy_app/provider/userDetails/fullname_provider.dart';
import 'package:manoy_app/provider/userDetails/gender_provider.dart';
import 'package:manoy_app/provider/userDetails/phoneNum_provider.dart';
import 'package:manoy_app/provider/userDetails/uid_provider.dart';
import 'package:manoy_app/widgets/styledButton.dart';
import 'package:manoy_app/widgets/styledTextfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/serviceProviderDetails/serviceProviderDetails_provider.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key});

  final emailController =
      TextEditingController(); //* to access the input value for auth, usernameController.text
  final passwordController =
      TextEditingController(); //* passwordController.text

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> storeUserDetailsInProvider(
      String fullname,
      int phoneNum,
      String address,
      String gender,
      Timestamp birthday,
      String uid,
      WidgetRef ref,
    ) async {
      // Store user details in providers
      ref.read(fullnameProvider.notifier).state = fullname;
      ref.read(phoneNumProvider.notifier).state = phoneNum;
      ref.read(addressProvider.notifier).state = address;
      ref.read(genderProvider.notifier).state = gender;
      ref.read(birthdayProvider.notifier).state = birthday;
      ref.read(uidProvider.notifier).state = uid;
    }

    Future<void> storeServiceProviderInProvider(
      String serviceName,
      String serviceAddress,
      String description,
      String businessHours,
      String category,
      String profilePhoto,
      String coverPhoto,
    ) async {
      try {
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
    }

    void handleSignIn() {
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        Fluttertoast.showToast(
            msg: "Please enter both email and password",
            gravity: ToastGravity.CENTER);
        return;
      }
      ref.read(isLoadingProvider.notifier).state = true;

      FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text)
          .then((value) async {
        final user = value.user;
        if (user == null) {
          Fluttertoast.showToast(msg: "Incorrect email or password");
        } else {
          final uid = user.uid;
          final email = user.email;

          try {
            DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
                .collection('users')
                .doc(uid)
                .get();

            print(userSnapshot);

            String fullname =
                userSnapshot['First Name'] + " " + userSnapshot['Last Name'];
            int phoneNum = userSnapshot['Phone Number'];
            String address = userSnapshot['Address'];
            String gender = userSnapshot['Gender'];
            Timestamp birthday = userSnapshot['Birthday'];

            print(fullname);

            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('fullname', fullname);
            prefs.setInt('phoneNum', phoneNum);
            prefs.setString('address', address);

            storeUserDetailsInProvider(
              fullname,
              phoneNum,
              address,
              gender,
              birthday,
              uid,
              ref,
            );
          } catch (e) {
            print(e);
          }

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

            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('serviceName', serviceName);
            prefs.setString('serviceAddress', serviceAddress);
            prefs.setString('description', description);
            prefs.setString('businessHours', businessHours);
            prefs.setString('category', category);
            prefs.setString('profilePhoto', profilePhoto);
            prefs.setString('coverPhoto', coverPhoto);

            storeServiceProviderInProvider(serviceName, serviceAddress,
                description, businessHours, category, profilePhoto, coverPhoto);
          } catch (e) {
            print(e);
          }
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) {
                if (email == "admin@manoy.com" &&
                    uid == "jyuds0USSQdUbu61aO6CKPONsBM2") {
                  // Navigate to the admin panel page
                  return AdminPage();
                } else {
                  return HomePage();
                }
              },
            ),
          );
        }
      }).whenComplete(() {
        ref.read(isLoadingProvider.notifier).state = false;
      }).catchError((e) {
        ref.read(isLoadingProvider.notifier).state = false;
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Incorrect Email or Password")),
        );
      });
    }

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
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
                      onClick: handleSignIn,
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
          ),
          if (ref.watch(isLoadingProvider))
            Center(
              child: CircularProgressIndicator(
                color: Color(0xFF00A2FF),
              ),
            )
        ],
      ),
    );
  }
}
