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
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        centerTitle: true,
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

    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 8.0), // Add vertical spacing
      child: GestureDetector(
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
                : Color.fromARGB(
                    255, 241, 241, 241), // You can adjust the colors here
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.circular(12.0), // Round corners
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ], // Add a shadow
          ),
          child: ListTile(
            contentPadding:
                EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            title: Text(
              fullName,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: hasMessaged ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
