import 'package:flutter/material.dart';
import 'package:la_bella_italia/src/utils/my_colors.dart';
import 'package:lottie/lottie.dart';

class NoConecction extends StatelessWidget {
  const NoConecction({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          _animacion(context),
          _txtData(),
          _btnNoContection(context),
        ],
      ),
    ));
  }

  Widget _btnNoContection(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      child: ElevatedButton.icon(
        icon: Icon(Icons.sync),
        onPressed: () {
          Navigator.pushNamed(context, 'login');
        },
        label: Text('Voler a intentarlo'),
        style: ElevatedButton.styleFrom(
            primary: MyColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            padding: EdgeInsets.symmetric(vertical: 10)),
      ),
    );
  }

  Widget _txtData() {
    return Container(
      child: Text(
        'Sin conexión a internet',
        style: TextStyle(fontFamily: 'Pacifico', fontSize: 25),
      ),
    );
  }

  Widget _animacion(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.2,
          bottom: MediaQuery.of(context).size.height * 0.1),
      child: Lottie.asset('assets/json/connection.json',
          width: 220, height: 159, fit: BoxFit.fill),
    );
  }
}
