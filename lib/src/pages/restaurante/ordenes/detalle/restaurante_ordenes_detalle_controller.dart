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
  String estado;

  User user;
  bool estadoRestaurante;
  String mensaje;
  Orden orden;
  List<User> users = [];
  String idDelivery;
  List<String> status = ['DESPACHADA', 'EN CAMINO', 'ENTREGADA', 'CANCELADA'];

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

  void updateToTheDispatchedBack() async {
    ResponseApi responseApi =
        await _orderProvider.updateToTheDispatchedBack(orden);
    if (responseApi.success) {
      Fluttertoast.showToast(msg: responseApi.message);
      Navigator.pop(context, true);
      refresh();
    }
  }

  void updateOrdenToOnWay() async {
    orden.idDelivery = idDelivery;
    ResponseApi responseApi = await _orderProvider.updateToOntheWay(orden);

    if (responseApi.success) {
      Fluttertoast.showToast(msg: responseApi.message);
      Navigator.pop(context, true);
      refresh();
    }
  }

  void updateOrdenToDelivered() async {
    orden.idDelivery = idDelivery;
    ResponseApi responseApi = await _orderProvider.updateToDelivered(orden);

    if (responseApi.success) {
      Fluttertoast.showToast(msg: responseApi.message);
      Navigator.pop(context, true);
      refresh();
    }
  }

  void updateOrdenToCancel() async {
    orden.idDelivery = idDelivery;
    ResponseApi responseApi = await _orderProvider.updateToCancel(orden);

    if (responseApi.success) {
      Fluttertoast.showToast(msg: responseApi.message);
      Navigator.pop(context, true);
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

  void llamarTelefono(String telefono) {
    launch("tel:$telefono");
  }
}
