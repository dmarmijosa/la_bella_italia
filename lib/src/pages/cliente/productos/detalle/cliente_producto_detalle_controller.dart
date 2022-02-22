import 'package:flutter/material.dart';
import 'package:la_bella_italia/src/models/product.dart';
import 'package:la_bella_italia/src/utils/UtilsApp.dart';
import 'package:la_bella_italia/src/utils/shared_pref.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ClienteProductoDetalleController {
  BuildContext context;
  Function refresh;
  Product product;
  int amount = 1;

  double priceProductAdd;
  TextEditingController detailController = new TextEditingController();

  SharedPref _sharedPref = new SharedPref();
  List<Product> productSelect = [];

  Future init(BuildContext context, Function refresh, Product producto) async {
    this.context = context;
    this.refresh = refresh;
    this.product = producto;
    priceProductAdd = producto.price;

    //_sharedPref.remove('order');
    productSelect =
        Product.fromJsonList(await _sharedPref.read('order')).toList;

    productSelect.forEach((element) {
      print('producto seleccionado: ${element.toJson()}');
    });
    UtilsApp utilsApp = new UtilsApp();
    if (await utilsApp.internetConnectivity() == false) {
      Navigator.pushNamed(context, 'desconectado');
    }
    refresh();
  }

  void productInBold() {
    String detalle = detailController.text;
    int index = productSelect.indexWhere((p) => p.id == product.id);
    if (index == -1) {
      if (product.quantity == null) {
        product.quantity = 1;
      }
      productSelect.add(product);
    } else {
      productSelect[index].quantity = amount;
      productSelect[index].detail = detalle;
    }

    print('Datos: ${productSelect[0].detail}');
    _sharedPref.save('order', productSelect);
    Fluttertoast.showToast(msg: 'Producto agregado');
    goToBack();
  }

  void additem() {
    amount = amount + 1;
    priceProductAdd = product.price * amount;
    product.quantity = amount;
    refresh();
  }

  void reduceItem() {
    if (amount <= 1) {
      amount = 2;
    }
    amount = amount - 1;

    priceProductAdd = product.price * amount;
    product.quantity = amount;
    refresh();
  }

  void goToBack() {
    Navigator.pop(context);
  }
}
