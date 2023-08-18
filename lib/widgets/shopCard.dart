import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manoy_app/pages/profile/shopView.dart';

class ShopCard extends ConsumerWidget {
  final String name;
  final String address;
  final double? height;
  const ShopCard(
      {super.key, required this.name, required this.address, this.height});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void handleTap() {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) {
          return ShopView();
        }),
      );
    }

    return GestureDetector(
      onTap: () {
        handleTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Container(
          width: double.infinity,
          height: height ?? 100,
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                  child: Image.asset(
                    'lib/images/testImage.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        "5/5 Ratings",
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        address,
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        "Accessories & Repair Services",
                        style: TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
