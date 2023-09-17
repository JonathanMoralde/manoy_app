import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final allServiceProvider = FutureProvider<List<DocumentSnapshot>>((ref) async {
  final shopCollection =
      FirebaseFirestore.instance.collection('service_provider');
  final querySnapshot = await shopCollection.get();
  return querySnapshot.docs;
});

final serviceProviderStreamProvider =
    StreamProvider<List<DocumentSnapshot>>((ref) {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final shopCollection =
      FirebaseFirestore.instance.collection('service_provider');

  return shopCollection
      .where('userId', isEqualTo: userId) // Filter by the user ID
      .where('Status', isEqualTo: 'Approved') // Filter by approval status
      .snapshots()
      .map((snapshot) => snapshot.docs);
});


// final serviceProviderStreamProvider =
//     StreamProvider<List<DocumentSnapshot>>((ref) {
//   final shopCollection =
//       FirebaseFirestore.instance.collection('service_provider');
//   return shopCollection.snapshots().map((snapshot) => snapshot.docs);
// });
