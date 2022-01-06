import 'dart:io';

import 'package:flutter/material.dart';
import 'package:la_bella_italia/src/models/response_api.dart';
import 'package:la_bella_italia/src/models/user.dart';
import 'package:la_bella_italia/src/providers/user_provider.dart';
import 'package:la_bella_italia/src/utils/my_snackbar.dart';
import 'package:la_bella_italia/src/utils/shared_pref.dart';

class LoginController {
  BuildContext context;

  UserProvider userProvider = new UserProvider();

  TextEditingController correoController = new TextEditingController();
  TextEditingController passController = new TextEditingController();

  SharedPref _sharedPref = new SharedPref();

  Future init(BuildContext context) async {
    this.context = context;
    await userProvider.init(context);

    User user = User.fromJson(await _sharedPref.read('user') ?? {});

    if (user?.sessionToken != null) {
      if (user.roles.length > 1) {
        Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, user.roles[0].route, (Route<dynamic> route) => false);
      }
    }
    /*try {
      final result = await InternetAddress.lookup('12www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {}
    } catch (_) {
      MyScnackbar.testConnection(context, "SIN CONEXION AL SERVIDOR");
    }*/
  }

  void irA() {
    Navigator.pushNamed(context, 'registro');
  }

  void login() async {
    String correo = correoController.text.trim();
    String password = passController.text.trim();

    ResponseApi responseApi = await userProvider.login(correo, password);
    if (responseApi.success) {
      User user = User.fromJson(responseApi.data);
      _sharedPref.save('user', user.toJson());

      if (user.roles.length > 1) {
        Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, user.roles[0].route, (route) => false);
      }
    } else {
      MyScnackbar.show(context, responseApi.message);
    }

    MyScnackbar.show(context, responseApi.message);
    if (correo.isEmpty || password.isEmpty) {
      MyScnackbar.show(context, "Correo y contraseña son requeridos.");
    }

    //print("Respuesta api rest ${responseApi.toJson()}");
  }
}
