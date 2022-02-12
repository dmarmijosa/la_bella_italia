import 'package:flutter/material.dart';
import 'package:la_bella_italia/src/utils/utilsApp.dart';

class RestauranteMensajerosOpcionesController {
  BuildContext context;
  Function refresh;
  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    UtilsApp utilsApp = new UtilsApp();
    if (await utilsApp.internetConnectivity() == false) {
      Navigator.pushNamed(context, 'desconectado');
    }

    refresh();
  }

  void irAAgregarMensajero() {
    Navigator.pushNamed(context, 'restaurante/mensajeros/agregar');
  }

  void irAEliminar() {
    Navigator.pushNamed(context, 'restaurante/mensajeros/eliminar');
  }
}
