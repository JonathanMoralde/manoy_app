import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final serviceLocationsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('service_locations').get();

  final List<Map<String, dynamic>> locations = [];
  
  for (final DocumentSnapshot document in snapshot.docs) {
    final data = document.data() as Map<String, dynamic>;
    locations.add(data);
  }

  return locations;
});