import 'package:flutter/material.dart';

class ClienteProductoListaPage extends StatefulWidget {
  const ClienteProductoListaPage({key}) : super(key: key);

  @override
  _ClienteProductoListaPageState createState() =>
      _ClienteProductoListaPageState();
}

class _ClienteProductoListaPageState extends State<ClienteProductoListaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Lista de productos'),
      ),
    );
  }
}
