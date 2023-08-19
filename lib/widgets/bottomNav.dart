import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manoy_app/pages/bookmark/bookmark.dart';
import 'package:manoy_app/pages/home/home.dart';
import 'package:manoy_app/pages/profile/profileView.dart';
import 'package:manoy_app/pages/settings/settings_page.dart';
import 'package:manoy_app/provider/bottomNav/currentIndex_provider.dart';
import 'package:manoy_app/provider/serviceProviderDetails/serviceProviderDetails_provider.dart';
import 'package:manoy_app/provider/userDetails/uid_provider.dart';

class BottomNav extends ConsumerWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentIndexProvider);

    final serviceName = ref.watch(serviceNameProvider);

    final bottomNavigationBarItems = <BottomNavigationBarItem>[
      BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: "Bookmark"),
      BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
    ];

    if (serviceName != null) {
      // Add an extra item if serviceName is not null
      bottomNavigationBarItems.add(
        BottomNavigationBarItem(icon: Icon(Icons.store), label: "My Shop"),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              ref.read(currentIndexProvider.notifier).state = index;

              if (index == 0) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (BuildContext context) {
                    return HomePage();
                  }),
                );
              } else if (index == 1) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (BuildContext context) {
                    return BookmarkPage();
                  }),
                );
              } else if (index == 2) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (BuildContext context) {
                    return SettingsPage();
                  }),
                );
              } else if (index == 3 && serviceName != null) {
                // Handle the onTap for the dynamically added item
                // In this case, index 3 corresponds to the extra item
                // Make sure serviceName is not null before handling the tap
                // Example:
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (BuildContext context) {
                    // Handle the onTap for the extra item
                    return ProfileView();
                  }),
                );
              }
            },
            type: BottomNavigationBarType.fixed,
            unselectedItemColor: Colors.white,
            selectedItemColor: Color(0xFF061E44),
            backgroundColor: Color(0xFF00A2FF),
            items: bottomNavigationBarItems),
      ),
    );
  }
}
