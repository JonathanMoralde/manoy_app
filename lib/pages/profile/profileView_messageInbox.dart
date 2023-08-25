import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manoy_app/provider/userDetails/uid_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:manoy_app/provider/messages/userMessage_provider.dart';
import 'package:manoy_app/pages/profile/shopView_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageInbox extends ConsumerWidget {
  Future<Map<String, dynamic>> _getUserDetails(String userId) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (userDoc.exists) {
      return userDoc.data() as Map<String, dynamic>;
    }
    return {};
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactsAsyncValue = ref.watch(messageContactsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages/Inbox"),
        backgroundColor: Colors.blue,
      ),
      body: contactsAsyncValue.when(
        data: (contacts) {
          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contactData = contacts[index] as Map<String, dynamic>;
              final userId = contactData['senderId'];

              return FutureBuilder<Map<String, dynamic>>(
                future: _getUserDetails(userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  final senderDetails = snapshot.data!;

                  return ListTile(
                    title: Text(
                        '${senderDetails['First Name']} ${senderDetails['Last Name']}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MessagePage(
                            name:
                                '${senderDetails['First Name']} ${senderDetails['Last Name']}',
                            shopId: userId,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
        loading: () => CircularProgressIndicator(),
        error: (error, stackTrace) => Text('Error: $error'),
      ),
    );
  }
}
