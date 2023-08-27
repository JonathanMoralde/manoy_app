import 'package:flutter/material.dart';
import 'package:manoy_app/widgets/postCard.dart';

class ForYou extends StatefulWidget {
  const ForYou({Key? key}) : super(key: key);

  @override
  State<ForYou> createState() => _ForYouState();
}

class _ForYouState extends State<ForYou> {
  late Stream<int> timerStream;

  _ForYouState() {
    timerStream = Stream.periodic(Duration(minutes: 1), (i) => i);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<int>(
          stream: timerStream,
          builder: (context, snapshot) {
            return PostCard();
          },
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
