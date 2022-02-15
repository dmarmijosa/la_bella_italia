import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:la_bella_italia/src/models/response_api.dart';
import 'package:la_bella_italia/src/models/user.dart';
import 'package:la_bella_italia/src/providers/user_provider.dart';
import 'package:la_bella_italia/src/utils/my_snackbar.dart';

import 'package:image_picker/image_picker.dart';
import 'package:la_bella_italia/src/utils/utilsapp.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class RegistroController {
  BuildContext context;

  TextEditingController correoController = new TextEditingController();
  TextEditingController nombreController = new TextEditingController();
  TextEditingController apellidoController = new TextEditingController();
  TextEditingController telefonoController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  TextEditingController confirPassController = new TextEditingController();

  UserProvider userProvider = new UserProvider();

  PickedFile pickedFile;
  File imageFile;
  Function refresh;
  ProgressDialog _progressDialog;
  bool isEnable = true;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    userProvider.init(context);
    _progressDialog = ProgressDialog(context: context);

    UtilsApp utilsApp = new UtilsApp();
    if (await utilsApp.internetConnectivity() == false) {
      Navigator.pushNamed(context, 'desconectado');
    }
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
    if (MyScnackbar.emailValid(correo) == false) {
      MyScnackbar.show(context, "Correo no valido");
      return;
    }

    if (imageFile == null) {
      MyScnackbar.show(context, "Selecciona una imagen");
      return;
    }
    if (telefono.length < 9) {
      MyScnackbar.show(
          context, "El número de telefono debe tener 9 caracteres.");
      return;
    }
    _progressDialog.show(max: 100, msg: "Espere un momento");
    isEnable = false;
    User user = new User(
      email: correo.trim().toLowerCase(),
      name: nombre.trim().toUpperCase(),
      lastname: apellido.trim().toUpperCase(),
      phone: telefono,
      password: pass.trim(),
    );
    Stream stream = await userProvider.createWithImage(user, imageFile);
    stream.listen(
      (res) {
        _progressDialog.close();

        try {
          ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
          print('respuesta ${responseApi.message}');
          MyScnackbar.show(context, responseApi.message);
          if (responseApi.success) {
            Future.delayed(
              Duration(seconds: 3),
              () {
                Navigator.pushReplacementNamed(context, 'login');
              },
            );
          } else {
            isEnable = true;
          }
        } catch (e) {
          isEnable = true;
          MyScnackbar.show(
              context, "Correo ya ha sido registrado anteriormente.");
          return;
        }
      },
    );

    //print('$correo $nombre $apellido $telefono $pass $confirPass');
  }

  Future selectImage(ImageSource imageSource) async {
    pickedFile = await ImagePicker().getImage(source: imageSource);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
    }
    Navigator.pop(context);
    refresh();
  }

  void showAlertDialog() {
    Widget galleryButton = ElevatedButton(
        onPressed: () {
          selectImage(ImageSource.gallery);
        },
        child: Text('GALERIA'));

    Widget cameraButton = ElevatedButton(
        onPressed: () {
          selectImage(ImageSource.camera);
        },
        child: Text('CAMARA'));

    AlertDialog alertDialog = AlertDialog(
      title: Text('Selecciona tu imagen'),
      actions: [galleryButton, cameraButton],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  void back() {
    Navigator.pop(context);
  }
}
