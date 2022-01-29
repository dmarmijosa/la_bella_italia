import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:la_bella_italia/src/pages/cliente/actualizar/cliente_actualizar_controller.dart';
import 'package:la_bella_italia/src/utils/my_colors.dart';

class ClienteActualizarPage extends StatefulWidget {
  const ClienteActualizarPage({key}) : super(key: key);

  @override
  _ClienteActualizarPageState createState() => _ClienteActualizarPageState();
}

class _ClienteActualizarPageState extends State<ClienteActualizarPage> {
  // ignore: non_constant_identifier_names
  bool is_press = true;
  ClienteActualizarController _ccac = new ClienteActualizarController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _ccac.init(context, refresh);
    });
    setState(() {});
  }

  void refresh() {
    setState(
      () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        FocusScope.of(context).requestFocus(FocusNode()),
        setState(
          () {},
        )
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Editar perfil'),
        ),
        body: Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: 50),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _imageUser(),
                SizedBox(
                  height: 30,
                ),
                _edtNombre(),
                _edtApellido(),
                _edtTelefono(),
                _edtPassword(),
                _edtConfirmPassword(),
                _btnActualizar()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _imageUser() {
    return GestureDetector(
      onTap: _ccac.showAlertDialog,
      child: CircleAvatar(
        backgroundImage: _ccac.imageFile != null
            ? FileImage(_ccac.imageFile)
            : _ccac.user?.image != null
                ? NetworkImage(_ccac.user?.image)
                : AssetImage('assets/img/user_profile_2.png'),
        radius: 60,
        backgroundColor: Colors.grey[200],
      ),
    );
  }

  Widget _edtNombre() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 7),
      decoration: BoxDecoration(
        color: MyColors.primaryOpacityColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: _ccac.nombreController,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          hintText: 'Nombre',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          prefixIcon: Icon(
            Icons.person,
            color: MyColors.primaryColor,
          ),
          hintStyle: TextStyle(color: MyColors.primaryColorDark),
        ),
      ),
    );
  }

  Widget _edtApellido() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 7),
      decoration: BoxDecoration(
        color: MyColors.primaryOpacityColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: _ccac.apellidoController,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          hintText: 'Apellido',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          prefixIcon: Icon(
            Icons.person_outline,
            color: MyColors.primaryColor,
          ),
          hintStyle: TextStyle(color: MyColors.primaryColorDark),
        ),
      ),
    );
  }

  Widget _edtTelefono() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 7),
      decoration: BoxDecoration(
        color: MyColors.primaryOpacityColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: _ccac.telefonoController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'Número de teléfono',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          prefixIcon: Icon(
            Icons.phone,
            color: MyColors.primaryColor,
          ),
          hintStyle: TextStyle(color: MyColors.primaryColorDark),
        ),
      ),
    );
  }

  Widget _edtPassword() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 7),
      decoration: BoxDecoration(
        color: MyColors.primaryOpacityColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: _ccac.passController,
        obscureText: this.is_press,
        decoration: InputDecoration(
          hintText: 'Contraseña',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          prefixIcon: IconButton(
            color: MyColors.primaryColor,
            onPressed: () {
              setState(() => {this.is_press = !this.is_press});
            },
            icon: Icon(this.is_press ? Icons.visibility : Icons.visibility_off),
          ),
          hintStyle: TextStyle(color: MyColors.primaryColorDark),
        ),
      ),
    );
  }

  Widget _edtConfirmPassword() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 7),
      decoration: BoxDecoration(
        color: MyColors.primaryOpacityColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: _ccac.confirPassController,
        obscureText: this.is_press,
        decoration: InputDecoration(
          hintText: 'Confirmar contraseña',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          prefixIcon: IconButton(
            color: MyColors.primaryColor,
            onPressed: () {
              setState(() => {this.is_press = !this.is_press});
            },
            icon: Icon(this.is_press ? Icons.visibility : Icons.visibility_off),
          ),
          hintStyle: TextStyle(color: MyColors.primaryColorDark),
        ),
      ),
    );
  }

  Widget _btnActualizar() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      child: ElevatedButton.icon(
        icon: Icon(Icons.autorenew),
        onPressed: _ccac.isEnable ? _ccac.actualizar : null,
        label: Text('Actualizar'),
        style: ElevatedButton.styleFrom(
            primary: MyColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            padding: EdgeInsets.symmetric(vertical: 10)),
      ),
    );
  }
}
