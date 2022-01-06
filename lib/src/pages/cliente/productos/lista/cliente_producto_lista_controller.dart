import 'package:flutter/material.dart';
import 'package:la_bella_italia/src/utils/shared_pref.dart';

class ClienteProductoListaController {
  BuildContext context;
  SharedPref _sharedPref = new SharedPref();
  Future init(BuildContext context) async {
    this.context = context;
  }

  void logout() {
    _sharedPref.logout(context);
  }
}
