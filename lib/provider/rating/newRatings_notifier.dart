import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AverageRatingsNotifier
    extends StateNotifier<Map<String, Map<String, dynamic>>> {
  AverageRatingsNotifier() : super({});

  // Fetch ratings from Firestore and update state
  Future<void> refreshRatings() async {
    final newRatings = await _fetchRatings();
    state = newRatings;
  }

  // Fetch ratings data from Firestore
  Future<Map<String, Map<String, dynamic>>> _fetchRatings() async {
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
  }
}

final averageRatingsProvider = StateNotifierProvider<AverageRatingsNotifier,
    Map<String, Map<String, dynamic>>>(
  (ref) => AverageRatingsNotifier(),
);
