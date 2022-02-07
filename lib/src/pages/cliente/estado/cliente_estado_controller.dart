import 'package:flutter/material.dart';

class ClienteEstadoController {
  BuildContext context;
  Function refresh;

  Future init(context, refresh) {
    this.context = context;
    this.refresh = refresh;
    refresh();
  }

  void finalizarCompra() {
    Navigator.pushNamedAndRemoveUntil(
        context, 'cliente/productos/lista', (route) => false);
    refresh();
  }
}
