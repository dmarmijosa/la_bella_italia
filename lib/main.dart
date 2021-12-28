import 'package:flutter/material.dart';
import 'package:la_bella_italia/src/login/login_page.dart';
import 'package:la_bella_italia/src/utils/my_colors.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'La Bella Italia',
      debugShowCheckedModeBanner: false,
      initialRoute: 'login',
      routes: {'login': (BuildContext context) => LoginPage()},
      theme: ThemeData(primaryColor: MyColors.primaryColor),
    );
  }
}
