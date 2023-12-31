import 'package:flutter/material.dart';

// class BtnObject {
//   final String name;
//   // final void Function(String category) onTap;
//   final void Function(dynamic) onTap;

//   BtnObject({required this.name, required this.onTap});
// }
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manoy_app/widgets/styledButton.dart';

import '../provider/filterBtn/activeCategory_provider.dart';
import '../provider/filterBtn/fetchCategory_provider.dart';

class FilterBtns extends ConsumerWidget {
  FilterBtns({Key? key}) : super(key: key);

  // String _activeCategory = "All"; // Default active category

  // @override
  // void initState() {
  //   super.initState();
  //   fetchCategories();
  // }

  // void fetchCategories() async {
  //   final categoriesCollection =
  //       FirebaseFirestore.instance.collection('categories');
  //   final QuerySnapshot<Map<String, dynamic>> categoriesSnapshot =
  //       await categoriesCollection.get();

  //   final List<String> fetchedCategories = [
  //     "All",
  //     // (selectedCategory) {
  //     // setState(() {
  //     //   _activeCategory = selectedCategory;
  //     // });
  //     // print("Selected category: $_activeCategory");
  //     // // You can perform other actions based on the selected category.
  //     // },
  //   ];
  //   // fetchedCategories.add(
  //   //   BtnObject(
  //   //     name: "All",
  //   //     onTap: (selectedCategory) {
  //   //       setState(() {
  //   //         _activeCategory = selectedCategory;
  //   //       });
  //   //       print("Selected category: $_activeCategory");
  //   //       // You can perform other actions based on the selected category.
  //   //     },
  //   //   ),
  //   // );

  //   // Iterate through fetched documents and add to the category list
  //   categoriesSnapshot.docs.forEach((categoryDoc) {
  //     final categoryName = categoryDoc.data()['categoryName'] as String;
  //     fetchedCategories.add(categoryName
  //         // BtnObject(
  //         //   name: categoryName,
  //         //   onTap: (selectedCategory) {
  //         //     setState(() {
  //         //       _activeCategory = selectedCategory;
  //         //     });
  //         //     print("Selected category: $_activeCategory");
  //         //     // You can perform other actions based on the selected category.
  //         //   },
  //         // ),
  //         );
  //   });

  //   setState(() {
  //     category = fetchedCategories;
  //   });
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _activeCategory = ref.watch(activeCategoryProvider);
    // final List<String> category = ref.watch(fetchCategoryProvider).value ?? [];
    final List<String> category = [
      "All",
      "Maintenance and Repairs",
      "Parts and accessories",
      "Car Wash and Detailing",
      "Fuel and charging station",
      "Inspection and emissions",
    ];
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: SizedBox(
        height: 35,
        child: ListView.builder(
          itemCount: category.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final bool isActive = _activeCategory == category[index];

            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: StyledButton(
                btnText: category[index],
                fontSize: 14,
                onClick: () {
                  // setState(() {
                  //   _activeCategory = category[index];
                  // });
                  ref.read(activeCategoryProvider.notifier).state =
                      category[index];
                },
                btnColor: isActive
                    ? const Color(0xFFFC7F03)
                    : const Color(0xFF00A2FF),
              ),
            );
            // Padding(
            //   padding: const EdgeInsets.only(right: 10),
            //   child: ElevatedButton(
            //     onPressed: () {
            //       category[index].onTap(category[index].name);
            //     },
            //     child: Text(category[index].name),
            //     style: ElevatedButton.styleFrom(
            //       primary: isActive
            //           ? const Color(0xFFFE3034)
            //           : const Color(0xFFE2B563),
            //       textStyle: TextStyle(
            //         color: isActive ? Colors.black : Colors.white,
            //       ),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(10.0),
            //       ),
            //     ),
            //   ),
            // );
          },
        ),
      ),
    );
  }
}
