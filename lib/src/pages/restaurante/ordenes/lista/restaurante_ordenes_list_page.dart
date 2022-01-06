import 'package:flutter/material.dart';

class RestauranteOrdenesListaPage extends StatefulWidget {
  const RestauranteOrdenesListaPage({key}) : super(key: key);

  @override
  _RestauranteOrdenesListaPageState createState() =>
      _RestauranteOrdenesListaPageState();
}

class _RestauranteOrdenesListaPageState
    extends State<RestauranteOrdenesListaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Restaurant list'),
      ),
    );
  }
}
