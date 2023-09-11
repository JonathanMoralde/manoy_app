import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manoy_app/pages/home/home.dart';
import 'package:manoy_app/pages/loginScreen.dart';
import 'package:manoy_app/provider/serviceProviderDetails/serviceProviderDetails_provider.dart';
import 'package:manoy_app/provider/userDetails/address_provider.dart';
import 'package:manoy_app/provider/userDetails/birthday_provider.dart';
import 'package:manoy_app/provider/userDetails/gender_provider.dart';
import 'package:manoy_app/provider/userDetails/phoneNum_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/userDetails/fullname_provider.dart';

class MainPage extends ConsumerWidget {
  MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mark the function body as async
    return FutureBuilder<void>(
      future: _initializeData(ref),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            body: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return HomePage();
                } else {
                  return LoginScreen();
                }
              },
            ),
          );
        } else {
          return CircularProgressIndicator(); // Handle loading state
        }
      },
    );
  }

  Future<void> _initializeData(WidgetRef ref) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final fullname = sharedPreferences.getString('fullname') ?? null;
    final phoneNum = sharedPreferences.getInt('phoneNum') ?? null;
    final address = sharedPreferences.getString('address') ?? null;
    final serviceName = sharedPreferences.getString('serviceName') ?? null;
    final serviceAddress =
        sharedPreferences.getString('serviceAddress') ?? null;
    final description = sharedPreferences.getString('description') ?? null;
    final businessHours = sharedPreferences.getString('businessHours') ?? null;
    final category = sharedPreferences.getString('category') ?? null;
    final profilePhoto = sharedPreferences.getString('profilePhoto') ?? null;
    final coverPhoto = sharedPreferences.getString('coverPhoto') ?? null;

    print(fullname);
    print(serviceName);
    // user details
    ref.read(fullnameProvider.notifier).state = fullname;
    ref.read(phoneNumProvider.notifier).state = phoneNum;
    ref.read(addressProvider.notifier).state = address;

    // service provider
    ref.read(serviceNameProvider.notifier).state = serviceName;
    ref.read(serviceAddressProvider.notifier).state = serviceAddress;
    ref.read(descriptionProvider.notifier).state = description;
    ref.read(businessHoursProvider.notifier).state = businessHours;
    ref.read(categoryProvider.notifier).state = category;
    ref.read(profilePhotoProvider.notifier).state = profilePhoto;
    ref.read(coverPhotoProvider.notifier).state = coverPhoto;
  }
}
