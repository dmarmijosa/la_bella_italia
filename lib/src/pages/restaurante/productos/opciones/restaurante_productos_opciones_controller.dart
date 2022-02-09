import 'package:flutter/material.dart';

class RestauranteProductosOpcionesController {
  BuildContext context;
  Function refresh;

  void init(BuildContext context, Function refresh) {
    this.context = context;
    this.refresh = refresh;
  }

  void irACreacionProductos() {
    Navigator.pushNamed(context, 'restaurante/producto/crear');
  }

  void irAActualizarProductos() {
    Navigator.pushNamed(context, 'restaurante/producto/actualizar');
  }

  void irAEliminarProducto() {}
}
