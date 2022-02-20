import 'package:flutter/material.dart';
import 'package:la_bella_italia/src/models/category.dart';
import 'package:la_bella_italia/src/models/response_api.dart';
import 'package:la_bella_italia/src/models/user.dart';

import 'package:la_bella_italia/src/providers/category_provider.dart';
import 'package:la_bella_italia/src/utils/UtilsApp.dart';
import 'package:la_bella_italia/src/utils/my_snackbar.dart';
import 'package:la_bella_italia/src/utils/shared_pref.dart';

class RestauranteCategoriasCrearController {
  BuildContext context;
  Function refresh;
  User user;

  SharedPref sharedPref = new SharedPref();

  TextEditingController nameController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();

  CategoryProvider _categoryProvider = new CategoryProvider();
  List<Category> categorias = [];
  String idCategoria;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    UtilsApp utilsApp = new UtilsApp();
    if (await utilsApp.internetConnectivity() == false) {
      Navigator.pushNamed(context, 'desconectado');
    }
    user = User.fromJson(await sharedPref.read('user'));
    _categoryProvider.init(context, user);
    getCategorias();
    refresh();
  }

  void getCategorias() async {
    categorias = await _categoryProvider.getAll();

    refresh();
  }

  void crearCategoria() async {
    String name = nameController.text;
    String description = descriptionController.text;

    if (name.isEmpty || description.isEmpty) {
      MyScnackbar.show(context, 'Debe ingresar todos los campos');
      return;
    }

    Category category = new Category(name: name, description: description);
    ResponseApi responseApi = await _categoryProvider.create(category);
    MyScnackbar.show(context, responseApi.message);
    if (responseApi.success) {
      nameController.text = '';
      descriptionController.text = '';
    }
  }
}
