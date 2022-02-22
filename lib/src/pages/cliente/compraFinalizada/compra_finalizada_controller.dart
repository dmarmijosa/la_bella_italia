import 'package:flutter/material.dart';
import 'package:la_bella_italia/src/models/user.dart';
import 'package:la_bella_italia/src/providers/pushNotification_provider.dart';
import 'package:la_bella_italia/src/providers/user_provider.dart';
import 'package:la_bella_italia/src/utils/UtilsApp.dart';
import 'package:la_bella_italia/src/utils/shared_pref.dart';

class CompraFinalizadaController {
  BuildContext context;
  Function refresh;
  List<String> tokens = [];
  User user;
  PushNotificationProvider pushNotificationProvider =
      new PushNotificationProvider();
  UserProvider _userProvider = new UserProvider();
  SharedPref _sharedPref = new SharedPref();
  void init(context, refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user'));
    _userProvider.init(context, sessionUser: user);
    tokens = await _userProvider.getAdminsNotificationTokens();

    UtilsApp utilsApp = new UtilsApp();
    if (await utilsApp.internetConnectivity() == false) {
      Navigator.pushNamed(context, 'desconectado');
    }

    refresh();
  }

  void checkout() {
    Navigator.pushNamedAndRemoveUntil(
        context, 'cliente/productos/lista', (route) => false);
    refresh();
  }
}
