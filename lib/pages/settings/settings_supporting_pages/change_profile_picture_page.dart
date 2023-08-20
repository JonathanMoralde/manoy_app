import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manoy_app/widgets/styledButton.dart';
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
            UploadImage(onPressed: _getImageFromGallery),
            const SizedBox(height: 20),
            StyledButton(
              btnText: 'Save',
              onClick: () {},
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
