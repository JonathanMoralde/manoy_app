import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manoy_app/pages/profile/shopView_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageInbox extends StatefulWidget {
  @override
  _MessageInboxState createState() => _MessageInboxState();
}

class _MessageInboxState extends State<MessageInbox> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages/Inbox"),
        backgroundColor: Colors.blue,
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('error');
        }

        if (!snapshot.hasData) {
          return CircularProgressIndicator(); // or any other loading indicator
        }

        final List<DocumentSnapshot> documents = snapshot.data!.docs;

        return ListView(
          children:
              documents.map<Widget>((doc) => _buildUserListItem(doc)).toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

    if (data == null || FirebaseAuth.instance.currentUser == null) {
      return SizedBox.shrink();
    }

    final String uid = FirebaseAuth.instance.currentUser!.uid;

    if (FirebaseAuth.instance.currentUser!.email != null &&
        data['Email'] != null &&
        data['First Name'] != null) {
      return ListTile(
        title: Text(data['First Name']),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MessagePage(
              name: data['First Name'],
              receiverId: uid,
            ),
          ));
        },
      );
    }

    return SizedBox.shrink();
  }
}
