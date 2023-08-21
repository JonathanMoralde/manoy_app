import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// final averageRatingsProvider = FutureProvider<Map<String, double>>((ref) async {
//   final ratingCollection =
//       FirebaseFirestore.instance.collection('shop_ratings');
//   final ratingsSnap = await ratingCollection.get();

//   final Map<String, List<double>> shopRatings = {};

//   ratingsSnap.docs.forEach((ratingDoc) {
//     final shopId = ratingDoc['shop_id'] as String;
//     final rating = ratingDoc['rating'] as double;

//     if (!shopRatings.containsKey(shopId)) {
//       shopRatings[shopId] = [];
//     }

//     shopRatings[shopId]!.add(rating);
//   });

//   final Map<String, double> averageRatings = {};

//   shopRatings.forEach((shopId, ratings) {
//     if (ratings.isEmpty) {
//       averageRatings[shopId] = 0; // No ratings available
//     } else {
//       double totalRating = 0;
//       ratings.forEach((rating) {
//         totalRating += rating;
//       });

//       averageRatings[shopId] = totalRating / ratings.length;
//     }
//   });

//   return averageRatings;
// });

final averageRatingsProvider =
    FutureProvider<Map<String, Map<String, dynamic>>>((ref) async {
  final ratingCollection =
      FirebaseFirestore.instance.collection('shop_ratings');
  final ratingsSnap = await ratingCollection.get();

  final Map<String, List<double>> shopRatings = {};
  final Map<String, int> shopTotalRatings = {};

  ratingsSnap.docs.forEach((ratingDoc) {
    final shopId = ratingDoc['shop_id'] as String;
    final rating = ratingDoc['rating'] as double;

    if (!shopRatings.containsKey(shopId)) {
      shopRatings[shopId] = [];
      shopTotalRatings[shopId] = 0;
    }

    shopRatings[shopId]!.add(rating);
    shopTotalRatings[shopId] = shopTotalRatings[shopId]! + 1;
  });

  final Map<String, Map<String, dynamic>> ratingsInfo = {};

  shopRatings.forEach((shopId, ratings) {
    if (ratings.isEmpty) {
      ratingsInfo[shopId] = {
        'averageRating': 0.0,
        'totalRatings': 0,
      };
    } else {
      double totalRating = 0;
      ratings.forEach((rating) {
        totalRating += rating;
      });

      ratingsInfo[shopId] = {
        'averageRating': totalRating / ratings.length,
        'totalRatings': shopTotalRatings[shopId]!,
      };
    }
  });

  return ratingsInfo;
});
