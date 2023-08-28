import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manoy_app/pages/profile/edit_profile.dart';
import 'package:manoy_app/pages/profile/profileView_messageInbox.dart';
import 'package:manoy_app/provider/serviceProviderDetails/serviceProviderDetails_provider.dart';
import 'package:manoy_app/provider/userDetails/uid_provider.dart';
import 'package:manoy_app/widgets/bottomNav.dart';
import 'package:manoy_app/widgets/styledButton.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:manoy_app/pages/profile/createPost.dart';
import 'package:firebase_auth/firebase_auth.dart';

// final locationProvider = FutureProvider<LatLng?>((ref) async {
//   try {
//     final position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );
//     return LatLng(position.latitude, position.longitude);
//   } catch (e) {
//     // Handle error
//     return null;
//   }
// });

class ProfileView extends ConsumerWidget {
  final bool? fromShopCard;

  const ProfileView({super.key, this.fromShopCard});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final locationAsyncValue = ref.watch(locationProvider);
    final FirebaseAuth auth = FirebaseAuth.instance;

    final uid = auth.currentUser!.uid;
    final serviceName = ref.watch(serviceNameProvider);
    final serviceAddress = ref.watch(serviceAddressProvider);
    final description = ref.watch(descriptionProvider);
    final businessHours = ref.watch(businessHoursProvider);
    final category = ref.watch(categoryProvider);
    final profilePhoto = ref.watch(profilePhotoProvider);
    final coverPhoto = ref.watch(coverPhotoProvider);

    late bool servicePermission = false;
    late LocationPermission permission;

    late String lat;
    late String long;

    Future<Map<String, double>> getUserLocation(String userId) async {
      final userLocationRef =
          FirebaseFirestore.instance.collection('user_locations');
      final userLocationSnapshot = await userLocationRef.doc(userId).get();

      if (userLocationSnapshot.exists) {
        final userLocationData =
            userLocationSnapshot.data() as Map<String, dynamic>;
        final double latitude = userLocationData['latitude'];
        final double longitude = userLocationData['longitude'];
        return {'latitude': latitude, 'longitude': longitude};
      } else {
        return {
          'latitude': 0.0,
          'longitude': 0.0
        }; // Default location or handle accordingly
      }
    }

    Future<Position> getCurrentLocation() async {
      servicePermission = await Geolocator.isLocationServiceEnabled();
      if (!servicePermission) {
        print('service disabled');
      }
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      return await Geolocator.getCurrentPosition();
    }

    void liveLocation() {
      LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
      Geolocator.getPositionStream(locationSettings: locationSettings)
          .listen((Position position) {});
    }

    Future<void> openMap(String lat, String long) async {
      String googleUrl =
          'https://www.google.com/maps/search/?api=1&query=$lat,$long';
      await canLaunchUrlString(googleUrl)
          ? await launchUrlString(googleUrl)
          : throw 'could not launch $googleUrl';
    }

    Future<void> setUserLocationInFirestore(
        String userId, double lat, double long) async {
      final userLocationRef =
          FirebaseFirestore.instance.collection('service_locations');
      await userLocationRef.doc(userId).set({
        'latitude': lat,
        'longitude': long,
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Shop/Service"),
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
                          imageUrl: coverPhoto!,
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
                              imageUrl: profilePhoto!,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 60,
                ),
                SizedBox(
                  width: 300,
                  child: Text(
                    serviceName!,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text("No ratings yet") //! TEMPORARY
                ,
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StyledButton(
                        btnText: "EDIT PROFILE",
                        onClick: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditProfileForm(
                                    uid: uid,
                                    name: serviceName,
                                  )));
                        }),
                    const SizedBox(
                      width: 10,
                    ),
                    StyledButton(
                        btnText: "MESSAGES",
                        onClick: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                              return MessageInbox();
                            }),
                          );
                        }),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StyledButton(
                        btnText: 'map',
                        onClick: () {
                          openMap(lat, long);
                        }),
                    const SizedBox(
                      width: 10,
                    ),
                    StyledButton(
                        btnText: 'Location',
                        onClick: () async {
                          final uid = ref.read(uidProvider);
                          if (uid != null) {
                            getCurrentLocation().then((value) async {
                              lat = '${value.latitude}';
                              long = '${value.longitude}';
                              print('$lat, $long');
                              await setUserLocationInFirestore(
                                  uid, double.parse(lat), double.parse(long));
                            });
                            liveLocation();
                          }
                        }),
                    const SizedBox(
                      width: 1,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                StyledButton(
                    btnText: 'CREATE POST',
                    onClick: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CreatePostPage(),
                      ));
                    }),
                const SizedBox(
                  height: 10,
                ),
                Text(serviceAddress!),
                const SizedBox(
                  height: 10,
                ),
                Text('Business Hours: $businessHours'),
                const SizedBox(
                  height: 10,
                ),
                Text("Category: $category"),
                const SizedBox(
                  height: 5,
                ),
                const Divider(
                  height: 0,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(description!),
                const SizedBox(
                  height: 5,
                ),
                const Divider(
                  height: 0,
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: fromShopCard == true ? null : const BottomNav(),
      // bottomNavigationBar: null,
    );
  }
}
