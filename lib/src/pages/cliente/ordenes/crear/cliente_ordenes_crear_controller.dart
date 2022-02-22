import 'dart:async';

import 'package:flutter/material.dart';
import 'package:la_bella_italia/src/models/product.dart';
import 'package:la_bella_italia/src/providers/user_provider.dart';
import 'package:la_bella_italia/src/utils/UtilsApp.dart';
import 'package:la_bella_italia/src/utils/shared_pref.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ClienteOrdenesCrearController {
  BuildContext context;
  Function refresh;

  SharedPref _sharedPref = new SharedPref();
  UserProvider _userProvider = new UserProvider();

  List<Product> selectProducts = [];
  double total = 0;

  bool stateRestaurant;
  String message;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    _userProvider.init(context);

    this.stateRestaurant = await _userProvider.restaurantIsAvaiable();

    selectProducts =
        Product.fromJsonList(await _sharedPref.read('order')).toList;
    print(stateRestaurant);
    getTotal();

    UtilsApp utilsApp = new UtilsApp();
    if (await utilsApp.internetConnectivity() == false) {
      Navigator.pushNamed(context, 'desconectado');
    }
    refresh();
  }

  void getTotal() {
    total = 0;
    selectProducts.forEach((producto) {
      total = total + (producto.quantity * producto.price);
    });
    refresh();
  }

  void addItem(Product producto) {
    int index = selectProducts.indexWhere((p) => p.id == producto.id);
    selectProducts[index].quantity = selectProducts[index].quantity + 1;

    _sharedPref.save('order', selectProducts);
    getTotal();
    //refresh();
  }

  void reduceItem(Product producto) {
    if (producto.quantity > 1) {
      int index = selectProducts.indexWhere((p) => p.id == producto.id);
      selectProducts[index].quantity = selectProducts[index].quantity - 1;

      _sharedPref.save('order', selectProducts);
      getTotal();
      //refresh();
    }
  }

  void deleteItem(Product producto) {
    selectProducts.removeWhere((p) => p.id == producto.id);
    _sharedPref.save('order', selectProducts);
    getTotal();
  }

  void goToAddressList() {
    if (this.stateRestaurant) {
      if (this.selectProducts.length > 0) {
        Navigator.pushNamed(context, 'cliente/direcciones/lista');
      } else {
        Fluttertoast.showToast(msg: 'Selecciona al menos un producto.');
      }
    } else {
      Fluttertoast.showToast(msg: 'El restaurant se encuentra cerrado.');
      Timer(Duration(seconds: 3), () {
        Navigator.pushNamed(context, 'cliente/productos/lista');
      });
    }
  }
}
