import 'package:flutter/material.dart';
import 'package:la_bella_italia/src/models/direccion.dart';
import 'package:la_bella_italia/src/models/orden.dart';
import 'package:la_bella_italia/src/models/producto.dart';
import 'package:la_bella_italia/src/models/response_api.dart';
import 'package:la_bella_italia/src/models/user.dart';
import 'package:la_bella_italia/src/providers/address_provider.dart';
import 'package:la_bella_italia/src/providers/order_provider.dart';
import 'package:la_bella_italia/src/utils/shared_pref.dart';

class ClienteDireccionesListaController {
  BuildContext context;
  Function refresh;
  List<Direccion> direcciones = [];

  AddressProvider _addressProvider = new AddressProvider();
  User user;
  int radioValue = 0;

  SharedPref _sharedPref = new SharedPref();
  OrderProvider _orderProvider = new OrderProvider();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    user = User.fromJson(await _sharedPref.read('user'));

    _addressProvider.init(context, user);
    _orderProvider.init(context, user);

    refresh();
  }

  void crearOrden() async {
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
    print('Respuesta api: ${responseApi.message}');
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
