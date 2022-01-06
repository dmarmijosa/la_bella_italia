import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:la_bella_italia/src/pages/cliente/productos/lista/cliente_producto_lista_controller.dart';

class ClienteProductoListaPage extends StatefulWidget {
  const ClienteProductoListaPage({key}) : super(key: key);

  @override
  _ClienteProductoListaPageState createState() =>
      _ClienteProductoListaPageState();
}

class _ClienteProductoListaPageState extends State<ClienteProductoListaPage> {
  ClienteProductoListaController _cplc = new ClienteProductoListaController();

  @override
  void initState() {
    super.initState();
    try {
      SchedulerBinding.instance.addPersistentFrameCallback((timeStamp) {
        _cplc.init(context);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: _cplc.logout,
          child: Text('Cerrar Sessión'),
        ),
      ),
    );
  }
}
