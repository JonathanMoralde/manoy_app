import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewReviewPage extends StatefulWidget {
  final String? uid;
  final String name;

  const ViewReviewPage({Key? key, this.uid, required this.name})
      : super(key: key);

  @override
  _ViewReviewPageState createState() => _ViewReviewPageState();
}

class _ViewReviewPageState extends State<ViewReviewPage> {
  List<Map<String, dynamic>> reviewsWithUserDetails = [];

  @override
  void initState() {
    super.initState();
    fetchReviewsWithUserDetails();
  }

  Future<void> fetchReviewsWithUserDetails() async {
    final reviewsSnapshot = await FirebaseFirestore.instance
        .collection('shop_ratings')
        .where('shop_id', isEqualTo: widget.uid)
        .get();

    final reviews = reviewsSnapshot.docs;
    final userDetails = <Map<String, dynamic>>[];

    for (final review in reviews) {
      final reviewData = review.data() as Map<String, dynamic>;
      final userId = reviewData['user_id'] as String;

      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userSnapshot.exists) {
        final userData = userSnapshot.data() as Map<String, dynamic>;
        final firstName = userData['First Name'] as String;
        final lastName = userData['Last Name'] as String;

        userDetails.add({
          'reviewData': reviewData,
          'userName': '$firstName $lastName',
        });
      }
    }

    setState(() {
      reviewsWithUserDetails = userDetails;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: reviewsWithUserDetails.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: reviewsWithUserDetails.length,
              itemBuilder: (context, index) {
                final reviewData = reviewsWithUserDetails[index]['reviewData']
                    as Map<String, dynamic>;
                final rating = reviewData['rating'] as double;
                final reviewText = reviewData['review'] as String;
                final userName =
                    reviewsWithUserDetails[index]['userName'] as String;

                return Column(
                  children: [
                    ListTile(
                      title: Text("$rating/5"),
                      subtitle: Text("By: $userName"),
                      trailing: Text(reviewText),
                    ),
                    Divider(
                      height: 0,
                    ),
                    const SizedBox(
                      height: 5,
                    )
                  ],
                );
              },
            ),
    );
  }
}
