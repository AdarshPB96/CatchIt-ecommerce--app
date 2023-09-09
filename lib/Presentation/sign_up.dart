import 'package:catch_it_project/Presentation/login_page.dart';
import 'package:catch_it_project/domain/firebase/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/constat_widgets.dart';
import '../constants/size_color_constants.dart';
import '../domain/provider/signIn_provider.dart';

class SignUpPage extends StatelessWidget {

  final TextEditingController confirmPasswordController =
      TextEditingController();
 final FirebaseAuthentication firebaseAuth = FirebaseAuthentication();
  SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formkey = GlobalKey<FormState>();
    return Scaffold(
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            tSizedBoxHeight100,
            const Center(child: tCatchIt),
            Form(
                key: formkey,
                child: Column(
                  children: [
                    tSizedBoxHeight10,
                    TextFormField(
                      controller: firebaseAuth.usernameController,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                      decoration: const InputDecoration(
                        labelText: "User Name",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Plese enter a name";
                        } else if (value.trim().split(" ").length < 2) {
                          return "Please enter full name";
                        } else if (value.trim().length < 4) {
                          return "Name must be at least 4 characters long";
                        }
                        return null; // no validation error
                      },
                    ),
                    // tSignInEmailTextField(text: "User Name"),
                    tSizedBoxHeight10,
                    TextFormField(
                      controller: firebaseAuth.emailController,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                      decoration: const InputDecoration(
                        labelText: "Enter Your Email",
                      ),
                      validator: (value) {
                        if (value == null) {
                          return "Enter an email";
                        } else if (!value.contains("@")) {
                          return "Please enter a valid email";
                        }
                        return null;
                      },
                    ),
                    // tSignInEmailTextField(text: "Email"),
                    tSizedBoxHeight10,
                    Consumer<SignInPro>(
                      builder: (context, value, child) => TextFormField(
                        controller: firebaseAuth.passwordController,
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter password";
                          } else if (value.length < 4) {
                            return "Password must be at least 4 characters long";
                          }
                          return null;
                        },
                      ),
                    ),
                    // tSigninPasswordTextField(text: "Password"),
                    tSizedBoxHeight10,
                    Consumer<SignInPro>(
                      builder: (context, value, child) => TextFormField(
                        controller: firebaseAuth.confirmpasswordController,
                        obscureText: value.obscureText,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                        decoration: InputDecoration(
                            labelText: "Confirm Password",
                            suffix: IconButton(
                                onPressed: () {
                                  value.toggleVisibility();
                                },
                                icon: Icon(value.obscureText == true
                                    ? Icons.visibility
                                    : Icons.visibility_off))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please confirm the password";
                          } else if (value !=
                              firebaseAuth.passwordController.text) {
                            return "Passwords do not match";
                          }
                          return null;
                        },
                      ),
                    ),
                    // tSigninPasswordTextField(text: "Confirm Password"),
                    tSizedBoxHeight20,
                    elButtonWithText(
                        onpressed: () {
                          if (formkey.currentState?.validate() == true) {
                            firebaseAuth.signUp(context);
                          }
                        },
                        text: "Sign In",
                        height: 40.0,
                        width: 100.0),
                    tSizedBoxHeight20,
                  ],
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account?"),
                InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ));
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))
              ],
            ),
          ],
        ),
      )),
    );
  }
}
