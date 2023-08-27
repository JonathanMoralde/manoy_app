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
  Map<String, bool> userMessageStatus = {};

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
          return CircularProgressIndicator();
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

    final String uid = document.id;

    if (uid == FirebaseAuth.instance.currentUser!.uid) {
      return SizedBox.shrink();
    }

    bool hasMessaged = userMessageStatus[uid] ?? false;
    final String fullName = '${data['First Name']} ${data['Last Name']}';

    return GestureDetector(
      onTap: () async {
        setState(() {
          userMessageStatus[uid] = true;
        });

        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MessagePage(
            name: fullName,
            receiverId: uid,
          ),
        ));

        setState(() {
          userMessageStatus[uid] = false;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: hasMessaged
              ? Color.fromARGB(255, 45, 160, 226)
              : Colors.transparent, // Fill with color when messaged
          border: Border.all(color: Colors.blue),
        ),
        child: ListTile(
          title: Text(
            fullName,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
