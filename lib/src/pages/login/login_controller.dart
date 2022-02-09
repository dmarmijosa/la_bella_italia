import 'dart:io';

import 'package:flutter/material.dart';
import 'package:la_bella_italia/src/models/response_api.dart';
import 'package:la_bella_italia/src/models/user.dart';
import 'package:la_bella_italia/src/providers/pushNotification_provider.dart';
import 'package:la_bella_italia/src/providers/user_provider.dart';
import 'package:la_bella_italia/src/utils/UtilsApp.dart';
import 'package:la_bella_italia/src/utils/my_snackbar.dart';
import 'package:la_bella_italia/src/utils/shared_pref.dart';

class LoginController {
  BuildContext context;
  bool bandera;

  UserProvider userProvider = new UserProvider();

  PushNotificationProvider pushNotificationProvider =
      new PushNotificationProvider();

  TextEditingController correoController = new TextEditingController();
  TextEditingController passController = new TextEditingController();

  SharedPref _sharedPref = new SharedPref();

  Future init(BuildContext context) async {
    this.context = context;
    await userProvider.init(context);
    bandera = await internetConnectivity();

    User user = User.fromJson(await _sharedPref.read('user') ?? {});

    if (user?.sessionToken != null) {
      pushNotificationProvider.saveToken(user, context);

      if (user.roles.length > 1) {
        UtilsApp utilsApp = new UtilsApp();
        if (await utilsApp.internetConnectivity() == false) {
          Navigator.pushNamed(context, 'desconectado');
        } else {
          Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
        }
      } else {
        UtilsApp utilsApp = new UtilsApp();
        if (await utilsApp.internetConnectivity() == false) {
          Navigator.pushNamed(context, 'desconectado');
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, user.roles[0].route, (Route<dynamic> route) => false);
        }
      }
    }
  }

  Future<bool> internetConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }

  void irA() {
    Navigator.pushNamed(context, 'registro');
  }

  void recuperar() {
    Navigator.pushNamed(context, 'recuperar');
  }

  void login() async {
    String correo = correoController.text.trim();
    String password = passController.text.trim();

    ResponseApi responseApi = await userProvider.login(correo, password);
    if (responseApi.success) {
      User user = User.fromJson(responseApi.data);
      _sharedPref.save('user', user.toJson());
      pushNotificationProvider.saveToken(user, context);
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
  }
}
