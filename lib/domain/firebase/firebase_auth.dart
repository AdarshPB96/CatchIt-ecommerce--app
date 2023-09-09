import 'dart:developer';

import 'package:catch_it_project/Presentation/main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirebaseAuthentication {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();

  bool loading = false;

  signUp(context) async {
    try {
      loading = true;
      await auth.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => MainScreen(),
      ));
      loading = false;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
      loading = false;
    }
  }

  addUser() async {
    await db.collection("users").doc(auth.currentUser?.uid).set(
        {"username": usernameController.text, "email": emailController.text});
  }

  signOut() async {
    await auth.signOut();
  }

  logIn(context) async {
    try {
      await auth.signInWithEmailAndPassword(
          email: loginEmailController.text,
          password: loginPasswordController.text);
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => MainScreen(),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      List<String> signInMethos = await auth.fetchSignInMethodsForEmail(email);
      if (signInMethos.isEmpty) {
        log('Email is not registered');
      } else {
        await auth.sendPasswordResetEmail(email: email);
        Fluttertoast.showToast(msg: " Password recovery email send");
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
