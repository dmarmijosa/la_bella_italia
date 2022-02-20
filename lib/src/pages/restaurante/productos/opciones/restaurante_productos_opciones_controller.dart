import 'package:flutter/material.dart';

class RestauranteProductosOpcionesController {
  BuildContext context;
  Function refresh;

  void init(BuildContext context, Function refresh) {
    this.context = context;
    this.refresh = refresh;
  }

  void goToCreateProduct() {
    Navigator.pushNamed(context, 'restaurante/producto/crear');
  }

  void goToUpdateProduct() {
    Navigator.pushNamed(context, 'restaurante/producto/actualizar');
  }

  void goToDeleteProduct() {
    Navigator.pushNamed(context, 'restaurante/producto/eliminar');
  }
}
