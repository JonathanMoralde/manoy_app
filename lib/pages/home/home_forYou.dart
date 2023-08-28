import 'package:flutter/material.dart';
import 'package:manoy_app/widgets/postCard.dart';

class ForYou extends StatefulWidget {
  const ForYou({Key? key}) : super(key: key);

  @override
  State<ForYou> createState() => _ForYouState();
}

class _ForYouState extends State<ForYou> {
  late Stream<int> timerStream;
  int currentIndex =
      0; // Index to keep track of which pre-built widget to display
  final List<Widget> postCards = List.generate(5, (_) => PostCard());

  _ForYouState() {
    timerStream = Stream.periodic(Duration(minutes: 1), (i) => i);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedSwitcher(
          duration: Duration.zero, // Adjust duration as needed
          child: postCards[currentIndex],
          // Add a key to AnimatedSwitcher to ensure smooth transitions
          key: ValueKey<int>(currentIndex),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
