import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NoDataWidget extends StatelessWidget {
  String texto;
  NoDataWidget({key, this.texto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 250),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/img/no_items.png'),
          Text(texto),
        ],
      ),
    );
  }
}
