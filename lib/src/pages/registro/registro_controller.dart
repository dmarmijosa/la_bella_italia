import 'package:flutter/material.dart';
import 'package:la_bella_italia/src/api/response_api.dart';
import 'package:la_bella_italia/src/models/user.dart';
import 'package:la_bella_italia/src/providers/user_provider.dart';
import 'package:la_bella_italia/src/utils/my_snackbar.dart';

class RegistroController {
  BuildContext context;

  TextEditingController correoController = new TextEditingController();
  TextEditingController nombreController = new TextEditingController();
  TextEditingController apellidoController = new TextEditingController();
  TextEditingController telefonoController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  TextEditingController confirPassController = new TextEditingController();

  UserProvider userProvider = new UserProvider();

  Future init(BuildContext context) async {
    this.context = context;
    userProvider.init(context);
  }

  Future<void> registro() async {
    String correo = correoController.text;
    String nombre = nombreController.text;
    String apellido = apellidoController.text;
    String telefono = telefonoController.text;
    String pass = passController.text;
    String confirPass = confirPassController.text;
    if (correo.isEmpty ||
        nombre.isEmpty ||
        apellido.isEmpty ||
        telefono.isEmpty ||
        pass.isEmpty ||
        confirPass.isEmpty) {
      MyScnackbar.show(context, 'Todos los campos son onligatorios.');
      return;
    }
    if (confirPass != pass) {
      MyScnackbar.show(context, "Las contraseñas deben ser iguales.");
      return;
    }
    if (pass.length <= 6) {
      MyScnackbar.show(context, "la contraseña debe tener 8 caracteres.");
      return;
    }
    if (MyScnackbar.emailValid(correo)) {
      MyScnackbar.show(context, "Correo no valido");
      return;
    }
    User user = new User(
      email: correo.trim().toLowerCase(),
      name: nombre.trim().toUpperCase(),
      lastname: apellido.trim().toUpperCase(),
      phone: telefono,
      password: pass.trim(),
    );

    ResponseApi responseApi = await userProvider.create(user);

    MyScnackbar.show(context, responseApi.message);
    print('respuesta ${responseApi.toJson()}');

    print('$correo $nombre $apellido $telefono $pass $confirPass');
  }
}
