import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manoy_app/provider/bookmark/bookmarkData_provider.dart';
import 'package:manoy_app/widgets/bottomNav.dart';
import 'package:manoy_app/widgets/shopCard.dart';

import '../../widgets/searchPage.dart';

class BookmarkPage extends ConsumerWidget {
  const BookmarkPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarkDataAsyncValue = ref.watch(bookmarkDataProvider);

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
      body: SafeArea(
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
      bottomNavigationBar: BottomNav(),
    );
  }
}
