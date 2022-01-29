import 'dart:async';

import 'package:flutter/material.dart';
import 'package:la_bella_italia/src/models/producto.dart';
import 'package:la_bella_italia/src/providers/user_provider.dart';
import 'package:la_bella_italia/src/utils/shared_pref.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ClienteOrdenesCrearController {
  BuildContext context;
  Function refresh;

  SharedPref _sharedPref = new SharedPref();
  UserProvider userProvider = new UserProvider();

  List<Producto> productosSeleccionados = [];
  double total = 0;

  bool estadoRestaurante;
  String mensaje;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    userProvider.init(context);

    this.estadoRestaurante = await userProvider.restaurantIsAvaiable();

    productosSeleccionados =
        Producto.fromJsonList(await _sharedPref.read('order')).toList;
    print(estadoRestaurante);
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

  void irADirecciones() {
    if (this.estadoRestaurante) {
      Navigator.pushNamed(context, 'cliente/direcciones/lista');
    } else {
      Fluttertoast.showToast(msg: 'El restaurant se encuentra cerrado.');
      Timer(Duration(seconds: 3), () {
        Navigator.pushNamed(context, 'cliente/productos/lista');
      });
    }
  }
}
