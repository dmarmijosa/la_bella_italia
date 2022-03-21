import 'dart:async';

import 'package:flutter/material.dart';
import 'package:la_bella_italia/src/models/category.dart';
import 'package:la_bella_italia/src/models/product.dart';
import 'package:la_bella_italia/src/models/user.dart';
import 'package:la_bella_italia/src/pages/cliente/productos/detalle/cliente_producto_detalle_page.dart';
import 'package:la_bella_italia/src/providers/category_provider.dart';
import 'package:la_bella_italia/src/providers/product_provider.dart';
import 'package:la_bella_italia/src/utils/UtilsApp.dart';

import 'package:la_bella_italia/src/utils/shared_pref.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ClienteProductoListaController {
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

  void viewSheet(Product producto) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => ClienteProductoDetallePage(
        product: producto,
      ),
    );
  }

  void goToMyOrders() {
    Navigator.pushNamed(context, 'cliente/ordenes/lista');
  }

  void goToCreateOrder() {
    Navigator.pushNamed(context, 'cliente/ordenes/crear');
  }

  void goToDeleteAddress() {
    Navigator.pushNamed(context, 'cliente/direcciones/eliminar');
  }

  // ignore: non_constant_identifier_names
  Future<List<Product>> getProducts(
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

  void logOut() {
    _sharedPref.logout(context, user.id);
  }

  void openDrawer() {
    key.currentState.openDrawer();
  }

  void changeRol() {
    Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
  }

  void editProfile() {
    Navigator.pushNamed(context, 'cliente/actualizar');
  }
}
