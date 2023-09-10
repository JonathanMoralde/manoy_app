import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:manoy_app/widgets/postCard.dart';

class ForYou extends StatefulWidget {
  const ForYou({Key? key}) : super(key: key);

  @override
  State<ForYou> createState() => _ForYouState();
}

class _ForYouState extends State<ForYou> {
  late Stream<int> timerStream;
  int currentIndex = 0;
  List<Widget> postCards = [];

  _ForYouState() {
    timerStream = Stream.periodic(Duration(minutes: 1), (i) => i);
  }

  Future<List<Map<String, dynamic>>> fetchFilteredPosts() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('posts').get();

    List<Map<String, dynamic>> posts =
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    final filteredPosts = posts.where((postData) {
      Timestamp timestamp = postData['timestamp'];
      DateTime postTime = timestamp.toDate();
      DateTime currentTime = DateTime.now();
      Duration difference = currentTime.difference(postTime);

      // Filter out posts that are older than 24 hours or have 'Rejected' status
      return difference.inHours <= 24 && postData['status'] != 'Rejected';
    }).toList();

    return filteredPosts;
  }

  Future<void> fetchApprovedPostCards() async {
    List<Widget> approvedPostCards = [];

    try {
      List<Map<String, dynamic>> filteredPosts = await PostCard(
        filteringFunction: () => fetchFilteredPosts(),
      ).fetchFilteredPosts();

      approvedPostCards = filteredPosts.map((postData) {
        return PostCard(
            showApprovalDialog: false,
            showApprovedRejectedText: false,
            filteringFunction: fetchFilteredPosts);
      }).toList();
    } catch (error) {
      // Handle any potential errors here
      print('Error fetching approved posts: $error');
    }

    setState(() {
      postCards = approvedPostCards;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchApprovedPostCards(); // Fetch and display approved posts
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedSwitcher(
          duration: Duration.zero,
          child: postCards.isNotEmpty
              ? postCards[currentIndex]
              : Center(
                  child: CircularProgressIndicator(),
                ),
          key: ValueKey<int>(currentIndex),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
