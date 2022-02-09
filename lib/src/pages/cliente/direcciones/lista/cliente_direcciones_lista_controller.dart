import 'package:flutter/material.dart';
import 'package:la_bella_italia/src/models/direccion.dart';
import 'package:la_bella_italia/src/models/orden.dart';
import 'package:la_bella_italia/src/models/producto.dart';
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
  List<String> tokens = [];
  List<Direccion> direcciones = [];
  PushNotificationProvider pushNotificationProvider =
      new PushNotificationProvider();

  AddressProvider _addressProvider = new AddressProvider();
  User user;
  int radioValue = 0;
  UserProvider _userProvider = new UserProvider();
  SharedPref _sharedPref = new SharedPref();
  OrderProvider _orderProvider = new OrderProvider();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    user = User.fromJson(await _sharedPref.read('user'));
    _userProvider.init(context, sessionUser: user);

    _addressProvider.init(context, user);
    _orderProvider.init(context, user);
    tokens = await _userProvider.getAdminsNotificationTokens();
    UtilsApp utilsApp = new UtilsApp();
    if (await utilsApp.internetConnectivity() == false) {
      Navigator.pushNamed(context, 'desconectado');
    }
    enviarNotificacion();

    refresh();
  }

  void crearOrden() async {
    if (direcciones.length < 1) {
      Fluttertoast.showToast(msg: 'Debe tener al menos una dirección agregada');
      Navigator.pop(context);
    } else {
      Direccion direccion =
          Direccion.fromJson(await _sharedPref.read('address') ?? {});
      List<Producto> productosSeleccionados =
          Producto.fromJsonList(await _sharedPref.read('order')).toList;

      Orden orden = new Orden(
        idClient: user.id,
        idAddress: direccion.id,
        products: productosSeleccionados,
      );
      ResponseApi responseApi = await _orderProvider.create(orden);
      MyScnackbar.show(context, responseApi.message);

      Navigator.pushNamedAndRemoveUntil(
          context, 'cliente/estado', (route) => false);
    }
  }

  void enviarNotificacion() {
    List<String> registrationIds = [];
    tokens.forEach((element) {
      if (element != null) {
        registrationIds.add(element);
      }
    });

    Map<String, dynamic> data = {'click_action': 'FLUTTER_NOTIFICATION_CLICK'};

    pushNotificationProvider.sendMessageMultiple(
      registrationIds,
      data,
      'ORDEN CREADA',
      'Cliente ha realizado una compra',
    );
  }

  void handleRadioCambio(int value) async {
    radioValue = value;
    _sharedPref.save('address', direcciones[value]);

    refresh();
    print('Valor seleccionado $radioValue');
  }

  Future<List<Direccion>> getDirecciones() async {
    direcciones = await _addressProvider.getByUser(user.id);
    Direccion d = Direccion.fromJson(await _sharedPref.read('address') ?? {});

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
