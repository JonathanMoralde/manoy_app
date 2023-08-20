import 'package:flutter/material.dart';
import 'package:manoy_app/widgets/shopCard.dart';

class SearchPage extends StatelessWidget {
  SearchPage({super.key});

  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search...",
                border: InputBorder.none,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: () {
                    searchController.clear();
                  },
                  icon: Icon(
                    Icons.clear,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ShopCard(
              //   name: "John Doe",
              //   address: "Polangui, Albay",
              // ), //TODO REPLACE THIS WITH ACTUAL SEARCH ITEMS
            ],
          ),
        ),
      ),
    );
  }
}
