import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manoy_app/widgets/styledButton.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:manoy_app/widgets/uploadImage_input.dart';

class ChangeProfilePicturePage extends StatefulWidget {
  const ChangeProfilePicturePage({super.key});

  @override
  _ChangeProfilePicturePageState createState() =>
      _ChangeProfilePicturePageState();
}

class _ChangeProfilePicturePageState extends State<ChangeProfilePicturePage> {
  File? _image;

  Future _getImageFromGallery() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<void> _saveProfilePicture() async {
    if (_image != null) {
      // Upload the image to Firebase Storage
      final User? user = FirebaseAuth.instance.currentUser;
      final storageRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('profile_pictures/${user?.uid}.jpg');
      await storageRef.putFile(_image!);

      // Get the download URL of the uploaded image
      final imageUrl = await storageRef.getDownloadURL();

      // Update the user's profile information in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .update({'profilePhoto': imageUrl});

      // Navigate back after saving
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Profile Picture'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_image != null)
              CircleAvatar(
                backgroundImage: FileImage(_image!),
                radius: 120,
              ),
            const SizedBox(height: 20),
            UploadImage(
              onPressed: _getImageFromGallery,
            ),
            const SizedBox(height: 20),
            StyledButton(
              btnText: 'Save',
              onClick: _saveProfilePicture,
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: ChangeProfilePicturePage()));
}
