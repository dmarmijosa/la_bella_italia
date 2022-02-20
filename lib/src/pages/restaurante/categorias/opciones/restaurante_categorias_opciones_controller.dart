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

  void goToCreateCategory() {
    Navigator.pushNamed(context, 'restaurante/categorias/crear');
  }

  void goToUpdateCategory() {
    Navigator.pushNamed(context, 'restaurante/categorias/actualizar');
  }

  void goToDeleteCategory() {
    Navigator.pushNamed(context, 'restaurante/categorias/eliminar');
  }
}
