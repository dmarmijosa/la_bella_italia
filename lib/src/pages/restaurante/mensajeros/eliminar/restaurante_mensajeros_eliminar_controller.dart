import 'package:flutter/material.dart';
import 'package:la_bella_italia/src/models/response_api.dart';
import 'package:la_bella_italia/src/models/user.dart';

import 'package:la_bella_italia/src/providers/user_provider.dart';
import 'package:la_bella_italia/src/utils/shared_pref.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:la_bella_italia/src/utils/utilsApp.dart';

class RestauranteMensajerosEliminarController {
  BuildContext context;
  Function refresh;
  User user;

  SharedPref _sharedPref = new SharedPref();
  UserProvider _userProvider = new UserProvider();
  List<User> deliverys = [];
  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    UtilsApp utilsApp = new UtilsApp();
    if (await utilsApp.internetConnectivity() == false) {
      Navigator.pushNamed(context, 'desconectado');
    }
    user = User.fromJson(await _sharedPref.read('user') ?? {});
    _userProvider.init(context, sessionUser: user);

    deliverys = await _userProvider.getByDelivey();

    refresh();
  }

  void confirmarEliminar(String id) async {
    ResponseApi responseApi = await _userProvider.deleteDelivery(id);
    Fluttertoast.showToast(msg: responseApi.message);
    await _userProvider.logout(id);
    Navigator.pop(context);
    refresh();
  }
}
