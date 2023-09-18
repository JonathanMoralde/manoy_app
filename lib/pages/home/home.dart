import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manoy_app/pages/home/home_findShops.dart';
import 'package:manoy_app/pages/home/home_forYou.dart';
import 'package:manoy_app/provider/home/activeDisplay_provider.dart';
import 'package:manoy_app/provider/serviceProviderDetails/allServiceProvider_provider.dart';
import 'package:manoy_app/widgets/bottomNav.dart';
import 'package:manoy_app/widgets/searchPage.dart';
import 'package:manoy_app/widgets/slider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../provider/serviceProviderDetails/serviceProviderDetails_provider.dart';
import '../../provider/userDetails/uid_provider.dart';

// PROVIDER

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeDisplay = ref.watch(activeDisplayProvider);
    final uid = ref.watch(uidProvider);

    // GETTING SHOP DATA
    Future<void> _refresh() async {
      final serviceProvider = ref.watch(allServiceProvider);
      serviceProvider.when(
          data: (itemDocs) async {
            // print(itemDocs);
            final userServiceAccount = itemDocs.firstWhere(
              (itemDoc) => itemDoc.id == uid,
            );

            if (userServiceAccount.exists) {
              final userData =
                  userServiceAccount.data() as Map<String, dynamic>;
              if (userData['Status'] == 'Approved') {
                final serviceName = userData['Service Name'];
                final serviceAddress = userData['Service Address'];
                final description = userData['Description'];

                final businessHours = userData['Business Hours'];
                final category = userData['Category'] as List<dynamic>;
                List<String> stringList =
                    category.map((item) => item.toString()).toList();
                final profilePhoto = userData['Profile Photo'];
                final coverPhoto = userData['Cover Photo'];
                // final status = userData['Status'];
                ref.read(serviceNameProvider.notifier).state = serviceName;
                ref.read(serviceAddressProvider.notifier).state =
                    serviceAddress;
                ref.read(descriptionProvider.notifier).state = description;
                ref.read(businessHoursProvider.notifier).state = businessHours;
                ref.read(categoryProvider.notifier).state = stringList;
                ref.read(profilePhotoProvider.notifier).state = profilePhoto;
                ref.read(coverPhotoProvider.notifier).state = coverPhoto;

                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('serviceName', serviceName);
                prefs.setString('serviceAddress', serviceAddress);
                prefs.setString('description', description);
                prefs.setString('businessHours', businessHours);
                prefs.setStringList('category', stringList);
                prefs.setString('profilePhoto', profilePhoto);
                prefs.setString('coverPhoto', coverPhoto);
                print(serviceName);
              }
            }
          },
          error: (error, stackTrace) => Text("Error: $error"),
          loading: () => const CircularProgressIndicator());
      // print(serviceProvider);
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: Scaffold(
        appBar: AppBar(
          title: Text("MANOY!"),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          centerTitle: true,
          backgroundColor: Colors.blue,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) {
                    return SearchPage();
                  }),
                );
              },
              icon: const Icon(Icons.search),
            )
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        ref.read(activeDisplayProvider.notifier).state =
                            "For You";
                      },
                      child: SizedBox(
                        // width: double.infinity,
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.home,
                            )
                                .animate(
                                    target: activeDisplay == "For You" ? 1 : 0)
                                .tint(color: Color(0xFF00A2FF)),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text(
                              "For You",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            )
                                .animate(
                                    target: activeDisplay == "For You" ? 1 : 0)
                                .tint(color: Color(0xFF00A2FF)),
                          ],
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
                      child: SizedBox(
                        // width: double.infinity,
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.store,
                            )
                                .animate(
                                    target: activeDisplay == "For You" ? 0 : 1)
                                .tint(color: Color(0xFF00A2FF)),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text(
                              "Find Shops",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            )
                                .animate(
                                    target: activeDisplay == "For You" ? 0 : 1)
                                .tint(color: Color(0xFF00A2FF)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SliderBar(),
              Expanded(
                child: SingleChildScrollView(
                  child: activeDisplay == "For You" ? ForYou() : FindShops(),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNav(),
      ),
    );
  }
}
