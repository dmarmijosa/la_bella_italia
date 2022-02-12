import 'package:flutter/material.dart';
import 'package:la_bella_italia/src/models/categoria.dart';
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
  Categoria categoria;

  SharedPref sharedPref = new SharedPref();

  TextEditingController nombreController = new TextEditingController();
  TextEditingController descripcionController = new TextEditingController();

  CategoryProvider _categoryProvider = new CategoryProvider();
  List<Categoria> categorias = [];
  String idCategoria;

  Future init(
      BuildContext context, Function refresh, Categoria categoria) async {
    this.context = context;
    this.refresh = refresh;
    UtilsApp utilsApp = new UtilsApp();
    if (await utilsApp.internetConnectivity() == false) {
      Navigator.pushNamed(context, 'desconectado');
    }

    this.categoria = categoria;
    nombreController.text = categoria.name;
    descripcionController.text = categoria.description;

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
    String name = nombreController.text;
    String description = descripcionController.text;

    if (name.isEmpty || description.isEmpty) {
      MyScnackbar.show(context, 'Debe ingresar todos los campos');
      return;
    }

    Categoria category = new Categoria(
      id: categoria.id,
      name: name,
      description: description,
    );
    ResponseApi responseApi = await _categoryProvider.update(category);
    Fluttertoast.showToast(msg: responseApi.message);

    //MyScnackbar.show(context, responseApi.message);
    if (responseApi.success) {
      nombreController.text = '';
      descripcionController.text = '';
    }
    Navigator.pushNamed(context, 'restaurante/categorias/actualizar');
  }
}
