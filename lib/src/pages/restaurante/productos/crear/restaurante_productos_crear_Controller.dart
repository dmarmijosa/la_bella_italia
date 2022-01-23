import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:la_bella_italia/src/models/categoria.dart';
import 'package:la_bella_italia/src/models/producto.dart';
import 'package:la_bella_italia/src/models/response_api.dart';

import 'package:la_bella_italia/src/models/user.dart';
import 'package:la_bella_italia/src/providers/category_provider.dart';
import 'package:la_bella_italia/src/providers/product_provider.dart';
import 'package:la_bella_italia/src/utils/my_snackbar.dart';
import 'package:la_bella_italia/src/utils/shared_pref.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class RestauranteProductoCrearController {
  BuildContext context;
  Function refresh;

  TextEditingController nombreController = new TextEditingController();
  TextEditingController descripcionController = new TextEditingController();
  MoneyMaskedTextController precioController = new MoneyMaskedTextController();

  CategoryProvider _categoriesProvider = new CategoryProvider();
  ProductoProvider _productsProvider = new ProductoProvider();

  User user;
  SharedPref sharedPref = new SharedPref();

  List<Categoria> categorias = [];
  String idCategory;

  PickedFile pickedFile;
  File imageFile1;
  File imageFile2;
  File imageFile3;

  ProgressDialog _progressDialog;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    _progressDialog = new ProgressDialog(context: context);
    user = User.fromJson(await sharedPref.read('user'));
    _categoriesProvider.init(context, user);
    _productsProvider.init(context, user);
    getCategories();
  }

  void getCategories() async {
    categorias = await _categoriesProvider.getAll();
    refresh();
  }

  void createProduct() async {
    String name = nombreController.text;
    String description = descripcionController.text;
    double price = precioController.numberValue;

    if (name.isEmpty || description.isEmpty || price == 0) {
      MyScnackbar.show(context, 'Debe ingresar todos los campos');
      return;
    }

    if (imageFile1 == null || imageFile2 == null || imageFile3 == null) {
      MyScnackbar.show(context, 'Selecciona las tres imagenes');
      return;
    }

    if (idCategory == null) {
      MyScnackbar.show(context, 'Selecciona la categoria del producto');
      return;
    }

    Producto product = new Producto(
        name: name,
        description: description,
        price: price,
        idCategory: int.parse(idCategory));

    List<File> images = [];
    images.add(imageFile1);
    images.add(imageFile2);
    images.add(imageFile3);

    _progressDialog.show(max: 100, msg: 'Espere un momento');
    Stream stream = await _productsProvider.create(product, images);
    stream.listen((res) {
      _progressDialog.close();

      ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
      MyScnackbar.show(context, responseApi.message);

      if (responseApi.success) {
        resetValues();
      }
    });

    print('Formulario Producto: ${product.toJson()}');
  }

  void resetValues() {
    nombreController.text = '';
    descripcionController.text = '';
    precioController.text = '0.0';
    imageFile1 = null;
    imageFile2 = null;
    imageFile3 = null;
    idCategory = null;
    refresh();
  }

  Future selectImage(ImageSource imageSource, int numberFile) async {
    pickedFile = await ImagePicker().getImage(source: imageSource);
    if (pickedFile != null) {
      if (numberFile == 1) {
        imageFile1 = File(pickedFile.path);
      } else if (numberFile == 2) {
        imageFile2 = File(pickedFile.path);
      } else if (numberFile == 3) {
        imageFile3 = File(pickedFile.path);
      }
    }
    Navigator.pop(context);
    refresh();
  }

  void showAlertDialog(int numberFile) {
    Widget galleryButton = ElevatedButton(
        onPressed: () {
          selectImage(ImageSource.gallery, numberFile);
        },
        child: Text('GALERIA'));

    Widget cameraButton = ElevatedButton(
        onPressed: () {
          selectImage(ImageSource.camera, numberFile);
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
