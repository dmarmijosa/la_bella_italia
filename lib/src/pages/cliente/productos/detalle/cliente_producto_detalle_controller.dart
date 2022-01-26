import 'package:flutter/material.dart';
import 'package:la_bella_italia/src/models/producto.dart';
import 'package:la_bella_italia/src/utils/shared_pref.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ClienteProductoDetalleController {
  BuildContext context;
  Function refresh;
  Producto producto;
  int cantidad = 1;

  double precioProductoAgregado;
  TextEditingController detalleController = new TextEditingController();

  SharedPref _sharedPref = new SharedPref();
  List<Producto> productoSelecionado = [];

  Future init(BuildContext context, Function refresh, Producto producto) async {
    this.context = context;
    this.refresh = refresh;
    this.producto = producto;
    precioProductoAgregado = producto.price;

    //_sharedPref.remove('order');
    productoSelecionado =
        Producto.fromJsonList(await _sharedPref.read('order')).toList;

    productoSelecionado.forEach((element) {
      print('producto seleccionado: ${element.toJson()}');
    });
    refresh();
  }

  void productosEnBolsa() {
    String detalle = detalleController.text;
    int index = productoSelecionado.indexWhere((p) => p.id == producto.id);
    if (index == -1) {
      if (producto.quantity == null) {
        producto.quantity = 1;
      }
      productoSelecionado.add(producto);
    } else {
      productoSelecionado[index].quantity = cantidad;
      productoSelecionado[index].detail = detalle;
    }

    print('Datos: ${productoSelecionado[1].detail}');
    _sharedPref.save('order', productoSelecionado);
    Fluttertoast.showToast(msg: 'Producto agregado');
  }

  void sumarItem() {
    cantidad = cantidad + 1;
    precioProductoAgregado = producto.price * cantidad;
    producto.quantity = cantidad;
    refresh();
  }

  void restarItem() {
    if (cantidad <= 1) {
      cantidad = 2;
    }
    cantidad = cantidad - 1;

    precioProductoAgregado = producto.price * cantidad;
    producto.quantity = cantidad;
    refresh();
  }

  void regresarPaginaAnterior() {
    Navigator.pop(context);
  }
}
