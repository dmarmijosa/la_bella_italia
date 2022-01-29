import 'package:flutter/material.dart';
import 'package:la_bella_italia/src/models/direccion.dart';
import 'package:la_bella_italia/src/models/user.dart';
import 'package:la_bella_italia/src/providers/address_provider.dart';
import 'package:la_bella_italia/src/utils/shared_pref.dart';

class ClienteDireccionesListaController {
  BuildContext context;
  Function refresh;
  List<Direccion> direcciones = [];

  AddressProvider _addressProvider = new AddressProvider();
  User user;
  int radioValue = 0;

  SharedPref _sharedPref = new SharedPref();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    user = User.fromJson(await _sharedPref.read('user'));

    _addressProvider.init(context, user);

    refresh();
  }

  void handleRadioCambio(int value) async {
    radioValue = value;
    _sharedPref.save('address', direcciones[value]);

    refresh();
    print('Valor seleccionado ${radioValue}');
  }

  Future<List<Direccion>> getDirecciones() async {
    direcciones = await _addressProvider.getByUser(user.id);
    Direccion d = Direccion.fromJson(await _sharedPref.read('address') ?? {});
    int index = direcciones.indexWhere((element) => element.id == d.id);

    if (index != -1) {
      radioValue = index;
    }
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
