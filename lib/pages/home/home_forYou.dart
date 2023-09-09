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

  Future<void> fetchApprovedPostCards() async {
    List<Map<String, dynamic>> approvedPosts =
        await PostCard().fetchFilteredPosts();

    List<Widget> approvedPostCards = approvedPosts.map((postData) {
      return PostCard(
        showApprovalDialog: false,
        showApprovedRejectedText: false,
      ); // Create a PostCard widget for each approved post
    }).toList();

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
