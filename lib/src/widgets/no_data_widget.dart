import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NoDataWidget extends StatelessWidget {
  String text;
  NoDataWidget({key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/img/no_items.png'),
          Text(text),
        ],
      ),
    );
  }
}
