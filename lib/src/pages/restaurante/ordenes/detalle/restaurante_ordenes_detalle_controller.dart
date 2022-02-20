import 'dart:async';

import 'package:flutter/material.dart';
import 'package:la_bella_italia/src/models/order.dart';
import 'package:la_bella_italia/src/models/response_api.dart';
import 'package:la_bella_italia/src/models/user.dart';
import 'package:la_bella_italia/src/providers/order_provider.dart';
import 'package:la_bella_italia/src/providers/pushNotification_provider.dart';
import 'package:la_bella_italia/src/providers/user_provider.dart';
import 'package:la_bella_italia/src/utils/UtilsApp.dart';
import 'package:la_bella_italia/src/utils/shared_pref.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class RestauranteOrdenesDetalleController {
  BuildContext context;
  Function refresh;

  SharedPref _sharedPref = new SharedPref();
  UserProvider _userProvider = new UserProvider();
  OrderProvider _orderProvider = new OrderProvider();

  double total = 0;
  String state;

  User user;
  bool stateRestaurant;
  String menssage;
  Order order;
  List<User> users = [];
  String idDelivery;
  List<String> status = ['DESPACHADA', 'EN CAMINO', 'ENTREGADA', 'CANCELADA'];
  PushNotificationProvider pushNotificationProvider =
      new PushNotificationProvider();
  Future init(BuildContext context, Function refresh, Order order) async {
    this.context = context;
    this.refresh = refresh;
    this.order = order;
    UtilsApp utilsApp = new UtilsApp();
    if (await utilsApp.internetConnectivity() == false) {
      Navigator.pushNamed(context, 'desconectado');
    }
    user = User.fromJson(await _sharedPref.read('user'));
    _userProvider.init(context, sessionUser: user);
    _orderProvider.init(context, user);
    getTotal();
    getUsers();
    refresh();
  }

  void enviarNotificacion(String tokenDelivery) {
    Map<String, dynamic> data = {'click_action': 'FLUTTER_NOTIFICATION_CLICK'};

    pushNotificationProvider.sendMessage(
      tokenDelivery,
      data,
      'PEDIDO ASIGNADO',
      'Te han asignado un pedido',
    );
  }

  void updateOrder() async {
    if (idDelivery != null) {
      order.idDelivery = idDelivery;
      ResponseApi responseApi =
          await _orderProvider.updateToTheDispatched(order);

      User deliveryUser = await _userProvider.getById(order.idDelivery);
      enviarNotificacion(deliveryUser.notificationToken);
      print('TOKEN: ---------${deliveryUser.notificationToken}');

      if (responseApi.success) {
        Fluttertoast.showToast(msg: responseApi.message);
        Navigator.pop(context, true);
        refresh();
      }
    } else {
      Fluttertoast.showToast(msg: 'Selecciona el repartidor');
      refresh();
    }
  }

  void updateToTheDispatchedBack() async {
    ResponseApi responseApi =
        await _orderProvider.updateToTheDispatchedBack(order);
    if (responseApi.success) {
      Fluttertoast.showToast(msg: responseApi.message);
      Navigator.pop(context, true);
      refresh();
    }
  }

  void updateOrderToOnWay() async {
    order.idDelivery = idDelivery;
    ResponseApi responseApi = await _orderProvider.updateToOntheWay(order);

    if (responseApi.success) {
      Fluttertoast.showToast(msg: responseApi.message);
      Navigator.pop(context, true);
      refresh();
    }
  }

  void updateOrderToDelivered() async {
    order.idDelivery = idDelivery;
    ResponseApi responseApi = await _orderProvider.updateToDelivered(order);

    if (responseApi.success) {
      Fluttertoast.showToast(msg: responseApi.message);
      Navigator.pop(context, true);
      refresh();
    }
  }

  void updateOrderToCancel() async {
    order.idDelivery = idDelivery;
    ResponseApi responseApi = await _orderProvider.updateToCancel(order);

    if (responseApi.success) {
      Fluttertoast.showToast(msg: responseApi.message);
      Navigator.pop(context, true);
      refresh();
    }
  }

  void getUsers() async {
    users = await _userProvider.getByDelivey();
    refresh();
  }

  void getTotal() {
    total = 0;
    order.products.forEach((producto) {
      total = total + (producto.price * producto.quantity);
    });

    refresh();
  }

  void callPhone(String numberPhone) {
    launch("tel:$numberPhone");
  }
}
