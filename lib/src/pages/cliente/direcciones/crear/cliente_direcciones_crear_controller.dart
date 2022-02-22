import 'package:flutter/material.dart';
import 'package:la_bella_italia/src/models/address.dart';
import 'package:la_bella_italia/src/models/response_api.dart';
import 'package:la_bella_italia/src/models/user.dart';
import 'package:la_bella_italia/src/pages/cliente/direcciones/mapa/cliente_direcciones_mapa_page.dart';
import 'package:la_bella_italia/src/providers/address_provider.dart';
import 'package:la_bella_italia/src/utils/UtilsApp.dart';
import 'package:la_bella_italia/src/utils/my_snackbar.dart';
import 'package:la_bella_italia/src/utils/shared_pref.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ClienteDireccionesCrerController {
  BuildContext context;
  Function refresh;

  TextEditingController refPointController = new TextEditingController();
  TextEditingController directionController = new TextEditingController();
  TextEditingController townController = new TextEditingController();

  AddressProvider _addressProvider = new AddressProvider();
  User user;
  SharedPref _sharedPref = new SharedPref();

  Map<String, dynamic> refPoint;

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

  void createDirection() async {
    String nombreDireccion = directionController.text;
    String pueblo = townController.text;
    double lat = refPoint['lat'] ?? 0;
    double lng = refPoint['long'] ?? 0;

    if (nombreDireccion.isEmpty ||
        pueblo.isEmpty ||
        lat == 0 ||
        lng == 0 ||
        refPoint.isEmpty) {
      MyScnackbar.show(context, "Todos los campos son obligatorio");
      return;
    }

    if ((lat > 40.0547323 || lat < 39.9259837) &&
        (lng > 3.9019499 || lng < 3.8920364)) {
      MyScnackbar.show(
          context, "La dirección esta fuera de la zona de distribución");
      return;
    }

    Address direccion = new Address(
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

  void openMap() async {
    try {
      refPoint = await showMaterialModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: false,
        builder: (context) => ClienteDireccionesMapaPage(),
      );
      if (refPoint != null) {
        refPointController.text = refPoint['address'];
        refresh();
      }
    } catch (e) {}
  }
}
