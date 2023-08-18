import 'package:flutter/material.dart';
import 'package:manoy_app/widgets/postCard.dart';

class ForYou extends StatelessWidget {
  const ForYou({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PostCard(),
        const SizedBox(
          height: 10,
        ),
        PostCard(),
        const SizedBox(
          height: 10,
        ),
        PostCard(),
        const SizedBox(
          height: 10,
        ),
        PostCard(),
        const SizedBox(
          height: 10,
        ),
        PostCard(),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
