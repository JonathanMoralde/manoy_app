import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:manoy_app/pages/home/home.dart';
import 'package:manoy_app/pages/loginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _checkIsLogged(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        bool? isLogged = snapshot.data;

        if (isLogged == true) {
          print(isLogged);
          return HomePage();
        } else {
          print(isLogged);
          return LoginScreen();
        }
      },
    );
  }

  Future _checkIsLogged() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLogged');
  }
}
