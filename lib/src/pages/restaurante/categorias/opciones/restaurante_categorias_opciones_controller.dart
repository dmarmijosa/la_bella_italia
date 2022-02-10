import 'package:flutter/material.dart';

class RestauranteCategoriasOpcionesController {
  BuildContext context;
  Function refresh;

  void init(BuildContext context, Function refresh) {
    this.context = context;
    this.refresh = refresh;
  }

  void irACreacionCategoria() {
    Navigator.pushNamed(context, 'restaurante/categorias/crear');
  }

  void irAActualizarCategoria() {
    Navigator.pushNamed(context, 'restaurante/producto/actualizar');
  }

  void irAEliminarCategoria() {
    Navigator.pushNamed(context, 'restaurante/producto/eliminar');
  }
}
