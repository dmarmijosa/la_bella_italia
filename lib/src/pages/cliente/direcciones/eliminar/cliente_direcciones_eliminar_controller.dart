import 'package:flutter/material.dart';
import 'package:la_bella_italia/src/models/address.dart';
import 'package:la_bella_italia/src/models/response_api.dart';
import 'package:la_bella_italia/src/models/user.dart';
import 'package:la_bella_italia/src/providers/address_provider.dart';
import 'package:la_bella_italia/src/utils/UtilsApp.dart';
import 'package:la_bella_italia/src/utils/my_snackbar.dart';
import 'package:la_bella_italia/src/utils/shared_pref.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ClienteDireccionesEliminarController {
  BuildContext context;
  Function refresh;
  List<Address> address = [];

  AddressProvider _addressProvider = new AddressProvider();
  User user;
  int radioValue = -1;

  SharedPref _sharedPref = new SharedPref();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    user = User.fromJson(await _sharedPref.read('user'));

    _addressProvider.init(context, user);

    UtilsApp utilsApp = new UtilsApp();
    if (await utilsApp.internetConnectivity() == false) {
      Navigator.pushNamed(context, 'desconectado');
    }

    refresh();
  }

  void handleRadioCambio(int value) async {
    radioValue = value;
    _sharedPref.save('addressDelete', address[value]);

    refresh();
    print('Valor seleccionado $radioValue');
  }

  Future<List<Address>> getAddress() async {
    address = await _addressProvider.getByUser(user.id);
    Address d = Address.fromJson(await _sharedPref.read('addressDelete') ?? {});

    print('Dato almacenado ${d.toJson()}');

    return address;
  }

  void deleteAddress() async {
    Address d = Address.fromJson(await _sharedPref.read('addressDelete') ?? {});
    ResponseApi responseApi = await _addressProvider.delete(d.id);
    Fluttertoast.showToast(msg: responseApi.message);
    MyScnackbar.show(context, radioValue.toString());
    refresh();
  }

  void goToCreateAddress() async {
    var esCreado =
        await Navigator.pushNamed(context, 'cliente/direcciones/crear');
    if (esCreado != null) {
      if (esCreado) {
        refresh();
      }
    }
  }
}
