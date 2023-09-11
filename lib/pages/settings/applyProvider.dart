import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manoy_app/pages/home/home.dart';
import 'package:manoy_app/pages/main_page.dart';
import 'package:manoy_app/provider/timepicker/selectedTime_provider.dart';
import 'package:manoy_app/provider/uploadIage/selectedImage_provider.dart';
import 'package:manoy_app/widgets/styledButton.dart';
import 'package:manoy_app/widgets/styledDropdown.dart';
import 'package:manoy_app/widgets/styledTextfield.dart';
import 'package:manoy_app/widgets/timePicker.dart';
import 'package:manoy_app/widgets/uploadImage_input.dart';
import 'package:uuid/uuid.dart';

import '../../provider/serviceProviderDetails/serviceProviderDetails_provider.dart';

class ApplyProvider extends ConsumerWidget {
  final String uid;
  ApplyProvider({super.key, required this.uid});

//   @override
//   State<ApplyProvider> createState() => _ApplyProviderState();
// }

// class _ApplyProviderState extends State<ApplyProvider> {
  final providerNameController = TextEditingController();

  final providerAddressController = TextEditingController();

  final providerDescriptionController = TextEditingController();

  TimeOfDay? selectedTime1;
  TimeOfDay? selectedTime2;

  String? category;

  String? selectedImagePath1;
  String? selectedImagePath2;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // String? time1 = selectedTime1?.format(context).toString();
    // String? time2 = selectedTime2?.format(context).toString();

    Future addProvider() async {
      try {
        String? time1 = selectedTime1?.format(context).toString();
        String? time2 = selectedTime2?.format(context).toString();

        final serviceName = providerNameController.text;
        final serviceAddress = providerAddressController.text;
        final description = providerDescriptionController.text;
        final businessHours = '$time1 - $time2';
        final categoryName = category;

        print(serviceName);
        print(serviceAddress);
        print(description);
        print(businessHours);
        print(categoryName);
        print(selectedImagePath1);
        print(selectedImagePath2);

        if (serviceName.isEmpty ||
            serviceAddress.isEmpty ||
            description.isEmpty ||
            time1 == null ||
            time2 == null ||
            categoryName == null ||
            selectedImagePath1 == null ||
            selectedImagePath2 == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Please fill up all the details above!"),
            ),
          );

          return;
        }

        final file1 = File(selectedImagePath1!);
        final file2 = File(selectedImagePath2!);

        // Generate a unique image name using UUID
        final imageName1 = Uuid().v4(); // Generates a random UUID
        final imageName2 = Uuid().v4(); // Generates a random UUID

        final storageRef1 = FirebaseStorage.instance
            .ref()
            .child('provider_profile')
            .child('$imageName1.jpg'); // Use the unique image name
        final storageRef2 = FirebaseStorage.instance
            .ref()
            .child('provider_profile')
            .child('$imageName2.jpg'); // Use the unique image name

        // final metadata = SettableMetadata(
        //   contentType: 'image/jpeg', // Set the content type to image/jpeg
        //   cacheControl: 'max-age=0', // Disable caching for the updated image
        // );

        final uploadTask1 = storageRef1.putFile(file1);
        final uploadTask2 = storageRef2.putFile(file2);

        // Wait for the upload to complete and get the download URL
        final TaskSnapshot snapshot1 = await uploadTask1;
        final imageUrl1 = await snapshot1.ref.getDownloadURL();
        final TaskSnapshot snapshot2 = await uploadTask2;
        final imageUrl2 = await snapshot2.ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('service_provider')
            .doc(uid)
            .set({
          'Service Name': serviceName,
          'Service Address': serviceAddress,
          'Description': description,
          'Business Hours': businessHours,
          'Category': categoryName,
          'Profile Photo': imageUrl1,
          'Cover Photo': imageUrl2,
        }).then((value) {
          SnackBar(
            content: Text("Created Successfully!"),
          );
        }).catchError((error) {
          print(error);
        });

        ref.read(serviceNameProvider.notifier).state = serviceName;
        ref.read(serviceAddressProvider.notifier).state = serviceAddress;
        ref.read(descriptionProvider.notifier).state = description;
        ref.read(businessHoursProvider.notifier).state = businessHours;
        ref.read(categoryProvider.notifier).state = categoryName;
        ref.read(profilePhotoProvider.notifier).state = imageUrl1;
        ref.read(coverPhotoProvider.notifier).state = imageUrl2;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) => MainPage(),
          ),
          (Route<dynamic> route) => false,
        );
      } catch (e) {
        print(e);
      }
    }

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        ref.read(selectedImagePath1Provider.notifier).state = null;
        ref.read(selectedImagePath2Provider.notifier).state = null;
        ref.read(selectedTime1Provider.notifier).state = null;
        ref.read(selectedTime2Provider.notifier).state = null;
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
                ref.read(selectedImagePath1Provider.notifier).state = null;
                ref.read(selectedImagePath2Provider.notifier).state = null;
                ref.read(selectedTime1Provider.notifier).state = null;
                ref.read(selectedTime2Provider.notifier).state = null;
              },
              icon: Icon(Icons.arrow_back)),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const Text(
                  "APPLY AS",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                ),
                const Text(
                  "SERVICE PROVIDER",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                    width: 250,
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Shop/Service Name:"))),
                StyledTextField(
                    controller: providerNameController,
                    hintText: "Enter Name",
                    obscureText: false),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                    width: 250,
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Shop/Service Address:"))),
                StyledTextField(
                    controller: providerAddressController,
                    hintText: "Enter Address",
                    obscureText: false),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                    width: 250,
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Description:"))),
                StyledTextField(
                    controller: providerDescriptionController,
                    hintText: "Enter Description",
                    obscureText: false),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  width: 250,
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Business Hours:")),
                ),
                SizedBox(
                  width: 250,
                  child: Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: TimePicker(
                            onTap: () {
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              ).then((value) {
                                // setState(() {
                                selectedTime1 = value;
                                ref.read(selectedTime1Provider.notifier).state =
                                    value!.format(context).toString();
                                // ref.read(selectedTime1Provider.notifier).state =
                                //     value!.format(context).toString();
                                // });
                              });
                            },
                            selectedTime: ref.watch(selectedTime1Provider),
                          )),
                      SizedBox(
                        width: 5,
                      ),
                      Text("TO"),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                          flex: 1,
                          child: TimePicker(
                            onTap: () {
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              ).then((value) {
                                // setState(() {
                                selectedTime2 = value;
                                ref.read(selectedTime2Provider.notifier).state =
                                    value!.format(context).toString();
                                // ref.read(selectedTime1Provider.notifier).state =
                                //     value!.format(context).toString();
                                // });
                              });
                            },
                            selectedTime: ref.read(selectedTime2Provider),
                          )),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  width: 250,
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Category:")),
                ),
                StyledDropdown(
                    value: category,
                    onChange: (newValue) {
                      // setState(() {
                      category = newValue;
                      // });
                    },
                    hintText: "Select Category",
                    items: const [
                      "Maintenance and Repairs",
                      "Parts and accessories",
                      "Car Wash and Detailing",
                      "Fuel and charging station",
                      "Inspection and emissions",
                    ]),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  width: 250,
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Shop/Service Profile Photo:")),
                ),
                UploadImage(
                  onPressed: () async {
                    final ImagePicker _picker = ImagePicker();
                    final XFile? image =
                        await _picker.pickImage(source: ImageSource.gallery);

                    print(image);

                    if (image != null) {
                      // setState(() {
                      selectedImagePath1 =
                          image.path; // Store the selected image path
                      print(selectedImagePath1);
                      ref.read(selectedImagePath1Provider.notifier).state =
                          image.path;
                      // ref.read(selectedImagePath1Provider.notifier).state = image.path;
                      // });
                    }
                  },
                  text: ref.watch(selectedImagePath1Provider),
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  width: 250,
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Shop/Service Cover Photo:")),
                ),
                UploadImage(
                  onPressed: () async {
                    final ImagePicker _picker = ImagePicker();
                    final XFile? image =
                        await _picker.pickImage(source: ImageSource.gallery);

                    print(image);

                    if (image != null) {
                      // setState(() {
                      selectedImagePath2 =
                          image.path; // Store the selected image path
                      print(selectedImagePath2);
                      ref.read(selectedImagePath2Provider.notifier).state =
                          image.path;
                      // ref.read(selectedImagePath1Provider.notifier).state = image.path;
                      // });
                    }
                  },
                  text: ref.watch(selectedImagePath2Provider),
                ),
                const SizedBox(
                  height: 20,
                ),
                StyledButton(
                    btnText: "CONFIRM",
                    onClick: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return TermsAndConditionsDialog(
                            onAccept: () {
                              // Callback to enable the "SUBMIT" button and call signUp
                              Navigator.of(context).pop(); // Close the dialog
                              addProvider(); // Call signUp after accepting terms
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'Service provder registration successful!')));
                            },
                          );
                        },
                      );

                      // print("executed");
                    })
              ],
            ),
          ),
        )),
      ),
    );
  }
}

final isTermsAcceptedProvider = StateProvider<bool>((ref) => false);

class TermsAndConditionsDialog extends StatefulWidget {
  final VoidCallback onAccept;

  TermsAndConditionsDialog({required this.onAccept});

  @override
  _TermsAndConditionsDialogState createState() =>
      _TermsAndConditionsDialogState();
}

class _TermsAndConditionsDialogState extends State<TermsAndConditionsDialog> {
  bool isTermsAccepted = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Terms and Conditions"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Please read and accept the terms and conditions.",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              "Welcome to Manoy App, your dedicated platform for automobile services. By using our app, you agree to adhere to these terms and conditions. As a service provider or shop owner, accurate registration is key to offering your specialized automobile services on our platform. Your service listings must faithfully represent the services you provide. Users can conveniently book appointments with your shop, locate your shop, contact you directly, and rate your services based on their experience. It's essential to maintain respectful conduct when interacting with users on our platform. To ensure quality and legitimacy, all service providers undergo verification. We act as a connecting bridge between you and potential customers, but we don't assume responsibility for your services. Please review our Privacy Policy for data practices. All content on our app is our intellectual property, so refrain from unauthorized use. We reserve the right to terminate accounts for violations. Keep an eye out for updates to these terms as your continued use implies acceptance.",
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Checkbox(
                  value: isTermsAccepted,
                  onChanged: (value) {
                    setState(() {
                      isTermsAccepted = value ?? false;
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    if (isTermsAccepted) {
                      widget.onAccept();
                    } else {
                      print('ERROR');
                    }
                  },
                  child: Text("Accept"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
