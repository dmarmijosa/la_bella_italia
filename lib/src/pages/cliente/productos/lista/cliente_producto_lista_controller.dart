import 'package:flutter/material.dart';
import 'package:la_bella_italia/src/models/categoria.dart';
import 'package:la_bella_italia/src/models/producto.dart';
import 'package:la_bella_italia/src/models/user.dart';
import 'package:la_bella_italia/src/pages/cliente/productos/detalle/cliente_producto_detalle_page.dart';
import 'package:la_bella_italia/src/providers/category_provider.dart';
import 'package:la_bella_italia/src/providers/product_provider.dart';
import 'package:la_bella_italia/src/utils/shared_pref.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ClienteProductoListaController {
  BuildContext context;
  SharedPref _sharedPref = new SharedPref();
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  User user;
  Function refresh;
  List<Categoria> categorias = [];
  CategoryProvider _categoryProvider = new CategoryProvider();
  ProductoProvider _productoProvider = new ProductoProvider();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user') ?? {});
    _categoryProvider.init(context, user);
    _productoProvider.init(context, user);
    obtenerCategorias();
    refresh();
  }

  void mostrarSheet(Producto producto) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => ClienteProductoDetallePage(
        producto: producto,
      ),
    );
  }

  void irACrearOrdenPage() {
    Navigator.pushNamed(context, 'cliente/ordenes/crear');
  }

  // ignore: non_constant_identifier_names
  Future<List<Producto>> obtenerProductos(String id_category) async {
    return await _productoProvider.getByCategory(id_category);
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
