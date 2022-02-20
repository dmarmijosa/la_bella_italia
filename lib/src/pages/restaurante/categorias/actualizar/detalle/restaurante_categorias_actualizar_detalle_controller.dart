import 'package:flutter/material.dart';
import 'package:la_bella_italia/src/models/category.dart';
import 'package:la_bella_italia/src/models/response_api.dart';
import 'package:la_bella_italia/src/models/user.dart';

import 'package:la_bella_italia/src/providers/category_provider.dart';
import 'package:la_bella_italia/src/utils/UtilsApp.dart';
import 'package:la_bella_italia/src/utils/my_snackbar.dart';
import 'package:la_bella_italia/src/utils/shared_pref.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RestauranteCategoriasActualizarDetalleController {
  BuildContext context;
  Function refresh;
  User user;
  Category categoria;

  SharedPref sharedPref = new SharedPref();

  TextEditingController nameController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();

  CategoryProvider _categoryProvider = new CategoryProvider();
  List<Category> categories = [];
  String idCategory;

  Future init(
      BuildContext context, Function refresh, Category categoria) async {
    this.context = context;
    this.refresh = refresh;
    UtilsApp utilsApp = new UtilsApp();
    if (await utilsApp.internetConnectivity() == false) {
      Navigator.pushNamed(context, 'desconectado');
    }

    this.categoria = categoria;
    nameController.text = categoria.name;
    descriptionController.text = categoria.description;

    user = User.fromJson(await sharedPref.read('user'));
    _categoryProvider.init(context, user);
    getCategorias();
    refresh();
  }

  void getCategorias() async {
    categories = await _categoryProvider.getAll();

    refresh();
  }

  void updateCategoria() async {
    String name = nameController.text;
    String description = descriptionController.text;

    if (name.isEmpty || description.isEmpty) {
      MyScnackbar.show(context, 'Debe ingresar todos los campos');
      return;
    }

    Category category = new Category(
      id: categoria.id,
      name: name,
      description: description,
    );
    ResponseApi responseApi = await _categoryProvider.update(category);
    Fluttertoast.showToast(msg: responseApi.message);

    //MyScnackbar.show(context, responseApi.message);
    if (responseApi.success) {
      nameController.text = '';
      descriptionController.text = '';
    }
    Navigator.pushNamed(context, 'restaurante/categorias/actualizar');
  }
}
