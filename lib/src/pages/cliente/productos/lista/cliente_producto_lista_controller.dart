import 'package:flutter/material.dart';
import 'package:la_bella_italia/src/models/categoria.dart';
import 'package:la_bella_italia/src/models/user.dart';
import 'package:la_bella_italia/src/providers/category_provider.dart';
import 'package:la_bella_italia/src/utils/shared_pref.dart';

class ClienteProductoListaController {
  BuildContext context;
  SharedPref _sharedPref = new SharedPref();
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  User user;
  Function refresh;
  List<Categoria> categorias = [];
  CategoryProvider _categoryProvider = new CategoryProvider();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user') ?? {});
    _categoryProvider.init(context, user);
    obtenerCategorias();
    refresh();
  }

  void obtenerCategorias() async {
    categorias = await _categoryProvider.getAll();
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

  void editarPerfil() {
    Navigator.pushNamed(context, 'cliente/actualizar');
  }
}
