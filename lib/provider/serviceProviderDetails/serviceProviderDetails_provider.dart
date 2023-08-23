import 'package:flutter_riverpod/flutter_riverpod.dart';

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
final categoryProvider = StateProvider<String?>((ref) => null);
final profilePhotoProvider = StateProvider<String?>((ref) => null);
final coverPhotoProvider = StateProvider<String?>((ref) => null);
