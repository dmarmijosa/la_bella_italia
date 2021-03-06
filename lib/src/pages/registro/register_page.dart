import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:la_bella_italia/src/pages/registro/register_controller.dart';
import 'package:la_bella_italia/src/utils/my_colors.dart';

class Register extends StatefulWidget {
  Register({key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // ignore: non_constant_identifier_names
  bool is_press = true;
  RegisterController _obj = new RegisterController();

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
                child: _txtRegister(),
                top: 65,
                left: 27,
              ),
              Positioned(
                child: _btnBack(),
                top: 56,
                left: -5,
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 150),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _imageUser(),
                      SizedBox(
                        height: 30,
                      ),
                      _edtEmail(),
                      _edtName(),
                      _edtLastName(),
                      _edtPhone(),
                      _edtPassword(),
                      _edtConfirmPassword(),
                      _btnRegister()
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

  Widget _imageUser() {
    return GestureDetector(
      onTap: _obj.options,
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

  Widget _edtEmail() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 7),
      decoration: BoxDecoration(
        color: MyColors.primaryOpacityColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: _obj.emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'Correo electr??nico',
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

  Widget _edtName() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 7),
      decoration: BoxDecoration(
        color: MyColors.primaryOpacityColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: _obj.nameController,
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

  Widget _edtLastName() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 7),
      decoration: BoxDecoration(
        color: MyColors.primaryOpacityColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: _obj.lastNameController,
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

  Widget _edtPhone() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 7),
      decoration: BoxDecoration(
        color: MyColors.primaryOpacityColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: _obj.phoneController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'N??mero de tel??fono',
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
          hintText: 'Contrase??a',
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
          hintText: 'Confirmar contrase??a',
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

  Widget _btnRegister() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      child: ElevatedButton.icon(
        icon: Icon(Icons.how_to_reg),
        onPressed: _obj.isEnable ? _obj.register : null,
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

  Widget _btnBack() {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios,
        color: Colors.white,
      ),
      onPressed: _obj.goToBack,
    );
  }

  Widget _txtRegister() {
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
