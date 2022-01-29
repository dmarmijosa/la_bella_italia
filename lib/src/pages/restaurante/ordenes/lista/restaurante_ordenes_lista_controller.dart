import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:la_bella_italia/src/models/response_api.dart';
import 'package:la_bella_italia/src/models/user.dart';
import 'package:la_bella_italia/src/providers/user_provider.dart';
import 'package:la_bella_italia/src/utils/shared_pref.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RestauranteOrdenesListaController {
  BuildContext context;
  SharedPref _sharedPref = new SharedPref();
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  User user;

  Function refresh;
  UserProvider _userProvider = new UserProvider();
  bool estado;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    this.estado = estado;

    user = User.fromJson(await _sharedPref.read('user') ?? {});
    _userProvider.init(context, sessionUser: user);
    estado = await _userProvider.restaurantIsAvaiable();

    refresh();

    //print(estado);
  }

  void actualizarEstado() async {
    print('sadkbakajsbgkjagbks');
    print(user.id);
    ResponseApi responseApi = await _userProvider.setValorRestaurant(user.id);
    Fluttertoast.showToast(msg: responseApi.message);
    print(responseApi.message);
  }

  void logout() {
    _sharedPref.logout(context, user.id);
  }

  void openDrawer() {
    key.currentState.openDrawer();
  }

  void irACrearCategoria() {
    Navigator.pushNamed(context, 'restaurante/categorias/crear');
  }

  void irACrearProducto() {
    Navigator.pushNamed(context, 'restaurante/producto/crear');
  }

  void cambiarRol() {
    Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
  }
}
