import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manoy_app/pages/home/home_findShops.dart';
import 'package:manoy_app/pages/home/home_forYou.dart';
import 'package:manoy_app/provider/home/activeDisplay_provider.dart';
import 'package:manoy_app/widgets/bottomNav.dart';
import 'package:manoy_app/widgets/searchPage.dart';
import 'package:manoy_app/widgets/slider.dart';

// PROVIDER

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeDisplay = ref.watch(activeDisplayProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Manoy!"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) {
                  return SearchPage();
                }),
              );
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      ref.read(activeDisplayProvider.notifier).state =
                          "For You";
                    },
                    child: SizedBox(
                      // width: double.infinity,
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.home,
                          )
                              .animate(
                                  target: activeDisplay == "For You" ? 1 : 0)
                              .tint(color: Color(0xFF00A2FF)),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text(
                            "For You",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          )
                              .animate(
                                  target: activeDisplay == "For You" ? 1 : 0)
                              .tint(color: Color(0xFF00A2FF)),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      ref.read(activeDisplayProvider.notifier).state =
                          "Find Shops";
                    },
                    child: SizedBox(
                      // width: double.infinity,
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.store,
                          )
                              .animate(
                                  target: activeDisplay == "For You" ? 0 : 1)
                              .tint(color: Color(0xFF00A2FF)),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text(
                            "Find Shops",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          )
                              .animate(
                                  target: activeDisplay == "For You" ? 0 : 1)
                              .tint(color: Color(0xFF00A2FF)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SliderBar(),
            Expanded(
              child: SingleChildScrollView(
                child: activeDisplay == "For You" ? ForYou() : FindShops(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}
