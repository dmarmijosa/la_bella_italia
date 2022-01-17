import 'package:flutter/material.dart';
import 'package:la_bella_italia/src/models/user.dart';
import 'package:la_bella_italia/src/utils/shared_pref.dart';

class RestauranteOrdenesListaController {
  BuildContext context;
  SharedPref _sharedPref = new SharedPref();
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  User user;
  Function refresh;
  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user') ?? {});
    refresh();
  }

  void logout() {
    _sharedPref.logout(context, user.id);
  }

  void openDrawer() {
    key.currentState.openDrawer();
  }

  void cambiarROl() {
    Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
  }
}
