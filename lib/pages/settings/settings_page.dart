import 'package:flutter/material.dart';
import 'package:manoy_app/widgets/bottomNav.dart';
import 'package:manoy_app/widgets/styled_settings_button.dart';

class SettingsPage extends StatelessWidget {

  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Settings'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: Image.asset(
              'lib/images/settings_logo.png',
              width: 70,
              height: 70,
            ),
          )
        ],
      ),
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            Row(
              children: [
                SizedBox(height: 20),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage(
                        'lib/images/avatar.png',
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 40),
                    child: Text(
                      'Jonnel Angelo Red Kaldagero Ekalam Etits',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            StyledSettingsButton(
              buttonText: 'Apply Service Provider Account',
              onPressed: null,
            ),
            SizedBox(
              height: 5,
            ),
            StyledSettingsButton(
              buttonText: 'Contact Information',
              onPressed: null,
            ),
            SizedBox(
              height: 5,
            ),
            StyledSettingsButton(
              buttonText: 'Change Profile Picture',
              onPressed: null,
            ),
            SizedBox(
              height: 5,
            ),
            StyledSettingsButton(
              buttonText: 'Change Password',
              onPressed: null,
            ),
            SizedBox(
              height: 5,
            ),
            StyledSettingsButton(
              buttonText: 'Contact Us',
              onPressed: null,
            ),
            SizedBox(
              height: 5,
            ),
            StyledSettingsButton(
              buttonText: 'Terms and Condition',
              onPressed: null,
            ),
            SizedBox(
              height: 5,
            ),
            StyledSettingsButton(
              buttonText: 'Help',
              onPressed: null,
            ),
            SizedBox(
              height: 5,
            ),
            StyledSettingsButton(
              buttonText: 'Log out',
              onPressed: null,
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }
}
