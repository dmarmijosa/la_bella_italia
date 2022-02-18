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
  Timer tiempoDeEscritura;
  String productoBuscar = '';
  List<Category> categorias = [];

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
    obtenerCategorias();
    refresh();
  }

  void changeText(String text) {
    Duration duracion = Duration(milliseconds: 800);
    if (tiempoDeEscritura != null) {
      tiempoDeEscritura.cancel();
      refresh();
    }

    tiempoDeEscritura = new Timer(duracion, () {
      productoBuscar = text;

      refresh();
      print('Texto Completo $productoBuscar');
    });
  }

  void confirmarEliminar(Product producto) async {
    ResponseApi responseApi =
        await _productoProvider.deleteProduct(producto.id);
    Fluttertoast.showToast(msg: responseApi.message);
    refresh();
  }

  // ignore: non_constant_identifier_names
  Future<List<Product>> obtenerProductos(
      String idCategory, String productName) async {
    if (productoBuscar.isEmpty) {
      return await _productoProvider.getByCategory(idCategory);
    } else {
      return await _productoProvider.getByCategoryAndProductName(
          idCategory, productName);
    }
  }

  void obtenerCategorias() async {
    categorias = await _categoryProvider.getAll();
    refresh();
  }

  void regresar() {
    Navigator.pop(context);
  }
}
