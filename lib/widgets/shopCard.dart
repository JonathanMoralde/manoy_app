import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manoy_app/pages/profile/profileView.dart';
import 'package:manoy_app/pages/profile/shopView.dart';
import 'package:manoy_app/provider/bookmark/isBookmark_provider.dart';
import 'package:manoy_app/provider/isLoading/isLoading_provider.dart';
import 'package:manoy_app/provider/userDetails/uid_provider.dart';
import 'package:manoy_app/widgets/styledButton.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../provider/bookmark/bookmarkData_provider.dart';
import '../provider/rating/averageRating_provider.dart';

class ShopCard extends ConsumerWidget {
  final String name;
  final String address;
  final String? uid;
  final String image;
  final List<String> category;
  final String businessHours;
  final String description;
  final String coverPhoto;
  // final bool? isBookmarked;
  final double? height;
  final bool showStatus;
  final bool longPressed;
  final bool showRating;
  const ShopCard({
    super.key,
    required this.name,
    required this.address,
    this.height,
    this.uid,
    required this.image,
    required this.category,
    required this.businessHours,
    required this.description,
    required this.coverPhoto,
    required this.showStatus,
    this.longPressed = false,
    required this.showRating,
    // this.isBookmarked
  });

  Future<double> fetchAverageRating(String shopId) async {
    final QuerySnapshot ratingsSnapshot = await FirebaseFirestore.instance
        .collection('shop_ratings')
        .where('shop_id', isEqualTo: shopId)
        .get();

    if (ratingsSnapshot.size == 0) {
      return 0.0; // No ratings yet
    }

    int totalRatings = 0;
    double totalRatingSum = 0.0;

    for (QueryDocumentSnapshot ratingDoc in ratingsSnapshot.docs) {
      double rating = ratingDoc['rating'] ?? 0.0;
      totalRatingSum += rating;
      totalRatings++;
    }

    double averageRating = totalRatingSum / totalRatings;
    return averageRating;
  }

  Future<List<String>> fetchStatusForAllShops() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('service_provider').get();

    List<String> statuses = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return data['Status'] as String;
    }).toList();

    return statuses;
  }

  Future<String> fetchStatusForShop(String uid) async {
    try {
      // Replace this with your actual data fetching logic using shopId (uid)
      // Example using FirebaseFirestore:
      final shopDoc = await FirebaseFirestore.instance
          .collection('service_provider')
          .doc(uid)
          .get();

      if (shopDoc.exists) {
        // Assuming the status is stored in a field named 'Status'
        final status = shopDoc.get('Status') as String;
        return status;
      } else {
        return 'Not Found'; // Handle the case when the shop document doesn't exist
      }
    } catch (e) {
      // Handle any errors during data fetching
      print('Error fetching status: $e');
      return 'Error';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(isLoadingProvider);
    Future<void> approveServiceProvider(uid) async {
      final CollectionReference serviceProvidersCollection =
          FirebaseFirestore.instance.collection('service_provider');

      try {
        await serviceProvidersCollection.doc(uid).update({
          'Status': 'Approved',
        });

        print('Service provider status updated to "Approved"');
      } catch (e) {
        print('Error updating service provider status: $e');
      }
    }

    Future<void> rejectServiceProvider(uid) async {
      final CollectionReference serviceProvidersCollection =
          FirebaseFirestore.instance.collection('service_provider');

      try {
        await serviceProvidersCollection.doc(uid).update({
          'Status': 'Rejected',
        });

        print('Service provider status updated to "Rejected"');
      } catch (e) {
        print('Error updating service provider status: $e');
      }
    }

    Future approveModal() {
      bool isChecked = false;
      return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: StatefulBuilder(builder: (context, setState) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Are you sure you want to approve this service provider?",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Welcome to Manoy Admin Panel,\n\n"
                      "Our platform is dedicated to connecting reliable automobile service providers with potential customers. As an administrator, your role is crucial in ensuring the quality and integrity of our services. Please review and approve service provider registrations in adherence to our guidelines.\n\n"
                      "Here are some key responsibilities:\n\n"
                      "1. Registration Accuracy:\n"
                      "   - Verify the accuracy of service provider registrations.\n"
                      "   - Ensure that all required information is provided.\n\n"
                      "2. Service Listings:\n"
                      "   - Confirm that service listings accurately represent the services offered.\n"
                      "   - Verify that service providers' listings meet our quality standards.\n\n"
                      "3. User Interaction:\n"
                      "   - Service providers should be easily reachable by users.\n"
                      "   - Encourage respectful conduct in all interactions between service providers and users.\n\n"
                      "4. Verification:\n"
                      "   - All service providers must undergo a verification process.\n"
                      "   - Ensure that service providers meet our verification criteria.\n\n"
                      "5. Privacy:\n"
                      "   - Respect and protect user data in accordance with our Privacy Policy.\n\n"
                      "6. Intellectual Property:\n"
                      "   - Remind service providers that all content on our platform is our intellectual property.\n"
                      "   - Unauthorized use is strictly prohibited.\n\n"
                      "7. Account Termination:\n"
                      "   - Be prepared to take action, including account termination, for violations of our guidelines.\n\n"
                      "Your role is essential in maintaining the quality and legitimacy of our platform. Please stay informed about updates to our terms and guidelines. Your commitment to these principles ensures a positive experience for all users.\n\n"
                      "Thank you for your dedication to Manoy Admin.",
                    ),
                    const SizedBox(height: 20),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: isChecked,
                              onChanged: (value) {
                                setState(() {
                                  isChecked = value!;
                                });
                              },
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "I have read and understood",
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  " the Terms & Conditions",
                                  style: TextStyle(fontSize: 14),
                                )
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            StyledButton(
                              btnText: "CONFIRM",
                              onClick: isChecked
                                  ? () async {
                                      ref
                                          .read(isLoadingProvider.notifier)
                                          .state = true;
                                      try {
                                        Navigator.pop(context);
                                        await approveServiceProvider(uid!);
                                        Navigator.of(context).pop();
                                      } finally {
                                        ref
                                            .read(isLoadingProvider.notifier)
                                            .state = false;
                                      }
                                    }
                                  : null,
                            ),
                            StyledButton(
                                btnText: "CANCEL",
                                onClick: () {
                                  Navigator.pop(context);
                                }),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      );
    }

    Future rejectModal() {
      bool isChecked = false;
      return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: StatefulBuilder(builder: (context, setState) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Are you sure you want to reject this service provider?",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Text(
                        "Please note that the rejection or termination of a service provider's account does not affect user accounts. We take non-compliance seriously to maintain the trust and quality of our platform. Users can continue to enjoy our services without disruption due to actions taken against non-compliant service providers. We encourage all service providers to carefully review and adhere to our guidelines and policies to ensure a positive experience for all users."),
                    const SizedBox(height: 20),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: isChecked,
                              onChanged: (value) {
                                setState(() {
                                  isChecked = value!;
                                });
                              },
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "I have read and understood",
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  " the Terms & Conditions",
                                  style: TextStyle(fontSize: 14),
                                )
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            StyledButton(
                              btnText: "CONFIRM",
                              onClick: isChecked
                                  ? () async {
                                      ref
                                          .read(isLoadingProvider.notifier)
                                          .state = true;
                                      try {
                                        Navigator.pop(context);
                                        await rejectServiceProvider(uid!);
                                        Navigator.of(context).pop();
                                      } finally {
                                        ref
                                            .read(isLoadingProvider.notifier)
                                            .state = false;
                                      }
                                    }
                                  : null,
                            ),
                            StyledButton(
                                btnText: "CANCEL",
                                onClick: () {
                                  Navigator.pop(context);
                                }),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      );
    }

    final userId = ref.watch(uidProvider);
    void handleTap() {
      if (userId == uid) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) {
            return const ProfileView(
              fromShopCard: true,
            );
          }),
        );
      } else {
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

        bool isCurrentlyBookmarked =
            bookmarks.any((shop) => shop["Service Name"] == name);
        ref.read(isBookmarkProvider.notifier).state = isCurrentlyBookmarked;

        Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) {
            // if (isBookmarked == true) {
            //   ref.read(isBookmarkProvider.notifier).state = true;
            // }
            return ShopView(
              userId: userId,
              name: name,
              address: address,
              uid: uid,
              businessHours: businessHours,
              category: category,
              description: description,
              profilePhoto: image,
              coverPhoto: coverPhoto,
              showButtons: false,

              // isBookmarked: isBookmarked,
            );
          }),
        );
      }
    }

    // FETCH RATINGS AND TOTAL COUNT
    final averageRatingsInfo = ref.watch(averageRatingsProvider);

    final ratingsInfo = averageRatingsInfo.when(
      data: (ratings) {
        return ratings[uid!] ?? {'averageRating': 0.0, 'totalRatings': 0};
      },
      loading: () => {'averageRating': 0.0, 'totalRatings': 0},
      error: (error, stackTrace) => {'averageRating': 0.0, 'totalRatings': 0},
    );

    final averageRating = ratingsInfo['averageRating'] as double;
    final totalRatings = ratingsInfo['totalRatings'] as int;
    // if (longPressed)
    return GestureDetector(
      onLongPress: longPressed
          ? () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Actions"),
                    content: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Welcome to Manoy Admin Panel,\n\n"
                            "Our platform is dedicated to connecting reliable automobile service providers with potential customers. As an administrator, your role is crucial in ensuring the quality and integrity of our services. Please review and approve service provider registrations in adherence to our guidelines.\n\n"
                            "Here are some key responsibilities:\n\n"
                            "1. Registration Accuracy:\n"
                            "   - Verify the accuracy of service provider registrations.\n"
                            "   - Ensure that all required information is provided.\n\n"
                            "2. Service Listings:\n"
                            "   - Confirm that service listings accurately represent the services offered.\n"
                            "   - Verify that service providers' listings meet our quality standards.\n\n"
                            "3. User Interaction:\n"
                            "   - Service providers should be easily reachable by users.\n"
                            "   - Encourage respectful conduct in all interactions between service providers and users.\n\n"
                            "4. Verification:\n"
                            "   - All service providers must undergo a verification process.\n"
                            "   - Ensure that service providers meet our verification criteria.\n\n"
                            "5. Privacy:\n"
                            "   - Respect and protect user data in accordance with our Privacy Policy.\n\n"
                            "6. Intellectual Property:\n"
                            "   - Remind service providers that all content on our platform is our intellectual property.\n"
                            "   - Unauthorized use is strictly prohibited.\n\n"
                            "7. Account Termination:\n"
                            "   - Be prepared to take action, including account termination and rejection of service provider for violations of our guidelines.\n\n"
                            "Your role is essential in maintaining the quality and legitimacy of our platform. Please stay informed about updates to our terms and guidelines. Your commitment to these principles ensures a positive experience for all users.\n\n"
                            "Would you like to approve or reject this service provider?",
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  approveServiceProvider(uid);
                                  Navigator.of(context).pop();
                                  Fluttertoast.showToast(
                                    msg: "Service provider has been approved",
                                    // gravity: ToastGravity.CENTER,
                                  );
                                },
                                child: Text(
                                  'Approve',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.blue),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                  elevation:
                                      MaterialStateProperty.all<double>(3.0),
                                  overlayColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.lightGreen),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  rejectServiceProvider(uid);
                                  Navigator.of(context).pop();
                                  Fluttertoast.showToast(
                                    msg: "Service provider has been rejected",
                                    // gravity: ToastGravity.CENTER,
                                  );
                                },
                                child: Text(
                                  'Reject',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.blue),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                  elevation:
                                      MaterialStateProperty.all<double>(3.0),
                                  overlayColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.redAccent),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.blue),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                  elevation:
                                      MaterialStateProperty.all<double>(3.0),
                                  overlayColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.redAccent),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          : null,
      onTap: () {
        handleTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Container(
          width: double.infinity,
          height: height ?? 110,
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: image,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                              fontSize: 15),
                        ),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      if (showRating)
                        Row(
                          children: [
                            Text(
                              "${averageRating.toStringAsFixed(1)}/5",
                              style: const TextStyle(fontSize: 14),
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.yellow.shade700,
                              size: 16,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text("($totalRatings)")
                          ],
                        ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        address,
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (final cat in category) Text('$cat, ')
                          ],
                        ),
                      ),
                      if (showStatus)
                        FutureBuilder<String>(
                          future: fetchStatusForShop(uid!),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }

                            final status = snapshot.data;

                            if (status == null) {
                              return Text('No status available.');
                            }

                            Color statusColor;
                            switch (status) {
                              case 'Pending':
                                statusColor = Colors.orange;
                                break;
                              case 'Approved':
                                statusColor = Colors.green;
                                break;
                              case 'Rejected':
                                statusColor = Colors.red;
                                break;
                              default:
                                statusColor = Colors.black;
                            }

                            return Row(
                              children: [
                                Text(
                                  'Status:',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  // Added Expanded to allow status text to take up remaining space
                                  child: Text(
                                    '$status',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: statusColor,
                                    ),
                                    overflow: TextOverflow
                                        .ellipsis, // Truncate text if it overflows
                                  ),
                                ),
                              ],
                            );
                          },
                        )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
