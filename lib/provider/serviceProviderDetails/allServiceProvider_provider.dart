import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

final allServiceProvider = FutureProvider<List<DocumentSnapshot>>((ref) async {
  final shopCollection =
      FirebaseFirestore.instance.collection('service_provider');
  final querySnapshot = await shopCollection.get();
  return querySnapshot.docs;
});

final serviceProviderStreamProvider =
    StreamProvider<List<DocumentSnapshot>>((ref) {
  final shopCollection =
      FirebaseFirestore.instance.collection('service_provider');
  return shopCollection.snapshots().map((snapshot) => snapshot.docs);
});
