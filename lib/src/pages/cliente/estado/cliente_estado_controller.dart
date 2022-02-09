import 'package:flutter/material.dart';
import 'package:la_bella_italia/src/utils/UtilsApp.dart';

class ClienteEstadoController {
  BuildContext context;
  Function refresh;

  void init(context, refresh) async {
    this.context = context;
    this.refresh = refresh;
    UtilsApp utilsApp = new UtilsApp();
    if (await utilsApp.internetConnectivity() == false) {
      Navigator.pushNamed(context, 'desconectado');
    }
    refresh();
  }

  void finalizarCompra() {
    Navigator.pushNamedAndRemoveUntil(
        context, 'cliente/productos/lista', (route) => false);
    refresh();
  }
}
