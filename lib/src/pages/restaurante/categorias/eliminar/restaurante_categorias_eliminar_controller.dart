import 'package:flutter/material.dart';
import 'package:la_bella_italia/src/models/response_api.dart';
import 'package:la_bella_italia/src/models/user.dart';
import 'package:la_bella_italia/src/models/category.dart';

import 'package:la_bella_italia/src/providers/category_provider.dart';
import 'package:la_bella_italia/src/utils/shared_pref.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:la_bella_italia/src/utils/utilsApp.dart';

class ResaturanteCategoriasEliminarController {
  BuildContext context;
  Function refresh;
  User user;
  SharedPref _sharedPref = new SharedPref();
  CategoryProvider _categoryProvider = new CategoryProvider();
  List<Category> categorias = [];

  Future init(BuildContext context, refresh) async {
    this.context = context;
    this.refresh = refresh;
    UtilsApp utilsApp = new UtilsApp();
    if (await utilsApp.internetConnectivity() == false) {
      Navigator.pushNamed(context, 'desconectado');
    }
    user = User.fromJson(await _sharedPref.read('user') ?? {});
    _categoryProvider.init(context, user);
    categorias = await _categoryProvider.getAll();
    refresh();
  }

  void confirmarEliminar(String id) async {
    ResponseApi responseApi = await _categoryProvider.delete(id);
    Fluttertoast.showToast(msg: responseApi.message);
    Navigator.pop(context);
    refresh();
  }
}
