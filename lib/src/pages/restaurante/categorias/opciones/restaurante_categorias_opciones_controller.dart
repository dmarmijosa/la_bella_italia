import 'package:flutter/material.dart';
import 'package:la_bella_italia/src/utils/utilsApp.dart';

class RestauranteCategoriasOpcionesController {
  BuildContext context;
  Function refresh;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    UtilsApp utilsApp = new UtilsApp();
    if (await utilsApp.internetConnectivity() == false) {
      Navigator.pushNamed(context, 'desconectado');
    }
  }

  void irACreacionCategoria() {
    Navigator.pushNamed(context, 'restaurante/categorias/crear');
  }

  void irAActualizarCategoria() {
    Navigator.pushNamed(context, 'restaurante/categorias/actualizar');
  }

  void irAEliminarCategoria() {
    Navigator.pushNamed(context, 'restaurante/categorias/eliminar');
  }
}
