import 'package:flutter/material.dart';
import 'package:la_bella_italia/src/models/address.dart';
import 'package:la_bella_italia/src/models/order.dart';
import 'package:la_bella_italia/src/models/product.dart';
import 'package:la_bella_italia/src/models/response_api.dart';
import 'package:la_bella_italia/src/models/user.dart';
import 'package:la_bella_italia/src/providers/address_provider.dart';
import 'package:la_bella_italia/src/providers/order_provider.dart';
import 'package:la_bella_italia/src/providers/pushNotification_provider.dart';

import 'package:la_bella_italia/src/providers/user_provider.dart';
import 'package:la_bella_italia/src/utils/UtilsApp.dart';
import 'package:la_bella_italia/src/utils/my_snackbar.dart';
import 'package:la_bella_italia/src/utils/shared_pref.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ClienteDireccionesListaController {
  BuildContext context;
  Function refresh;

  List<Address> direcciones = [];

  AddressProvider _addressProvider = new AddressProvider();
  User user;
  int radioValue = -1;
  UserProvider _userProvider = new UserProvider();
  SharedPref _sharedPref = new SharedPref();
  OrderProvider _orderProvider = new OrderProvider();
  PushNotificationProvider pushNotificationProvider =
      new PushNotificationProvider();
  List<String> tokens = [];

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    user = User.fromJson(await _sharedPref.read('user'));
    _userProvider.init(context, sessionUser: user);

    _addressProvider.init(context, user);
    _orderProvider.init(context, user);

    UtilsApp utilsApp = new UtilsApp();
    if (await utilsApp.internetConnectivity() == false) {
      Navigator.pushNamed(context, 'desconectado');
    }
    tokens = await _userProvider.getAdminsNotificationTokens();

    refresh();
  }

  void sendNotification() {
    List<String> registrationId = [];
    tokens.forEach((t) {
      if (t != null) {
        registrationId.add(t);
      }
    });

    Map<String, dynamic> data = {'click_action': 'FLUTTER_NOTIFICATION_CLICK'};

    pushNotificationProvider.sendMessageMultiple(registrationId, data,
        'COMPRA EXITOSA', 'Un cliente ha realizado un pedido');
  }

  void crearOrden() async {
    if (direcciones.length < 1) {
    } else {
      if (radioValue == -1) {
        Fluttertoast.showToast(
            msg: 'Debe seleccionar al menos una dirección agregada');
        Navigator.pop(context);
      } else {
        Address direccion =
            Address.fromJson(await _sharedPref.read('address') ?? {});
        List<Product> productosSeleccionados =
            Product.fromJsonList(await _sharedPref.read('order')).toList;

        Order orden = new Order(
          idClient: user.id,
          idAddress: direccion.id,
          products: productosSeleccionados,
        );

        ResponseApi responseApi = await _orderProvider.create(orden);
        MyScnackbar.show(context, responseApi.message);
        sendNotification();
        Navigator.pushNamedAndRemoveUntil(
            context, 'cliente/estado', (route) => false);
      }
    }
  }

  void handleRadioCambio(int value) async {
    radioValue = value;
    _sharedPref.save('address', direcciones[value]);

    refresh();
    print('Valor seleccionado $radioValue');
  }

  Future<List<Address>> getDirecciones() async {
    direcciones = await _addressProvider.getByUser(user.id);
    Address d = Address.fromJson(await _sharedPref.read('address') ?? {});

    print('Dato almacenado ${d.toJson()}');

    return direcciones;
  }

  void irACrearDireccion() async {
    var esCreado =
        await Navigator.pushNamed(context, 'cliente/direcciones/crear');
    if (esCreado != null) {
      if (esCreado) {
        refresh();
      }
    }
  }
}
