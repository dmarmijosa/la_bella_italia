import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:la_bella_italia/src/models/response_api.dart';
import 'package:la_bella_italia/src/models/user.dart';
import 'package:la_bella_italia/src/providers/user_provider.dart';
import 'package:la_bella_italia/src/utils/my_snackbar.dart';
import 'package:la_bella_italia/src/utils/shared_pref.dart';

import 'package:image_picker/image_picker.dart';
import 'package:la_bella_italia/src/utils/utilsapp.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ClienteActualizarController {
  BuildContext context;

  TextEditingController nameController = new TextEditingController();
  TextEditingController lastnameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  TextEditingController confirmPassController = new TextEditingController();

  UserProvider _userProvider = new UserProvider();

  PickedFile pickedFile;
  File imageFile;
  Function refresh;

  ProgressDialog _progressDialog;

  bool isEnable = true;
  User user;
  SharedPref _sharedPref = new SharedPref();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    _progressDialog = ProgressDialog(context: context);
    user = User.fromJson(await _sharedPref.read('user'));
    _userProvider.init(context, sessionUser: user);

    nameController.text = user.name;
    lastnameController.text = user.lastname;
    phoneController.text = user.phone;
    UtilsApp utilsApp = new UtilsApp();
    if (await utilsApp.internetConnectivity() == false) {
      Navigator.pushNamed(context, 'desconectado');
    }

    refresh();
  }

  void update() async {
    String nombre = nameController.text.toUpperCase().trim();
    String apellido = lastnameController.text.toUpperCase().trim();
    String telefono = phoneController.text.trim();
    String pass = passController.text.trim();
    String confirPass = confirmPassController.text.trim();

    if (nombre.isEmpty ||
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
    _progressDialog.show(max: 100, msg: 'Espere un momento...');
    isEnable = false;

    User myUser = new User(
        id: user.id,
        name: nombre,
        lastname: apellido,
        phone: telefono,
        image: user.image,
        password: pass);

    Stream stream = await _userProvider.updateUser(myUser, imageFile);
    stream.listen(
      (res) async {
        _progressDialog.close();

        ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
        Fluttertoast.showToast(msg: responseApi.message);

        if (responseApi.success) {
          user = await _userProvider.getById(myUser.id);
          print('usuario obtenido: ${user.toJson()}');
          _sharedPref.save('user', user.toJson());
          Navigator.pushNamedAndRemoveUntil(
              context, 'cliente/productos/lista', (route) => false);
        } else {
          isEnable = true;
        }
      },
    );
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

  void goToBack() {
    Navigator.pop(context);
  }
}
