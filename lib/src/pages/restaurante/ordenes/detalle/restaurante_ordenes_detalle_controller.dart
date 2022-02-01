import 'dart:async';

import 'package:flutter/material.dart';
import 'package:la_bella_italia/src/models/orden.dart';
import 'package:la_bella_italia/src/models/response_api.dart';
import 'package:la_bella_italia/src/models/user.dart';
import 'package:la_bella_italia/src/providers/order_provider.dart';
import 'package:la_bella_italia/src/providers/user_provider.dart';
import 'package:la_bella_italia/src/utils/shared_pref.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class RestauranteOrdenesDetalleController {
  BuildContext context;
  Function refresh;

  SharedPref _sharedPref = new SharedPref();
  UserProvider _userProvider = new UserProvider();
  OrderProvider _orderProvider = new OrderProvider();

  double total = 0;

  User user;
  bool estadoRestaurante;
  String mensaje;
  Orden orden;
  List<User> users = [];
  String idDelivery;

  Future init(BuildContext context, Function refresh, Orden orden) async {
    this.context = context;
    this.refresh = refresh;
    this.orden = orden;
    user = User.fromJson(await _sharedPref.read('user'));
    _userProvider.init(context, sessionUser: user);
    _orderProvider.init(context, user);
    obtenerTotal();
    getUsers();
    refresh();
  }

  void updateOrden() async {
    if (idDelivery != null) {
      orden.idDelivery = idDelivery;
      ResponseApi responseApi =
          await _orderProvider.updateToTheDispatched(orden);

      if (responseApi.success) {
        Fluttertoast.showToast(msg: responseApi.message);
        Navigator.pop(context, true);
        refresh();
      }
    } else {
      Fluttertoast.showToast(msg: 'Selecciona el repartidor');
      refresh();
    }
  }

  void getUsers() async {
    users = await _userProvider.getByDelivey();
    refresh();
  }

  void obtenerTotal() {
    total = 0;
    orden.products.forEach((producto) {
      total = total + (producto.price * producto.quantity);
    });

    refresh();
  }

  void llamarCliente() {
    print('${orden?.client?.phone}');
    launch("tel:${orden?.client?.phone}");
  }
}
