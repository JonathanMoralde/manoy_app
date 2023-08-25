import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:manoy_app/provider/userDetails/uid_provider.dart';

final messageContactsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final uid = ref.read(uidProvider); // Assuming you have uidProvider defined
  final QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('chat_rooms')
      .where('receiverId', isEqualTo: uid)
      .get();

  final List<Map<String, dynamic>> contacts = [];

  for (final doc in snapshot.docs) {
    final contactData = doc.data() as Map<String, dynamic>;
    final senderId = contactData['senderId'];
    final senderEmail = contactData['senderEmail']; // Add this line

    contacts.add({
      'senderId': senderId,
      'senderEmail': senderEmail, // Add this line
    });
  }

  return contacts;
});
