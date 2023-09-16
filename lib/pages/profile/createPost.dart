import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path; // Import the path package
import 'package:manoy_app/widgets/styledButton.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({Key? key}) : super(key: key);

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  TextEditingController _postTextController = TextEditingController();
  String? imageUrl;

  @override
  void dispose() {
    _postTextController.dispose();
    super.dispose();
  }

  File? pickedImage;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        pickedImage = File(pickedFile.path);
      });
    }
  }

  Future<Map<String, dynamic>> fetchCurrentUserProfileData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final firestore = FirebaseFirestore.instance;

    if (currentUser != null) {
      final userId = currentUser.uid;

      try {
        final docSnapshot =
            await firestore.collection('service_provider').doc(userId).get();

        if (docSnapshot.exists) {
          final data = docSnapshot.data() as Map<String, dynamic>;
          return data;
        } else {
          return {}; // Return an empty map if the user's document doesn't exist
        }
      } catch (error) {
        print('Error fetching current user data: $error');
      }
    }

    return {}; // Return an empty map if there's no current user
  }

  Future<void> _uploadImageAndSavePost() async {
    if (pickedImage != null) {
      final storageRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('posts_images/${DateTime.now()}.png');
      await storageRef.putFile(pickedImage!);
      imageUrl = await storageRef.getDownloadURL();

      final postCaption = _postTextController.text;

      if (postCaption.isNotEmpty) {
        final currentUser = FirebaseAuth.instance.currentUser;
        final firestore = FirebaseFirestore.instance;

        if (currentUser != null) {
          final userId = currentUser.uid;

          try {
            final currentUserData =
                await fetchCurrentUserProfileData(); // Fetch current user's data

            if (currentUserData.isNotEmpty) {
              await firestore.collection('posts').doc(userId).set({
                'caption': postCaption,
                'imageUrl': imageUrl,
                'timestamp': FieldValue.serverTimestamp(),
                'service_name': currentUserData['Service Name'],
                'service_photo': currentUserData['Profile Photo'],
                'userId': userId,
                'status': 'Pending',
              });

              _postTextController.clear();
              setState(() {
                pickedImage = null;
              });
            }
          } catch (error) {
            print('Error saving post: $error');
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CREATE POST'),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Container(
          width: 400,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        'lib/images/logo.png',
                        width: 250,
                        height: 250,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: _postTextController,
                    maxLines: 8,
                    decoration: InputDecoration(
                      hintText: "What's on your mind?",
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 16.0,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 45,
                        width: 200,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFF00A2FF),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(8),
                            backgroundColor: Colors.white,
                            foregroundColor:
                                const Color.fromARGB(255, 97, 97, 97),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: _pickImage,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Image',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Icon(
                                Icons.upload,
                                size: 24.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 30),
                      StyledButton(
                          btnText: 'POST',
                          onClick: () async {
                            // Only call the upload function from StyledButton's callback
                            await _uploadImageAndSavePost();
                            if (imageUrl != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('POSTED SUCCESSFULLY')));
                              Navigator.pop(context);
                            }
                          })
                    ],
                  ),
                ),
                if (pickedImage != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Image Path: ${path.basename(pickedImage!.path)}', // Display only the image file name
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
