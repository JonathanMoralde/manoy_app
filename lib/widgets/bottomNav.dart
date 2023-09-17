import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manoy_app/pages/bookmark/bookmark.dart';
import 'package:manoy_app/pages/home/home.dart';
import 'package:manoy_app/pages/profile/profileView.dart';
import 'package:manoy_app/pages/settings/settings_page.dart';
import 'package:manoy_app/provider/bottomNav/currentIndex_provider.dart';
import 'package:manoy_app/provider/serviceProviderDetails/allServiceProvider_provider.dart';
import 'package:manoy_app/provider/serviceProviderDetails/serviceProviderDetails_provider.dart';
import 'package:manoy_app/provider/userDetails/uid_provider.dart';

class BottomNav extends ConsumerWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currentIndex =
        ref.watch(currentIndexProvider); // Remove 'final' keyword

    final serviceName = ref.watch(serviceNameProvider);
    // final shopName = ref.watch(serviceProviderDetailsStreamProvider);
    final bottomNavigationBarItems = <BottomNavigationBarItem>[
      BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: "Bookmark"),
      BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
    ];

    // Add the "My Shop" item only if serviceName is not null
    if (serviceName != null) {
      bottomNavigationBarItems.add(
        BottomNavigationBarItem(icon: Icon(Icons.store), label: "My Shop"),
      );
    }

    // Ensure currentIndex is within bounds
    currentIndex = currentIndex.clamp(0, bottomNavigationBarItems.length - 1);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            ref.read(currentIndexProvider.notifier).state = index;

            switch (index) {
              case 0:
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (BuildContext context) {
                    return HomePage();
                  }),
                );
                break;
              case 1:
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (BuildContext context) {
                    return BookmarkPage();
                  }),
                );
                break;
              case 2:
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (BuildContext context) {
                    return SettingsPage();
                  }),
                );
                break;
              case 3:
                if (serviceName != null) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (BuildContext context) {
                      return ProfileView();
                    }),
                  );
                }
                break;
            }
          },
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.white,
          selectedItemColor: Color(0xFF061E44),
          backgroundColor: Color(0xFF00A2FF),
          items: bottomNavigationBarItems,
        ),
      ),
    );
  }
}
