import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manoy_app/provider/userDetails/uid_provider.dart';

final bookmarkDataProvider = FutureProvider<Map<String, dynamic>>(
  (ref) async {
    try {
      final userId = ref.watch(uidProvider);
      final docRef =
          FirebaseFirestore.instance.collection('bookmarks').doc(userId);

      final data = await docRef.get().then(
        (DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          return data;
        },
        onError: (e) => print("Error getting document: $e"),
      );

      return data;
    } catch (error) {
      print("An error occurred: $error");
      return <String, dynamic>{'error': error.toString()};
    }
  },
);
