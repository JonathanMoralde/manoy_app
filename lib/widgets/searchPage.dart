import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:manoy_app/widgets/shopCard.dart'; // Import your ShopCard widget

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];

  // Method to perform search based on user input
  void performSearch(String query) {
    FirebaseFirestore.instance
        .collection('service_provider')
        .where('Service Name', isGreaterThanOrEqualTo: query)
        .get()
        .then((snapshot) {
      setState(() {
        searchResults = snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });
    }).catchError((error) {
      print('Error searching: $error');
    });
  }

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
              onChanged: performSearch,
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
              // Display search results using ShopCard widget
              for (var shopData in searchResults)
                ShopCard(
                  name: shopData['Service Name'] ?? '',
                  address: shopData['Address'] ?? '',
                  uid: shopData['uid'] ?? '',
                  image: shopData['Profile Photo'] ?? '',
                  category: shopData['Category'] ?? '',
                  businessHours: shopData['Business Hours'] ?? '',
                  description: shopData['Description'] ?? '',
                  coverPhoto: shopData['Cover Photo'] ?? '',
                ),
            ],
          ),
        ),
      ),
    );
  }
}
