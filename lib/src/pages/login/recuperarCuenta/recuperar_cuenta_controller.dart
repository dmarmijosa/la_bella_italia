import 'package:flutter/material.dart';
import 'package:la_bella_italia/src/models/response_api.dart';

import 'package:la_bella_italia/src/providers/user_provider.dart';
import 'package:la_bella_italia/src/utils/UtilsApp.dart';
import 'package:la_bella_italia/src/utils/my_snackbar.dart';

class RecuperarCuentaController {
  TextEditingController correoController = new TextEditingController();
  BuildContext context;

  UserProvider userProvider = new UserProvider();

  Future init(context) async {
    this.context = context;

    userProvider.init(context);
    UtilsApp utilsApp = new UtilsApp();
    if (await utilsApp.internetConnectivity() == false) {
      Navigator.pushNamed(context, 'desconectado');
    }
  }

  Future<void> recuperar() async {
    String correo = correoController.text.trim();

    ResponseApi responseApi = await userProvider.recoverAccountUser(correo);

    MyScnackbar.show(context, responseApi.message);
    if (responseApi.success) {
      MyScnackbar.show(context, responseApi.message);
      Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
    } else {
      MyScnackbar.show(context, responseApi.message);
    }

    //
    // print(correoController);
  }
}
