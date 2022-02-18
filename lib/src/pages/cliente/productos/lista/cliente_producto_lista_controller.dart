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

  void mostrarSheet(Product producto) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => ClienteProductoDetallePage(
        producto: producto,
      ),
    );
  }

  void irAMisPedidos() {
    Navigator.pushNamed(context, 'cliente/ordenes/lista');
  }

  void irACrearOrdenPage() {
    Navigator.pushNamed(context, 'cliente/ordenes/crear');
  }

  void irAEliminarDirecciones() {
    Navigator.pushNamed(context, 'cliente/direcciones/eliminar');
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
