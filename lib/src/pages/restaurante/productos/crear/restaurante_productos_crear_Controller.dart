import 'dart:io';

import 'package:flutter/material.dart';
import 'package:la_bella_italia/src/models/categoria.dart';

import 'package:la_bella_italia/src/models/user.dart';
import 'package:la_bella_italia/src/providers/category_provider.dart';
import 'package:la_bella_italia/src/utils/my_snackbar.dart';
import 'package:la_bella_italia/src/utils/shared_pref.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class RestauranteProductoCrearController {
  PickedFile pickedFile;
  File imageFile;
  Function refresh;
  ProgressDialog _progressDialog;
  BuildContext context;

  TextEditingController nombreController = new TextEditingController();
  TextEditingController descripcionController = new TextEditingController();
  MoneyMaskedTextController precioController = new MoneyMaskedTextController();
  List<Categoria> categorias = [];
  String idCategoria;

  CategoryProvider _categoryProvider = new CategoryProvider();
  User user;
  SharedPref sharedPref = new SharedPref();

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

  void crearProducto() async {
    String name = nombreController.text;
    String description = descripcionController.text;

    if (name.isEmpty || description.isEmpty) {
      MyScnackbar.show(context, 'Debe ingresar todos los campos');
      return;
    }
  }

  Future selectImage(ImageSource imageSource) async {
    pickedFile = await ImagePicker().getImage(source: imageSource);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
    }
    Navigator.pop(context);
    refresh();
  }

  void showAlertDialog() {
    Widget galleryButton = ElevatedButton(
        onPressed: () {
          selectImage(ImageSource.gallery);
        },
        child: Text('GALERIA'));

    Widget cameraButton = ElevatedButton(
        onPressed: () {
          selectImage(ImageSource.camera);
        },
        child: Text('CAMARA'));

    AlertDialog alertDialog = AlertDialog(
      title: Text('Selecciona tu imagen'),
      actions: [galleryButton, cameraButton],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }
}
