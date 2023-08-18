import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // height: 250,
      decoration: BoxDecoration(color: Colors.grey.shade200),
      child: Column(
        children: [
          // HEADER
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Image.asset(
                  'lib/images/logo.png', //TODO PROFILE PICTURE
                  width: 50,
                  height: 50,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Manoy Jonnel Angelo Destroyer"),
                    Text(
                      "34 Minutes Ago",
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                )
              ],
            ),
          ),

          // TEXT
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
                "Wazzup! Ready na me for another kaldag service! HMU ASAP!"),
          ),

          // IMAGE
          SizedBox(
              width: double.infinity,
              child: Image.asset('lib/images/testImage.jpg')),
        ],
      ),
    );
  }
}
