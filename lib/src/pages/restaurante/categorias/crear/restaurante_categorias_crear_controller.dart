import 'package:flutter/material.dart';
import 'package:la_bella_italia/src/models/categoria.dart';
import 'package:la_bella_italia/src/models/response_api.dart';
import 'package:la_bella_italia/src/models/user.dart';

import 'package:la_bella_italia/src/providers/category_provider.dart';
import 'package:la_bella_italia/src/utils/my_snackbar.dart';
import 'package:la_bella_italia/src/utils/shared_pref.dart';

class RestauranteCategoriasCrearController {
  BuildContext context;
  Function refresh;
  User user;

  SharedPref sharedPref = new SharedPref();

  TextEditingController nombreController = new TextEditingController();
  TextEditingController descripcionController = new TextEditingController();

  CategoryProvider _categoryProvider = new CategoryProvider();
  List<Categoria> categorias = [];
  String idCategoria;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await sharedPref.read('user'));
    _categoryProvider.init(context, user);
    getCategorias();
  }

  void getCategorias() async {
    categorias = await _categoryProvider.getAll();

    refresh();
  }

  void crearCategoria() async {
    String name = nombreController.text;
    String description = descripcionController.text;

    if (name.isEmpty || description.isEmpty) {
      MyScnackbar.show(context, 'Debe ingresar todos los campos');
      return;
    }

    Categoria category = new Categoria(name: name, description: description);
    ResponseApi responseApi = await _categoryProvider.create(category);
    MyScnackbar.show(context, responseApi.message);
    if (responseApi.success) {
      nombreController.text = '';
      descripcionController.text = '';
    }
  }
}
