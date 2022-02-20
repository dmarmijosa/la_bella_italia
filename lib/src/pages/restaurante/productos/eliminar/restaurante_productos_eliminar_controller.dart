import 'dart:async';

import 'package:flutter/material.dart';
import 'package:la_bella_italia/src/models/category.dart';
import 'package:la_bella_italia/src/models/product.dart';
import 'package:la_bella_italia/src/models/response_api.dart';
import 'package:la_bella_italia/src/models/user.dart';

import 'package:la_bella_italia/src/providers/category_provider.dart';
import 'package:la_bella_italia/src/providers/product_provider.dart';
import 'package:la_bella_italia/src/utils/UtilsApp.dart';

import 'package:la_bella_italia/src/utils/shared_pref.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RestauranteProductosEliminarListaController {
  BuildContext context;
  SharedPref _sharedPref = new SharedPref();
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  User user;
  Function refresh;
  Timer timeWrite;
  String productSearch = '';
  List<Category> categories = [];

  CategoryProvider _categoryProvider = new CategoryProvider();
  ProductProvider _productoProvider = new ProductProvider();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    user = User.fromJson(await _sharedPref.read('user') ?? {});
    _categoryProvider.init(context, user);
    _productoProvider.init(context, user);
    UtilsApp utilsApp = new UtilsApp();
    if (await utilsApp.internetConnectivity() == false) {
      Navigator.pushNamed(context, 'desconectado');
    }
    getCategories();
    refresh();
  }

  void textSearch(String text) {
    Duration duracion = Duration(milliseconds: 800);
    if (timeWrite != null) {
      timeWrite.cancel();
      refresh();
    }

    timeWrite = new Timer(duracion, () {
      productSearch = text;

      refresh();
      print('Texto Completo $productSearch');
    });
  }

  void confirmDelete(Product producto) async {
    ResponseApi responseApi =
        await _productoProvider.deleteProduct(producto.id);
    Fluttertoast.showToast(msg: responseApi.message);
    refresh();
  }

  // ignore: non_constant_identifier_names
  Future<List<Product>> getProduct(
      String idCategory, String productName) async {
    if (productSearch.isEmpty) {
      return await _productoProvider.getByCategory(idCategory);
    } else {
      return await _productoProvider.getByCategoryAndProductName(
          idCategory, productName);
    }
  }

  void getCategories() async {
    categories = await _categoryProvider.getAll();
    refresh();
  }

  void goToback() {
    Navigator.pop(context);
  }
}
