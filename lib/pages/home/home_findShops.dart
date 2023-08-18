import 'package:flutter/material.dart';
import 'package:manoy_app/widgets/filterBtns.dart';
import 'package:manoy_app/widgets/shopCard.dart';

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
        ShopCard(
          name: "Jonnel Angel Red",
          address: "Polangui Albay",
        ),
        const SizedBox(
          height: 10,
        ),
        ShopCard(
          name: "Jonnel Angel Red",
          address: "Polangui Albay",
        ),
        const SizedBox(
          height: 10,
        ),
        ShopCard(
          name: "Jonnel Angel Red",
          address: "Polangui Albay",
        ),
        const SizedBox(
          height: 10,
        ),
        ShopCard(
          name: "Jonnel Angel Red",
          address: "Polangui Albay",
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
