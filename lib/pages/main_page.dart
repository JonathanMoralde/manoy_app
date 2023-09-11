import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manoy_app/pages/home/home.dart';
import 'package:manoy_app/pages/loginScreen.dart';
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

    print(fullname);
    // Use ref.read to store data in Riverpod providers
    ref.read(fullnameProvider.notifier).state = fullname;
    ref.read(phoneNumProvider.notifier).state = phoneNum;
    ref.read(addressProvider.notifier).state = address;
  }
}
