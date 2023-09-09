
import 'package:flutter/material.dart';


class SignInPro extends ChangeNotifier {
  bool _obscureText = true;
  bool get obscureText => _obscureText;
  void toggleVisibility() {
    _obscureText = !_obscureText;
    notifyListeners();
  }
}
