import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manoy_app/pages/admin/posts_page.dart';
import 'package:manoy_app/pages/admin/service_provider.dart';
import 'package:manoy_app/pages/home/home_findShops.dart';
import 'package:manoy_app/pages/home/home_forYou.dart';
import 'package:manoy_app/pages/loginScreen.dart';
import 'package:manoy_app/pages/profile/shopView.dart';
import 'package:manoy_app/provider/home/activeDisplay_provider.dart';
import 'package:manoy_app/widgets/bottomNav.dart';
import 'package:manoy_app/widgets/searchPage.dart';
import 'package:manoy_app/widgets/slider.dart';

import '../../provider/serviceProviderDetails/serviceProviderDetails_provider.dart';
import '../../provider/userDetails/uid_provider.dart';

class AdminPage extends ConsumerWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeDisplay = ref.watch(activeDisplayProvider);

    final uid = ref.watch(uidProvider);

    Future<void> handleLogout() async {
      try {
        await FirebaseAuth.instance.signOut();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ));
      } catch (e) {
        print("Error signing out: $e");
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("ADMIN PANEL"),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          // IconButton(
          //   onPressed: () {
          //     Navigator.of(context).push(
          //       MaterialPageRoute(builder: (BuildContext context) {
          //         return SearchPage();
          //       }),
          //     );
          //   },
          //   icon: const Icon(Icons.search),
          // )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Admin', // Replace with the user's name
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'admin@example.com', // Replace with the user's email
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                // Implement your profile page navigation logic here
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Log Out'),
              onTap: () {
                handleLogout();
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.blue, // Tab bar background color
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        ref.read(activeDisplayProvider.notifier).state =
                            "For You";
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: activeDisplay == "For You"
                              ? Colors.white // Active tab color
                              : Colors.transparent, // Inactive tab color
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Posts",
                          style: TextStyle(
                            fontSize: 16,
                            color: activeDisplay == "For You"
                                ? Colors.blue // Active text color
                                : Colors.white, // Inactive text color
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        ref.read(activeDisplayProvider.notifier).state =
                            "Find Shops";
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: activeDisplay == "Find Shops"
                              ? Colors.white // Active tab color
                              : Colors.transparent, // Inactive tab color
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Service Providers",
                          style: TextStyle(
                            fontSize: 16,
                            color: activeDisplay == "Find Shops"
                                ? Colors.blue // Active text color
                                : Colors.white, // Inactive text color
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // SliderBar(),
            Expanded(
              child: SingleChildScrollView(
                child: activeDisplay == "For You" ? PostsPage() : FindShops(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
