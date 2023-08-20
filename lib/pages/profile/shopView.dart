import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manoy_app/pages/profile/shopView_message.dart';
import 'package:manoy_app/provider/bookmark/bookmarkData_provider.dart';
import 'package:manoy_app/provider/bookmark/isBookmark_provider.dart';
import 'package:manoy_app/provider/ratedShops/ratedShops_provider.dart';
import 'package:manoy_app/widgets/styledButton.dart';
import 'package:manoy_app/widgets/styledTextfield.dart';

class ShopView extends ConsumerWidget {
  final String? uid;
  final String name;
  final String address;
  final String businessHours;
  final String category;
  final String description;
  final String profilePhoto;
  final String coverPhoto;
  final String? userId;
  // bool? isBookmarked;
  ShopView({
    super.key,
    this.userId,
    this.uid,
    required this.name,
    required this.address,
    required this.businessHours,
    required this.category,
    required this.description,
    required this.profilePhoto,
    required this.coverPhoto,
    // this.isBookmarked
  });

  // Fetch rated shops from SharedPreferences
  // Future<List<String>> fetchRatedShops() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final ratedShops = prefs.getStringList('ratedShops') ?? [];
  //   return ratedShops;
  // }

  // Check if a shop has been rated by the user
  Future<bool> hasRatedShop(String shopId) async {
    final shopRated = await FirebaseFirestore.instance
        .collection('shop_ratings')
        .where('user_id', isEqualTo: userId)
        .get();
    final List<String> ratedShopIds =
        shopRated.docs.map<String>((doc) => doc['shop_id'] as String).toList();

    return ratedShopIds.contains(shopId);
  }

  Future<void> rateModal(BuildContext context, WidgetRef ref) async {
    double userRating = 0;
    final reviewController = TextEditingController();

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Rate & Review"),
                ),
                const Divider(
                  height: 0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RatingBar(
                    // unratedColor: Colors.yellow,
                    ratingWidget: RatingWidget(
                        full: Icon(
                          Icons.star,
                          color: Colors.yellow.shade700,
                        ),
                        half: Icon(
                          Icons.star_half,
                          color: Colors.yellow.shade700,
                        ),
                        empty: Icon(
                          Icons.star_border,
                          color: Colors.yellow.shade700,
                        )),
                    onRatingUpdate: (double rating) {
                      userRating = rating;
                    },
                    minRating: 1,
                    maxRating: 5,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                StyledTextField(
                  controller: reviewController,
                  hintText: "Write a Review",
                  obscureText: false,
                ),
                const SizedBox(
                  height: 10,
                ),
                StyledButton(
                    btnText: "SUBMIT",
                    onClick: () async {
                      final currentRating = userRating;
                      final review = reviewController.text;
                      if (userRating > 0 && review.isNotEmpty) {
                        try {
                          // final userId = ref.read(uidProvider);
                          final shopId = uid; // Replace with the actual shop ID
                          final id = userId;

                          // print(shopId);

                          // // Create a new document in the 'shop_ratings' collection
                          await FirebaseFirestore.instance
                              .collection('shop_ratings')
                              .add({
                            'user_id': id,
                            'shop_id': shopId,
                            'rating': currentRating,
                            'review': review,
                            'timestamp': FieldValue.serverTimestamp(),
                          });

                          // // Store the shop ID in local storage to indicate that the user has rated this shop
                          // final prefs = await SharedPreferences.getInstance();
                          // final ratedShops =
                          //     await fetchRatedShops(); // Fetch rated shops again to get the updated list
                          // ratedShops.add(shopId!);
                          // await prefs.setStringList('ratedShops', ratedShops);
                          ref.read(isRatedProvider.notifier).state = true;

                          Navigator.of(context).pop(); // Close the dialog
                        } catch (e) {
                          print('Error submitting rating and review: $e');
                        }
                      }
                    }),
                const SizedBox(
                  height: 15,
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarkData = ref.watch(bookmarkDataProvider);
    final List bookmarks = bookmarkData.when(
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

    handleBookmark() async {
      // await fetchBookmarks();

      final shopData = {
        'uid': uid,
        'Service Name': name,
        'Service Address': address,
        'Business Hours': businessHours,
        'Category': category,
        'Description': description,
        'Profile Photo': profilePhoto,
        'Cover Photo': coverPhoto,
      };

      if (bookmarks.isEmpty) {
        bookmarks.add(shopData);

        await FirebaseFirestore.instance
            .collection('bookmarks')
            .doc(userId)
            .set({'shops': bookmarks});
      } else {
        // REMOVE THE SHOP FROM THE BOOKMARK
        int index = bookmarks.indexWhere((bookmark) {
          return bookmark['Service Name'] == name;
        });

        if (index != -1) {
          bookmarks.removeAt(index);
          await FirebaseFirestore.instance
              .collection('bookmarks')
              .doc(userId)
              .set({'shops': bookmarks});
        } else {
          bookmarks.add(shopData);
          await FirebaseFirestore.instance
              .collection('bookmarks')
              .doc(userId)
              .set({'shops': bookmarks});
        }
      }
    }

    final isBookmark = ref.watch(isBookmarkProvider);
    final isRated = ref.watch(isRatedProvider);

    return FutureBuilder<bool>(
        future: hasRatedShop(uid ?? FirebaseAuth.instance.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Display a loading indicator
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}'); // Display an error message
          } else {
            final hasRatedThisShop = snapshot.data ?? false;
            return WillPopScope(
              onWillPop: () async {
                ref.read(isRatedProvider.notifier).state = false;
                return true;
              },
              child: Scaffold(
                appBar: AppBar(
                  title: Text("Worker Profile"),
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      // Handle back button action here
                      ref.read(isBookmarkProvider.notifier).state = false;
                      ref.read(isRatedProvider.notifier).state = false;
                      Navigator.of(context)
                          .pop(); // This pops the current screen off the navigation stack
                    },
                  ),
                ),
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.bottomCenter,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: SizedBox(
                                  height: 250,
                                  width: double.infinity,
                                  child: CachedNetworkImage(
                                    imageUrl: coverPhoto,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ), // PROFILE PHOTO
                              Positioned(
                                bottom: -50,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                      color: Colors.white, // Border color
                                      width: 4, // Border width
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: CachedNetworkImage(
                                        imageUrl: profilePhoto,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              onPressed: () {
                                handleBookmark();

                                if (isBookmark == true) {
                                  ref.read(isBookmarkProvider.notifier).state =
                                      false;
                                } else {
                                  ref.read(isBookmarkProvider.notifier).state =
                                      true;
                                }
                              },
                              icon: isBookmark == true
                                  ? Icon(
                                      Icons.bookmark,
                                      size: 35,
                                    )
                                  : Icon(
                                      Icons.bookmark_add_outlined,
                                      size: 35,
                                    ),
                            ),
                          ),
                          const SizedBox(
                            height: 0,
                          ),
                          SizedBox(
                            width: 300,
                            child: Text(
                              name,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text("No ratings yet") //TODO REPLACE
                          ,
                          const SizedBox(
                            height: 10,
                          ),
                          Text(address),
                          const SizedBox(
                            height: 10,
                          ),
                          Text("Business Hours: ${businessHours}"),
                          const SizedBox(
                            height: 10,
                          ),
                          Text("Category: ${category}"),
                          const SizedBox(
                            height: 5,
                          ),
                          Divider(
                            height: 0,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(description),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Divider(
                            height: 0,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              StyledButton(
                                btnText: hasRatedThisShop || isRated
                                    ? "RATED"
                                    : "RATE",
                                onClick: hasRatedThisShop || isRated
                                    ? null
                                    : () {
                                        rateModal(context, ref);
                                        // ref
                                        //     .read(isRatedProvider.notifier)
                                        //     .state = true;
                                      },
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              StyledButton(
                                  btnText: "MESSAGE",
                                  onClick: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) {
                                        return MessagePage(name: name);
                                      }),
                                    );
                                  }),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          StyledButton(
                              btnText: "MAKE APPOINTMENT", onClick: () {}),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        });
  }
}
