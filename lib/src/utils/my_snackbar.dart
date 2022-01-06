import 'package:flutter/material.dart';

class MyScnackbar {
  static void show(BuildContext context, String text) {
    if (context == null) return;

    FocusScope.of(context).requestFocus(new FocusNode());
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      new SnackBar(
        content: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        backgroundColor: Colors.black,
        duration: Duration(seconds: 3),
      ),
    );
  }

  static void testConnection(BuildContext context, String text) {
    if (context == null) return;

    FocusScope.of(context).requestFocus(new FocusNode());
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      new SnackBar(
        content: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        backgroundColor: Colors.black,
        duration: Duration(seconds: 12),
      ),
    );
  }

  static bool emailValid(email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }
}
