
import 'package:catch_it_project/constants/size_color_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../domain/provider/signIn_provider.dart';

const Text tCatchIt = Text(
  "Catch it",
  style: TextStyle(fontSize: 60, fontFamily: "KaushanScript"),
);


TextField tSignInEmailTextField({required String text}) {
  return TextField(
    style: const TextStyle(
      fontSize: 20,
    ),
    decoration: InputDecoration(
      labelText: text,
    ),
  );
}

Consumer<SignInPro> tSigninPasswordTextField({required String text}) {
  return Consumer<SignInPro>(
    builder: (context, value, child) => TextField(
      obscureText: value.obscureText,
      style: const TextStyle(
        fontSize: 20,
      ),
      decoration: InputDecoration(
          labelText: text,
          suffix: IconButton(
              onPressed: () {
                value.toggleVisibility();
              },
              icon: Icon(value.obscureText == true
                  ? Icons.visibility
                  : Icons.visibility_off))),
    ),
  );
}

ElevatedButton elButtonWithText(
    {required String text,
    required height,
    required width,
    double? fontSize,
    Color? disabledBackgroundColor,
    Function()? onpressed}) {
  return ElevatedButton(
    onPressed: onpressed,
    style: ElevatedButton.styleFrom(
      disabledBackgroundColor: disabledBackgroundColor ?? tBlue,
      disabledForegroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      minimumSize: Size(width, height),
    ),
    child: Text(
      text,
      style:  TextStyle(fontSize: fontSize ?? 20),
    ),
  );
}
