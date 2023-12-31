import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:manoy_app/widgets/postCard.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({Key? key}) : super(key: key);

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  late Stream<int> timerStream;
  int currentIndex = 0;
  List<Widget> postCards = [];

  _PostsPageState() {
    timerStream = Stream.periodic(Duration(minutes: 1), (i) => i);
  }

  Future<void> fetchAllPosts() async {
    // Fetch all posts directly from PostCard class
    List<Map<String, dynamic>> allPosts =
        await fetchAllPostCards(); // Call the fetchAllPostCards method directly

    // Filter posts here based on your criteria
    List<Map<String, dynamic>> filteredPosts = allPosts.where((postData) {
      // Add your filtering criteria here
      Timestamp timestamp = postData['timestamp'];
      DateTime postTime = timestamp.toDate();
      DateTime currentTime = DateTime.now();
      Duration difference = currentTime.difference(postTime);
      return difference.inHours <= 24;
    }).toList();

    // Create PostCard widgets using the filtered posts
    List<Widget> allPostCards = filteredPosts.map((postData) {
      return PostCard(
        // Pass the filtered data to the PostCard
        showApprovalDialog: true,
        showApprovedRejectedText: true,
        filteringFunction:
            fetchAllPostCards, // Call the fetchAllPostCards method directly
      );
    }).toList();

    setState(() {
      postCards = allPostCards;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAllPosts(); // Fetch and display all posts
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
                  child: Text('No posts yet'),
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
