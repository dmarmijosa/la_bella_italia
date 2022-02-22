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

class DeliveryOrdenesDetalleController {
  BuildContext context;
  Function refresh;

  SharedPref _sharedPref = new SharedPref();
  UserProvider _userProvider = new UserProvider();
  OrderProvider _orderProvider = new OrderProvider();

  double total = 0;

  User user;
  bool stateRestaurant;
  String message;
  Order order;
  List<User> users = [];
  String idDelivery;
  PushNotificationProvider pushNotificationsProvider =
      new PushNotificationProvider();

  Future init(BuildContext context, Function refresh, Order orden) async {
    this.context = context;
    this.refresh = refresh;
    this.order = orden;
    user = User.fromJson(await _sharedPref.read('user'));
    _userProvider.init(context, sessionUser: user);
    _orderProvider.init(context, user);
    getTotal();
    getUsers();
    UtilsApp utilsApp = new UtilsApp();
    if (await utilsApp.internetConnectivity() == false) {
      Navigator.pushNamed(context, 'desconectado');
    }
    refresh();
  }

  void sendNotification(String tokenDelivery) {
    Map<String, dynamic> data = {'click_action': 'FLUTTER_NOTIFICATION_CLICK'};

    pushNotificationsProvider.sendMessage(
        tokenDelivery, data, 'ORDEN EN CAMINO', 'Tu repartidor esta en camino');
  }

  void updateOrder() async {
    ResponseApi responseApi = await _orderProvider.updateToOntheWay(order);
    Fluttertoast.showToast(msg: responseApi.message);

    sendNotification(order.client.notificationToken);

    if (responseApi.success) {
      Navigator.pushNamed(
        context,
        'delivery/ordenes/mapa',
        arguments: order.toJson(),
      );
      refresh();
    }
  }

  void goToMap() async {
    Navigator.pushNamed(
      context,
      'delivery/ordenes/mapa',
      arguments: order.toJson(),
    );
    refresh();
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

  void callPhone(String phone) {
    launch("tel:$phone");
  }
}
