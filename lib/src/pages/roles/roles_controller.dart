import 'package:flutter/material.dart';

import 'package:la_bella_italia/src/models/user.dart';
import 'package:la_bella_italia/src/utils/UtilsApp.dart';
import 'package:la_bella_italia/src/utils/shared_pref.dart';

class RolesController {
  BuildContext context;
  Function refresh;

  User user;
  SharedPref sharedPref = new SharedPref();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    user = User.fromJson(await sharedPref.read('user'));
    refresh();
    UtilsApp utilsApp = new UtilsApp();
    if (await utilsApp.internetConnectivity() == false) {
      Navigator.pushNamed(context, 'desconectado');
    }
  }

  void irAPaginaRol(String route) {
    Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
  }
}
