import 'dart:developer';

import 'package:catch_it_project/Presentation/sign_up.dart';
import 'package:catch_it_project/constants/constat_widgets.dart';
import 'package:catch_it_project/constants/size_color_constants.dart';
import 'package:catch_it_project/domain/firebase/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../domain/provider/signIn_provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tSize = MediaQuery.of(context).size;
    FirebaseAuthentication firebaseAuth = FirebaseAuthentication();
    // final loginProvider = Provider.of<SignInPro>(context);

    return SafeArea(
      child: Scaffold(
          body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              tSizedBoxHeight100,
              tCatchIt,
              SizedBox(height: tSize.height * 0.05),
              tSizedBoxHeight10,
              TextField(
                controller: firebaseAuth.loginEmailController,
                style: const TextStyle(
                  fontSize: 20,
                ),
                decoration: const InputDecoration(
                  labelText: "Enter Your Email",
                ),
              ),
              // tSignInEmailTextField(text: "Enter Your Email"),
              tSizedBoxHeight30,
              Consumer<SignInPro>(
                builder: (context, value, child) => TextField(
                  controller: firebaseAuth.loginPasswordController,
                  obscureText: value.obscureText,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                      labelText: "Password",
                      suffix: IconButton(
                          onPressed: () {
                            value.toggleVisibility();
                          },
                          icon: Icon(value.obscureText == true
                              ? Icons.visibility
                              : Icons.visibility_off))),
                ),
              ),
              // tSigninPasswordTextField(text: "Password"),
              tSizedBoxHeight20,
              elButtonWithText(
                text: "Log In",
                height: 40.0,
                width: 100.0,
                onpressed: () {
                  firebaseAuth.logIn(context);
                },
              ),
              tSizedBoxHeight10,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Dont't have an account?"),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpPage(),
                            ));
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))
                ],
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgotPassword(),
                        ));
                  },
                  child: const Text(
                    "Forgot Password",
                    style: TextStyle(color: Colors.blue),
                  ))
            ],
          ),
        ),
      )),
    );
  }
}

class ForgotPassword extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final FirebaseAuthentication firebaseAuth = FirebaseAuthentication();
  ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    String? email;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back)),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "Enter your Email"),
                controller: emailController,
                onChanged: (value) {
                  email = value;
                },
              ),
            ),
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    log(email.toString());
                    firebaseAuth.sendPasswordResetEmail(email.toString());
                  },
                  child: const Text("Forgot Password")),
            )
          ],
        ),
      ),
    );
  }
}
