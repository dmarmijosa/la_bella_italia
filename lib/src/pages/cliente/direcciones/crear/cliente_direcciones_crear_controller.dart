import 'package:flutter/material.dart';
import 'package:la_bella_italia/src/models/direccion.dart';
import 'package:la_bella_italia/src/models/response_api.dart';
import 'package:la_bella_italia/src/models/user.dart';
import 'package:la_bella_italia/src/pages/cliente/direcciones/mapa/cliente_direcciones_mapa_page.dart';
import 'package:la_bella_italia/src/providers/address_provider.dart';
import 'package:la_bella_italia/src/utils/my_snackbar.dart';
import 'package:la_bella_italia/src/utils/shared_pref.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ClienteDireccionesCrerController {
  BuildContext context;
  Function refresh;

  TextEditingController refPuntoController = new TextEditingController();
  TextEditingController direccionController = new TextEditingController();
  TextEditingController puebloController = new TextEditingController();

  AddressProvider _addressProvider = new AddressProvider();
  User user;
  SharedPref _sharedPref = new SharedPref();

  Map<String, dynamic> refPunto;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user'));
    _addressProvider.init(context, user);

    refresh();
  }

  void crearDireccion() async {
    String nombreDireccion = direccionController.text;
    String pueblo = puebloController.text;
    double lat = refPunto['lat'] ?? 0;
    double lng = refPunto['long'] ?? 0;

    if (nombreDireccion.isEmpty ||
        pueblo.isEmpty ||
        lat == 0 ||
        lng == 0 ||
        refPunto.isEmpty) {
      MyScnackbar.show(context, "Todos los campos son obligatorio");
      return;
    }

    if ((lat > 40.0547323 || lat < 39.9259837) &&
        (lng > 3.9019499 || lng < 3.8920364)) {
      MyScnackbar.show(
          context, "La dirección esta fuera de la zona de distribución");
      return;
    }

    Direccion direccion = new Direccion(
      idUser: user.id,
      address: nombreDireccion,
      town: pueblo,
      lat: lat,
      lng: lng,
    );

    ResponseApi responseApi = await _addressProvider.create(direccion);

    if (responseApi.success) {
      direccion.id = responseApi.data;
      _sharedPref.save('address', direccion);

      Fluttertoast.showToast(msg: "Creada correctamente");
      Navigator.pop(context, true);
    }
  }

  void abrirMapa() async {
    try {
      refPunto = await showMaterialModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: false,
        builder: (context) => ClienteDireccionesMapaPage(),
      );
      if (refPunto != null) {
        refPuntoController.text = refPunto['address'];
        refresh();
      }
    } catch (e) {}
  }
}
