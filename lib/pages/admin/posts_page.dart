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

  Future<List<Map<String, dynamic>>> fetchApprovedPosts() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('posts').get();

    List<Map<String, dynamic>> posts =
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    final filteredPosts = posts.where((postData) {
      Timestamp timestamp = postData['timestamp'];
      DateTime postTime = timestamp.toDate();
      DateTime currentTime = DateTime.now();
      Duration difference = currentTime.difference(postTime);
      return difference.inHours <= 24 &&
          postData['status'] == 'Approved'; // Filter by status 'Approved'
    }).toList();

    return filteredPosts;
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
