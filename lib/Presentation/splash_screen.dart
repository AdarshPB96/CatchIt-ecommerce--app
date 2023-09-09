import 'package:catch_it_project/Presentation/first_screen-.dart';
import 'package:catch_it_project/Presentation/main_screen.dart';
import 'package:catch_it_project/constants/constat_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  final FirebaseAuth  _auth = FirebaseAuth.instance;
  SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tSize = MediaQuery.of(context).size;
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => StreamBuilder<User?>(
                stream: _auth.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  } else {
                    if (snapshot.hasData) {
                      return MainScreen();
                    } else {
                      return const FirstPage();
                    }
                  }
                },
              )));
    });
    return Scaffold(
      body: Stack(children: [
        Positioned.fill(
            child: Image.asset(
          "assets/WallpaperDog-17025259.jpg",
          fit: BoxFit.fill,
        )),
        Positioned(
          bottom: 0,
          top: tSize.height * 0.25,
          left: tSize.width * 0.25,
          child: tCatchIt,
        )
      ]),
    );
  }
}
