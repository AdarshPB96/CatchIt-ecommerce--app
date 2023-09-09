import 'package:catch_it_project/Presentation/login_page.dart';
import 'package:catch_it_project/Presentation/sign_up.dart';
import 'package:catch_it_project/constants/constat_widgets.dart';
import 'package:flutter/material.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/peakpx (1).jpg",
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            left: tSize.width * 0.4,
            top: tSize.height * 0.07,
            child: const Text(
              "Welcome",
              style: TextStyle(fontSize: 20),
            ),
          ),
          Positioned(
              top: tSize.height * 0.1,
              left: tSize.width * 0.25,
              child: tCatchIt),
          Positioned(
              left: tSize.width * 0.36,
              bottom: 50,
              child: elButtonWithText(
                disabledBackgroundColor: const Color.fromARGB(255, 160, 163, 172),
                text: "Sign Up",
                height: tSize.height * 0.05,
                width: tSize.width * 0.3,
                onpressed: () =>
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) =>  SignUpPage(),
                )),
              )),
          Positioned(
              left: tSize.width * 0.36,
              bottom: 100,
              child: elButtonWithText(
                text: "Log In",
                height: tSize.height * 0.05,
                width: tSize.width * 0.3,
                onpressed: () =>
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                )),
              )),
        ],
      ),
    );
  }
}
