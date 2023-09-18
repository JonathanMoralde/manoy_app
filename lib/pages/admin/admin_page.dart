import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manoy_app/pages/admin/posts_page.dart';
import 'package:manoy_app/pages/admin/service_provider.dart';

import 'package:manoy_app/pages/loginScreen.dart';
import 'package:manoy_app/pages/settings/settings_supporting_pages/change_profile_picture_page.dart';

import 'package:manoy_app/provider/home/activeDisplay_provider.dart';

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
                    child: UserProfilePhoto(
                        uid: uid), // Use UserProfilePhoto widget
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        'ADMIN', // Replace with the user's name
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        'JONNEL', // Replace with the user's name
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'admin@manoy.com', // Replace with the user's name
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChangeProfilePicturePage()));
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
                child: activeDisplay == "For You"
                    ? PostsPage()
                    : ServiceProviderPage(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserProfilePhoto extends ConsumerWidget {
  final String? uid;

  const UserProfilePhoto({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (uid == null) {
      return const Icon(
        Icons.account_circle_rounded,
        size: 80,
      );
    }

    return FutureBuilder<String?>(
      future: getUserProfilePhoto(uid), // A function to fetch profile photo URL
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Icon(Icons.error);
        } else if (snapshot.hasData) {
          final profilePhoto = snapshot.data;
          if (profilePhoto != null) {
            return CircleAvatar(
              backgroundImage: NetworkImage(profilePhoto),
              radius: 60,
            );
          }
        }
        return const Icon(
          Icons.account_circle_rounded,
          size: 80,
        );
      },
    );
  }
}

// ... Rest of the code remains unchanged ...

Future<String?> getUserProfilePhoto(String? uid) async {
  try {
    final DocumentSnapshot<Map<String, dynamic>> userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (userDoc.exists) {
      final String? profilePhotoUrl = userDoc.data()?['profilePhoto'];
      return profilePhotoUrl;
    } else {
      return null; // User document not found
    }
  } catch (error) {
    print("Error fetching user's profile photo: $error");
    return null;
  }
}
