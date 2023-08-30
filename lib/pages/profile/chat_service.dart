import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:manoy_app/pages/profile/message.dart';

class ChatService extends ChangeNotifier {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String receiverId, String message) async {
    final String currentUserId = auth.currentUser!.uid;
    final Timestamp timestamp = Timestamp.now();
    final String currentEmail = auth.currentUser!.email.toString();

    try {
      DocumentSnapshot userSnapshot =
          await firestore.collection('users').doc(currentUserId).get();

      if (userSnapshot.exists) {
        // Access the user's data from the snapshot
        String firstName = userSnapshot['First Name'];
        String lastName = userSnapshot['Last Name'];

        // Now you have the first name and last name of the current user
        print('First Name: $firstName');
        print('Last Name: $lastName');

        // Continue with sending the message or performing other operations
      } else {
        print('User document does not exist');
      }
    } catch (e) {
      print('Error retrieving user data: $e');
    }

    Message newMessage = Message(
        senderId: currentUserId,
        senderEmail: currentEmail,
        receiverId: receiverId,
        message: message,
        timestamp: timestamp);

    List<String> ids = [currentUserId, currentEmail];
    ids.sort();
    String chatRoomId = ids.join('_');

    await firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.ToMap());
  }

  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join('_');

    return firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
