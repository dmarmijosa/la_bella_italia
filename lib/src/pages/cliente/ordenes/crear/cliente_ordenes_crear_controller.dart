import 'package:flutter/material.dart';
import 'package:la_bella_italia/src/models/producto.dart';
import 'package:la_bella_italia/src/utils/shared_pref.dart';

class ClienteOrdenesCrearController {
  BuildContext context;
  Function refresh;

  SharedPref _sharedPref = new SharedPref();

  List<Producto> productosSeleccionados = [];
  double total = 0;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    productosSeleccionados =
        Producto.fromJsonList(await _sharedPref.read('order')).toList;
    obtenerTotal();
    refresh();
  }

  void obtenerTotal() {
    total = 0;
    productosSeleccionados.forEach((producto) {
      total = total + (producto.quantity * producto.price);
    });
    refresh();
  }

  void aumentarItem(Producto producto) {
    int index = productosSeleccionados.indexWhere((p) => p.id == producto.id);
    productosSeleccionados[index].quantity =
        productosSeleccionados[index].quantity + 1;

    _sharedPref.save('order', productosSeleccionados);
    obtenerTotal();
    //refresh();
  }

  void reducirItem(Producto producto) {
    if (producto.quantity > 1) {
      int index = productosSeleccionados.indexWhere((p) => p.id == producto.id);
      productosSeleccionados[index].quantity =
          productosSeleccionados[index].quantity - 1;

      _sharedPref.save('order', productosSeleccionados);
      obtenerTotal();
      //refresh();
    }
  }

  void eliminarItem(Producto producto) {
    productosSeleccionados.removeWhere((p) => p.id == producto.id);
    _sharedPref.save('order', productosSeleccionados);
    obtenerTotal();
  }
}
