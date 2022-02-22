import 'package:flutter/material.dart';
import 'package:la_bella_italia/src/models/order.dart';

import 'package:la_bella_italia/src/models/user.dart';
import 'package:la_bella_italia/src/pages/cliente/ordenes/detalle/cliente_ordenes_detalle_page.dart';

import 'package:la_bella_italia/src/providers/order_provider.dart';

import 'package:la_bella_italia/src/utils/UtilsApp.dart';
import 'package:la_bella_italia/src/utils/shared_pref.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ClienteOrdenesListaController {
  BuildContext context;
  SharedPref _sharedPref = new SharedPref();
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  User user;

  Function refresh;
  OrderProvider _orderProvider = new OrderProvider();
  bool state = false;

  List<String> status = ['CREADA', 'DESPACHADA', 'EN CAMINO', 'ENTREGADA'];

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    //this.abiertoOCerrado = abiertoOCerrado;

    user = User.fromJson(await _sharedPref.read('user') ?? {});
    _orderProvider.init(context, user);

    refresh();

    UtilsApp utilsApp = new UtilsApp();
    if (await utilsApp.internetConnectivity() == false) {
      Navigator.pushNamed(context, 'desconectado');
    }
  }

  // ignore: missing_return
  Future<List<Order>> getOrders(String status) async {
    try {
      return await _orderProvider.getByClientAndStatus(user.id, status);
    } catch (e) {
      print(e);
    }
  }

  void openSheet(Order orden) async {
    try {
      state = await showMaterialModalBottomSheet(
        context: context,
        builder: (context) => ClienteOrdenesDetallePage(
          orden: orden,
        ),
      );
      refresh();

      if (state) {
        refresh();
      }
    } catch (e) {
      print(e);
    }
  }

  void openDrawer() {
    key.currentState.openDrawer();
  }
}
