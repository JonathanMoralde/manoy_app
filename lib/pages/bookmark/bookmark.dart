import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manoy_app/provider/bookmark/bookmarkData_provider.dart';
import 'package:manoy_app/provider/serviceProviderDetails/allServiceProvider_provider.dart';
import 'package:manoy_app/provider/serviceProviderDetails/serviceProviderDetails_provider.dart';
import 'package:manoy_app/provider/userDetails/uid_provider.dart';
import 'package:manoy_app/widgets/bottomNav.dart';
import 'package:manoy_app/widgets/shopCard.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/searchPage.dart';

class BookmarkPage extends ConsumerWidget {
  const BookmarkPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarkDataAsyncValue = ref.watch(bookmarkDataProvider);

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

              final serviceName = userData['Service Name'];
              final serviceAddress = userData['Service Address'];
              final description = userData['Description'];

              final businessHours = userData['Business Hours'];
              final category = userData['Category'] as List<dynamic>;
              List<String> stringList =
                  category.map((item) => item.toString()).toList();
              final profilePhoto = userData['Profile Photo'];
              final coverPhoto = userData['Cover Photo'];

              ref.read(serviceNameProvider.notifier).state = serviceName;
              ref.read(serviceAddressProvider.notifier).state = serviceAddress;
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
          },
          error: (error, stackTrace) => Text("Error: $error"),
          loading: () => const CircularProgressIndicator());
      // print(serviceProvider);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Bookmarks"),
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
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SafeArea(
          child: bookmarkDataAsyncValue.when(
            data: (bookmarkData) {
              final List shopsArray = bookmarkData['shops'] ?? [];
              // print(shopsArray);

              if (shopsArray.isEmpty) {
                return Center(child: Text("No bookmarked shops found."));
              }

              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Loop through shopsArray and build ShopCard widgets
                    for (var shopData in shopsArray)
                      Column(
                        children: [
                          ShopCard(
                            uid: shopData['uid'],
                            name: shopData['Service Name'],
                            address: shopData['Service Address'],
                            image: shopData['Profile Photo'],
                            category: (shopData['Category'] as List<dynamic>)
                                .map((item) => item.toString())
                                .toList(),
                            businessHours: shopData['Business Hours'],
                            description: shopData['Description'],
                            coverPhoto: shopData['Cover Photo'],
                            showStatus: false,
                            showRating: true,
                            // isBookmarked: true,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                  ],
                ),
              );
            },
            loading: () => CircularProgressIndicator(),
            error: (error, stackTrace) => Text("Error: $error"),
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}
