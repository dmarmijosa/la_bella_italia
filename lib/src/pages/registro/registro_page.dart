import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:la_bella_italia/src/pages/registro/registro_controller.dart';
import 'package:la_bella_italia/src/utils/my_colors.dart';

class Registro extends StatefulWidget {
  Registro({key}) : super(key: key);

  @override
  _RegistroState createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  // ignore: non_constant_identifier_names
  bool is_press = true;
  RegistroController _obj = new RegistroController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _obj.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          child: Stack(
            children: [
              Positioned(
                top: -80,
                left: -100,
                child: _avatar(),
              ),
              Positioned(
                child: _txtRegistro(),
                top: 65,
                left: 27,
              ),
              Positioned(
                child: _iconoRegresar(),
                top: 56,
                left: -5,
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 150),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _imagenUser(),
                      SizedBox(
                        height: 30,
                      ),
                      _edtCorreo(),
                      _edtNombre(),
                      _edtApellido(),
                      _edtTelefono(),
                      _edtPassword(),
                      _edtConfirmPassword(),
                      _btnRegistrar()
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _imagenUser() {
    return GestureDetector(
      onTap: _obj.menuOpcionesEscoger,
      child: CircleAvatar(
        radius: 63,
        backgroundColor: Colors.red[400],
        child: CircleAvatar(
          backgroundImage: _obj.imageFile != null
              ? FileImage(_obj.imageFile)
              : AssetImage('assets/img/user_profile_2.png'),
          radius: 60,
          backgroundColor: Colors.grey[300],
          child: Align(
            alignment: Alignment.bottomRight,
            child: CircleAvatar(
              backgroundColor: Colors.red[400],
              radius: 22,
              child: CircleAvatar(
                backgroundColor: Colors.grey[100],
                child: Icon(
                  Icons.add_a_photo,
                  color: Colors.black,
                  size: 34,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _edtCorreo() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 7),
      decoration: BoxDecoration(
        color: MyColors.primaryOpacityColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: _obj.correoController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'Correo electrónico',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          prefixIcon: Icon(
            Icons.email_sharp,
            color: MyColors.primaryColor,
          ),
          hintStyle: TextStyle(color: MyColors.primaryColorDark),
        ),
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
        controller: _obj.nombreController,
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
        controller: _obj.apellidoController,
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
        controller: _obj.telefonoController,
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
        controller: _obj.passController,
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
        controller: _obj.confirPassController,
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

  Widget _btnRegistrar() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      child: ElevatedButton.icon(
        icon: Icon(Icons.how_to_reg),
        onPressed: _obj.isEnable ? _obj.registro : null,
        label: Text('Registrarse'),
        style: ElevatedButton.styleFrom(
            primary: MyColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            padding: EdgeInsets.symmetric(vertical: 10)),
      ),
    );
  }

  Widget _avatar() {
    return Container(
      width: 240,
      height: 230,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: MyColors.primaryColor),
    );
  }

  Widget _iconoRegresar() {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios,
        color: Colors.white,
      ),
      onPressed: _obj.regresar,
    );
  }

  Widget _txtRegistro() {
    return Text(
      'Registro',
      style: TextStyle(color: Colors.white, fontSize: 22),
    );
  }

  void refresh() {
    setState(
      () {},
    );
  }
}
