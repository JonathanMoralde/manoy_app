import 'package:flutter/material.dart';
import 'package:manoy_app/widgets/styledTextfield.dart';

class editProfileForm extends StatefulWidget {
  final String uid;
  final String name;
  final String address;
  final String des;
  final String businesshours;
  final String category;
  final String profilePhoto;
  final String coverPhoto;

  const editProfileForm({
    super.key,
    required this.uid,
    required this.name,
    required this.address,
    required this.des,
    required this.businesshours,
    required this.category,
    required this.profilePhoto,
    required this.coverPhoto,
  });

  @override
  State<editProfileForm> createState() => _editProfileFormState();
}

class _editProfileFormState extends State<editProfileForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EDIT PROFILE'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('User ID: ${widget.uid}'),
            Text('Name: ${widget.name}'),
            Text('Address: ${widget.address}'),
            Text('Description: ${widget.des}'),
            Text('time: ${widget.businesshours}')
            // ... other details
          ],
        ),
      ),
    );
  }
}
