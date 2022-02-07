import 'package:flutter/material.dart';
import 'package:la_bella_italia/src/models/orden.dart';
import 'package:la_bella_italia/src/models/response_api.dart';
import 'package:la_bella_italia/src/models/user.dart';
import 'package:la_bella_italia/src/pages/cliente/ordenes/detalle/cliente_ordenes_detalle_page.dart';

import 'package:la_bella_italia/src/providers/order_provider.dart';
import 'package:la_bella_italia/src/providers/user_provider.dart';
import 'package:la_bella_italia/src/utils/shared_pref.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ClienteOrdenesListaController {
  BuildContext context;
  SharedPref _sharedPref = new SharedPref();
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  User user;

  Function refresh;
  UserProvider _userProvider = new UserProvider();
  OrderProvider _orderProvider = new OrderProvider();
  bool estado = false;

  List<String> status = ['CREADA', 'DESPACHADA', 'EN CAMINO', 'ENTREGADA'];

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    //this.abiertoOCerrado = abiertoOCerrado;

    user = User.fromJson(await _sharedPref.read('user') ?? {});
    _orderProvider.init(context, user);

    refresh();

    //print(estado);
  }

  // ignore: missing_return
  Future<List<Orden>> obtenerOrdenes(String status) async {
    try {
      return await _orderProvider.getByClientAndStatus(user.id, status);
    } catch (e) {
      print(e);
    }
  }

  void abrirSheet(Orden orden) async {
    try {
      estado = await showMaterialModalBottomSheet(
        context: context,
        builder: (context) => ClienteOrdenesDetallePage(
          orden: orden,
        ),
      );
      refresh();

      if (estado) {
        refresh();
      }
    } catch (e) {
      print(e);
    }
  }

  void actualizarEstado() async {
    ResponseApi responseApi = await _userProvider.setValorRestaurant(user.id);
    Fluttertoast.showToast(msg: responseApi.message);
    print(responseApi.message);
  }

  void logout() {
    _sharedPref.logout(context, user.id);
  }

  void openDrawer() {
    key.currentState.openDrawer();
  }

  void irACrearCategoria() {
    Navigator.pushNamed(context, 'restaurante/categorias/crear');
  }

  void irACrearProducto() {
    Navigator.pushNamed(context, 'restaurante/producto/crear');
  }

  void cambiarRol() {
    Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
  }
}
