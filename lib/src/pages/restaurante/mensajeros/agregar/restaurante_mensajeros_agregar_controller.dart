import 'package:flutter/material.dart';
import 'package:la_bella_italia/src/models/response_api.dart';
import 'package:la_bella_italia/src/models/user.dart';
import 'package:la_bella_italia/src/providers/user_provider.dart';
import 'package:la_bella_italia/src/utils/my_snackbar.dart';
import 'package:la_bella_italia/src/utils/shared_pref.dart';
import 'package:la_bella_italia/src/utils/utilsApp.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class RestauranteMensajerosAgregarController {
  BuildContext context;
  Function refresh;

  SharedPref _sharedPref = new SharedPref();
  ProgressDialog _progressDialog;
  TextEditingController correoController = new TextEditingController();
  UserProvider _userProvider = new UserProvider();
  User user;
  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    UtilsApp utilsApp = new UtilsApp();
    if (await utilsApp.internetConnectivity() == false) {
      Navigator.pushNamed(context, 'desconectado');
    }
    user = User.fromJson(await _sharedPref.read('user'));

    _userProvider.init(context, sessionUser: user);
    _progressDialog = ProgressDialog(context: context);

    refresh();
  }

  void agregarMensajero() async {
    String correo = correoController.text.toLowerCase();
    if (correo.isEmpty) {
      MyScnackbar.show(context, 'EL correo es requerido.');
      return;
    }

    if (MyScnackbar.emailValid(correo) == false) {
      MyScnackbar.show(context, "Correo no valido");
      return;
    }
    User myUser;

    _progressDialog.show(max: 100, msg: "Espere un momento");
    ResponseApi responseApi = await _userProvider.findUserEmail(correo);
    if (!responseApi.success) {
      try {
        _progressDialog.close();
        myUser = User.fromJson(responseApi.data);
        ResponseApi _res = await _userProvider.addDelivery(myUser.id);
        MyScnackbar.show(context, _res.message);
        correoController.text = "";
      } catch (e) {
        _progressDialog.close();
        MyScnackbar.show(context, "Mensajero ya fue agregado anteriormente");
        correoController.text = "";
      }
    } else {
      MyScnackbar.show(context, responseApi.message);
      _progressDialog.close();
    }
  }
}
