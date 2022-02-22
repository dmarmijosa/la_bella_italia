import 'package:flutter/material.dart';
import 'package:la_bella_italia/src/models/order.dart';

import 'package:la_bella_italia/src/models/user.dart';
import 'package:la_bella_italia/src/pages/delivery/ordenes/detalle/delivery_ordenes_detalle_page.dart';
import 'package:la_bella_italia/src/providers/order_provider.dart';
import 'package:la_bella_italia/src/providers/user_provider.dart';
import 'package:la_bella_italia/src/utils/UtilsApp.dart';
import 'package:la_bella_italia/src/utils/shared_pref.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class DeliveryOrdenesListaController {
  BuildContext context;
  SharedPref _sharedPref = new SharedPref();
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  User user;

  Function refresh;
  // ignore: unused_field
  UserProvider _userProvider = new UserProvider();
  OrderProvider _orderProvider = new OrderProvider();
  bool state = false;

  List<String> status = ['DESPACHADA', 'EN CAMINO', 'ENTREGADA'];

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    //this.abiertoOCerrado = abiertoOCerrado;

    user = User.fromJson(await _sharedPref.read('user') ?? {});
    _orderProvider.init(context, user);

    UtilsApp utilsApp = new UtilsApp();
    if (await utilsApp.internetConnectivity() == false) {
      Navigator.pushNamed(context, 'desconectado');
    }
    refresh();
  }

  // ignore: missing_return
  Future<List<Order>> getOrders(String status) async {
    try {
      return await _orderProvider.getByDeliveryAndStatus(user.id, status);
    } catch (e) {
      print(e);
    }
  }

  void openSheet(Order orden) async {
    try {
      state = await showMaterialModalBottomSheet(
        context: context,
        builder: (context) => DeliveryOrdenesDetallePage(
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

  void logOut() {
    _sharedPref.logout(context, user.id);
  }

  void openDrawer() {
    key.currentState.openDrawer();
  }

  void changeRol() {
    Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
  }
}
