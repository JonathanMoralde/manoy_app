import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:manoy_app/provider/userDetails/uid_provider.dart';

// final serviceProviderDetailsProvider =
//     FutureProvider<DocumentSnapshot>((ref) async {
//   final uid = ref.watch(uidProvider); // Assuming you have a uidProvider

//   // Fetch the service provider details using the uid
//   final docSnapshot = await FirebaseFirestore.instance
//       .collection('service_provider')
//       .doc(uid)
//       .get();

//   return docSnapshot;
// });

final serviceNameProvider = StateProvider<String?>((ref) => null);
final serviceAddressProvider = StateProvider<String?>((ref) => null);
final descriptionProvider = StateProvider<String?>((ref) => null);
final businessHoursProvider = StateProvider<String?>((ref) => null);
final categoryProvider = StateProvider<List<String>>((ref) => []);
final profilePhotoProvider = StateProvider<String?>((ref) => null);
final coverPhotoProvider = StateProvider<String?>((ref) => null);

final serviceProviderDetailsStreamProvider =
    StreamProvider<DocumentSnapshot<Map<String, dynamic>>?>((ref) {
  final uid = ref.watch(uidProvider); // Assuming you have a uidProvider

  final stream = FirebaseFirestore.instance
      .collection('service_provider')
      .doc(uid)
      .snapshots();

  return stream;
});
