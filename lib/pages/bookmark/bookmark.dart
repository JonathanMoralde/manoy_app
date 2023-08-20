import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manoy_app/provider/bookmark/bookmarkData_provider.dart';
import 'package:manoy_app/provider/bookmark/isBookmark_provider.dart';
import 'package:manoy_app/provider/userDetails/uid_provider.dart';
import 'package:manoy_app/widgets/bottomNav.dart';
import 'package:manoy_app/widgets/shopCard.dart';

import '../../widgets/searchPage.dart';

class BookmarkPage extends ConsumerWidget {
  const BookmarkPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(uidProvider);
    // final userBookmarks = ref.watch(bookmarkShopsProvider);

    // final bookmarkData = userBookmarks.data() as <Map<String, dynamic>>;

    // Future<Map<String, dynamic>> grabBookmark() async {
    //   final docRef =
    //       await FirebaseFirestore.instance.collection('bookmarks').doc(userId);

    //   final data = docRef.get().then(
    //     (DocumentSnapshot doc) {
    //       final data = doc.data() as Map<String, dynamic>;
    //       return data;
    //     },
    //     onError: (e) => print("Error getting document: $e"),
    //   );

    //   return data;
    // }

    final bookmarkDataAsyncValue = ref.watch(bookmarkDataProvider);
    final isBookmark = ref.watch(isBookmarkProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Bookmarks"),
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
        child: bookmarkDataAsyncValue.when(
          data: (bookmarkData) {
            final List shopsArray = bookmarkData['shops'] ?? [];

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
                          name: shopData['Service Name'],
                          address: shopData['Service Address'],
                          image: shopData['Profile Photo'],
                          category: shopData['Category'],
                          businessHours: shopData['Business Hours'],
                          description: shopData['Description'],
                          coverPhoto: shopData['Cover Photo'],
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
      bottomNavigationBar: BottomNav(),
    );
  }
}
