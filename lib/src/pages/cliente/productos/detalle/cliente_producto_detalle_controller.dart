import 'package:flutter/material.dart';
import 'package:la_bella_italia/src/models/product.dart';
import 'package:la_bella_italia/src/utils/UtilsApp.dart';
import 'package:la_bella_italia/src/utils/shared_pref.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ClienteProductoDetalleController {
  BuildContext context;
  Function refresh;
  Product producto;
  int cantidad = 1;

  double precioProductoAgregado;
  TextEditingController detalleController = new TextEditingController();

  SharedPref _sharedPref = new SharedPref();
  List<Product> productoSelecionado = [];

  Future init(BuildContext context, Function refresh, Product producto) async {
    this.context = context;
    this.refresh = refresh;
    this.producto = producto;
    precioProductoAgregado = producto.price;

    //_sharedPref.remove('order');
    productoSelecionado =
        Product.fromJsonList(await _sharedPref.read('order')).toList;

    productoSelecionado.forEach((element) {
      print('producto seleccionado: ${element.toJson()}');
    });
    UtilsApp utilsApp = new UtilsApp();
    if (await utilsApp.internetConnectivity() == false) {
      Navigator.pushNamed(context, 'desconectado');
    }
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

    print('Datos: ${productoSelecionado[0].detail}');
    _sharedPref.save('order', productoSelecionado);
    Fluttertoast.showToast(msg: 'Producto agregado');
    regresarPaginaAnterior();
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
