import 'package:flutter/material.dart';
import 'package:manoy_app/pages/home/home_postFeed.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FEED"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: PostFeed(),
        ),
      ),
    );
  }
}
