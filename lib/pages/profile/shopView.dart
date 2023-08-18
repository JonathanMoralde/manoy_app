import 'package:flutter/material.dart';
import 'package:manoy_app/widgets/styledButton.dart';

class ShopView extends StatelessWidget {
  const ShopView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomCenter,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: SizedBox(
                        height: 250,
                        width: double.infinity,
                        child: Image.asset('lib/images/cover.png'),
                      ),
                    ), // PROFILE PHOTO
                    Positioned(
                      bottom: -50,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: Colors.white, // Border color
                            width: 4, // Border width
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: Image.asset(
                              'lib/images/testImage.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.bookmark_add_outlined,
                      size: 35,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 0,
                ),
                SizedBox(
                  width: 300,
                  child: Text(
                    "Jonnel Angel Red Kaldag Services",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text("5/5 Ratings") //! TEMPORARY
                ,
                const SizedBox(
                  height: 10,
                ),
                Text("Polangui, Albay"),
                const SizedBox(
                  height: 10,
                ),
                Text("Business Hours: 8AM - 5PM"),
                const SizedBox(
                  height: 10,
                ),
                Text("Category: Accessories & Repair Shop"),
                const SizedBox(
                  height: 5,
                ),
                Divider(
                  height: 0,
                ),
                const SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      "We offer 11/10 services! Message us and send an appointment!"),
                ),
                const SizedBox(
                  height: 5,
                ),
                Divider(
                  height: 0,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StyledButton(btnText: "RATE", onClick: () {}),
                    const SizedBox(
                      width: 10,
                    ),
                    StyledButton(btnText: "MESSAGE", onClick: () {}),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                StyledButton(btnText: "MAKE APPOINTMENT", onClick: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
