import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manoy_app/pages/home/home.dart';
import 'package:manoy_app/pages/loginScreen.dart';
import 'package:manoy_app/provider/bottomNav/currentIndex_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/serviceProviderDetails/serviceProviderDetails_provider.dart';
import '../provider/userDetails/uid_provider.dart';

class MainPage extends ConsumerWidget {
  MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //   return FutureBuilder(
    //     future: _checkIsLogged(),
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return CircularProgressIndicator();
    //       }

    //       bool? isLogged = snapshot.data;

    //       if (isLogged == true) {
    //         print(isLogged);
    //         return HomePage();
    //       } else {
    //         print(isLogged);
    //         return LoginScreen();
    //       }
    //     },
    //   );
    // }

    // Future _checkIsLogged() async {
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   return prefs.getBool('isLogged');
    // }

    // final uid = ref.watch(uidProvider);

    // void setServiceProviderDetails() async {
    //   DocumentSnapshot serviceSnapshot = await FirebaseFirestore.instance
    //       .collection('service_provider')
    //       .doc(uid)
    //       .get();

    //   String serviceName = serviceSnapshot['Service Name'];
    //   String serviceAddress = serviceSnapshot['Service Address'];
    //   String description = serviceSnapshot['Description'];
    //   String businessHours = serviceSnapshot['BusinessH Hours'];
    //   String category = serviceSnapshot['Category'];
    //   String profilePhoto = serviceSnapshot['Profile Photo'];
    //   String coverPhoto = serviceSnapshot['Cover Photo'];

    //   if (serviceName.isNotEmpty &&
    //       serviceAddress.isNotEmpty &&
    //       description.isNotEmpty &&
    //       businessHours.isNotEmpty &&
    //       category.isNotEmpty &&
    //       profilePhoto.isNotEmpty &&
    //       coverPhoto.isNotEmpty) {
    //     ref.read(serviceNameProvider.notifier).state = serviceName;
    //     ref.read(serviceAddressProvider.notifier).state = serviceAddress;
    //     ref.read(descriptionProvider.notifier).state = description;
    //     ref.read(businessHoursProvider.notifier).state = businessHours;
    //     ref.read(categoryProvider.notifier).state = category;
    //     ref.read(profilePhotoProvider.notifier).state = profilePhoto;
    //     ref.read(coverPhotoProvider.notifier).state = coverPhoto;
    //   } else {
    //     print("no data");
    //   }
    // }

    // if (uid != null) {
    //   setServiceProviderDetails();
    // }
    // ref.read(currentIndexProvider.notifier).state = 0;

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
  }
}
