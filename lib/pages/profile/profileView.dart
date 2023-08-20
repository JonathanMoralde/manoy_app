import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manoy_app/pages/profile/profileView_messageInbox.dart';
import 'package:manoy_app/provider/serviceProviderDetails/serviceProviderDetails_provider.dart';
import 'package:manoy_app/widgets/bottomNav.dart';
import 'package:manoy_app/widgets/styledButton.dart';

class ProfileView extends ConsumerWidget {
  final bool? fromShopCard;
  const ProfileView({super.key, this.fromShopCard});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceName = ref.watch(serviceNameProvider);
    final serviceAddress = ref.watch(serviceAddressProvider);
    final description = ref.watch(descriptionProvider);
    final businessHours = ref.watch(businessHoursProvider);
    final category = ref.watch(categoryProvider);
    final profilePhoto = ref.watch(profilePhotoProvider);
    final coverPhoto = ref.watch(coverPhotoProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("My Shop/Service"),
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
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text("No ratings yet") //! TEMPORARY
                ,
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StyledButton(btnText: "EDIT PROFILE", onClick: () {}),
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
                Divider(
                  height: 0,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(description!),
                const SizedBox(
                  height: 5,
                ),
                Divider(
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
      bottomNavigationBar: fromShopCard == true ? null : BottomNav(),
      // bottomNavigationBar: null,
    );
  }
}
