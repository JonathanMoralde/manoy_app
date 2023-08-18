import 'package:flutter/material.dart';
import 'package:manoy_app/widgets/filterBtns.dart';

class FindShops extends StatelessWidget {
  const FindShops({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: FilterBtns(),
        ),
        Text("test")
      ],
    );
  }
}
