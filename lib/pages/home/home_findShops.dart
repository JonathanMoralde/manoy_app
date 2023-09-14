import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manoy_app/provider/bookmark/bookmarkData_provider.dart';
import 'package:manoy_app/provider/filterBtn/activeCategory_provider.dart';
import 'package:manoy_app/provider/serviceProviderDetails/allServiceProvider_provider.dart';
import 'package:manoy_app/widgets/filterBtns.dart';
import 'package:manoy_app/widgets/shopCard.dart';
import 'package:manoy_app/widgets/styledButton.dart';

class FindShops extends ConsumerWidget {
  const FindShops({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shopItems = ref.watch(serviceProviderStreamProvider);
    final bookmarkItems = ref.watch(bookmarkDataProvider);
    final bookmarkData = bookmarkItems.when(
      data: (data) {
        final shopsArray = data['shops'] ?? [];
        return shopsArray;
      }, // Extract the value from AsyncValue.data
      error: (error, stackTrace) {
        // Handle error state, e.g., show an error message
        return [];
      }, // Handle error state
      loading: () {
        // Handle loading state, e.g., show a loading indicator
        return [];
      }, // Handle loading state
    );

    // print(bookmarkItems);
    // print(bookmarkData);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: FilterBtns(),
        ),
        Consumer(
          builder: ((context, ref, child) {
            final activeCategory = ref.watch(activeCategoryProvider);
            return shopItems.when(
                data: (itemDocs) {
                  // ! ADDED STATUS IN THE LOGIC
                  // FILTER BASED ON ACTIVE CATEGORY
                  final filteredItems = itemDocs.where((itemDoc) {
                    final shopCategory = itemDoc['Category'] as List<dynamic>;
                    final shopStatus = itemDoc['Status'] as String;
                    List<String> stringList =
                        shopCategory.map((item) => item.toString()).toList();

                    print(shopCategory);
                    return (activeCategory == "All" ||
                            stringList.contains(activeCategory)) &&
                        shopStatus == 'Approved';
                  }).toList();

                  return Column(
                    children: filteredItems.map((itemDoc) {
                      final shopId = itemDoc.id;
                      final shopName = itemDoc['Service Name'];
                      final shopAddress = itemDoc['Service Address'];
                      final shopImage = itemDoc['Profile Photo'];
                      final shopCoverPhoto = itemDoc['Cover Photo'];
                      final shopCategory = itemDoc['Category'] as List<dynamic>;
                      List<String> stringList =
                          shopCategory.map((item) => item.toString()).toList();
                      final shopBusinessHours = itemDoc['Business Hours'];
                      final shopDescription = itemDoc['Description'];

                      print(shopCategory);
                      // bool isBookmarked = false;

                      // for (var shops in bookmarkData) {
                      //   if (shops['Service Name'] == shopName) {
                      //     isBookmarked = true;
                      //   }
                      // }

                      // print(isBookmarked);

                      return Column(
                        children: [
                          ShopCard(
                            name: shopName,
                            address: shopAddress,
                            uid: shopId,
                            image: shopImage,
                            category: stringList,
                            coverPhoto: shopCoverPhoto,
                            businessHours: shopBusinessHours,
                            description: shopDescription,
                            // isBookmarked
                            //: isBookmarked,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      );
                    }).toList(),
                  );
                },
                error: (error, stackTrace) => Text("Error: $error"),
                loading: () => const CircularProgressIndicator());
          }),
        )
      ],
    );
  }
}
