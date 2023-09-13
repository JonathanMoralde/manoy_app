import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manoy_app/pages/admin/admin_page.dart';
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
    return FutureBuilder<Map<String, dynamic>>(
      future: _initializeData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        final Map<String, dynamic>? userPrefs = snapshot.data;
        final String? uid = userPrefs?['uid'];
        final String? email = userPrefs?['email'];
        final String? fullname = userPrefs?['fullname'];
        final String? phoneNum = userPrefs?['phoneNum'];
        final String? address = userPrefs?['address'];
        final String? serviceName = userPrefs?['serviceName'];
        final String? serviceAddress = userPrefs?['serviceAddress'];
        final String? description = userPrefs?['description'];
        final String? businessHours = userPrefs?['businessHours'];
        final List<String>? category = userPrefs?['category'];
        final String? profilePhoto = userPrefs?['profilePhoto'];
        final String? coverPhoto = userPrefs?['coverPhoto'];

        if (uid != null && email != null) {
          print("$uid line 45");
          print("$email line 46");

          // Delay the provider state update after the build process
          Future.delayed(Duration.zero, () {
            ref.read(fullnameProvider.notifier).state = fullname;
            ref.read(phoneNumProvider.notifier).state = int.parse(phoneNum!);
            ref.read(addressProvider.notifier).state = address;

            // service provider
            ref.read(serviceNameProvider.notifier).state = serviceName;
            ref.read(serviceAddressProvider.notifier).state = serviceAddress;
            ref.read(descriptionProvider.notifier).state = description;
            ref.read(businessHoursProvider.notifier).state = businessHours;
            ref.read(categoryProvider.notifier).state = category ?? [];
            ref.read(profilePhotoProvider.notifier).state = profilePhoto;
            ref.read(coverPhotoProvider.notifier).state = coverPhoto;
          });

          return _buildLoggedInUI(email, uid);
        } else {
          return LoginScreen();
        }
      },
    );
  }

  Future<Map<String, dynamic>> _initializeData() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final uid = sharedPreferences.getString('uid') ?? null;
    final email = sharedPreferences.getString('email') ?? null;
    final fullname = sharedPreferences.getString('fullname') ?? null;
    final phoneNum = sharedPreferences.getInt('phoneNum') ?? null;
    final address = sharedPreferences.getString('address') ?? null;
    final serviceName = sharedPreferences.getString('serviceName') ?? null;
    final serviceAddress =
        sharedPreferences.getString('serviceAddress') ?? null;
    final description = sharedPreferences.getString('description') ?? null;
    final businessHours = sharedPreferences.getString('businessHours') ?? null;
    final category = sharedPreferences.getStringList('category') ?? null;
    final profilePhoto = sharedPreferences.getString('profilePhoto') ?? null;
    final coverPhoto = sharedPreferences.getString('coverPhoto') ?? null;

    print('$fullname line 88');
    print('$serviceName line 89');
    // user details
    // ref.read(fullnameProvider.notifier).state = fullname;
    // ref.read(phoneNumProvider.notifier).state = phoneNum;
    // ref.read(addressProvider.notifier).state = address;

    // // service provider
    // ref.read(serviceNameProvider.notifier).state = serviceName;
    // ref.read(serviceAddressProvider.notifier).state = serviceAddress;
    // ref.read(descriptionProvider.notifier).state = description;
    // ref.read(businessHoursProvider.notifier).state = businessHours;
    // ref.read(categoryProvider.notifier).state = category;
    // ref.read(profilePhotoProvider.notifier).state = profilePhoto;
    // ref.read(coverPhotoProvider.notifier).state = coverPhoto;
    return {
      'uid': uid,
      'email': email,
      'fullname': fullname,
      'phoneNum': phoneNum.toString(),
      'address': address,
      "serviceName": serviceName,
      'serviceAddress': serviceAddress,
      'description': description,
      'businessHours': businessHours,
      'category': category,
      'profilePhoto': profilePhoto,
      'coverPhoto': coverPhoto,
    };
  }

  Widget _buildLoggedInUI(String email, uid) {
    if (email == "admin@manoy.com" && uid == "jyuds0USSQdUbu61aO6CKPONsBM2") {
      // Navigate to the admin panel page
      return AdminPage();
    } else {
      return HomePage();
    }
  }
}
