import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:la_bella_italia/src/pages/login/login_controller.dart';
import 'package:la_bella_italia/src/utils/my_colors.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  LoginPage({key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginController _obj = new LoginController();
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _obj.init(context);
    });
  }

  // ignore: non_constant_identifier_names
  bool is_press = true;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Column(
              children: [
                _animacionLogin(),
                _txtRestaurante(),
                _edtCorreo(),
                _edtPassword(),
                _btnLogin(),
                _txtRegistrarse(),
                _txtRecuperar()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _animacionLogin() {
    return Container(
      margin: EdgeInsets.only(
          top: 10, bottom: MediaQuery.of(context).size.height * 0.01),
      child: Lottie.asset('assets/json/chef.json',
          width: 350, height: 400, fit: BoxFit.fill),
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

  Widget _btnLogin() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      child: ElevatedButton.icon(
        icon: Icon(Icons.restaurant),
        onPressed: _obj.login,
        label: Text('Ingresar'),
        style: ElevatedButton.styleFrom(
            primary: MyColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            padding: EdgeInsets.symmetric(vertical: 10)),
      ),
    );
  }

  Widget _txtRegistrarse() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '¿ No tienes cuenta ?',
          style: TextStyle(color: MyColors.primaryColor),
        ),
        SizedBox(
          width: 7,
        ),
        GestureDetector(
          onTap: () {
            _obj.irA();
          },
          child: Text(
            'Registrate',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: MyColors.primaryColor,
                fontSize: 17),
          ),
        )
      ],
    );
  }

  Widget _txtRestaurante() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'La',
            style: TextStyle(
                color: Colors.green, fontFamily: 'Pacifico', fontSize: 30),
          ),
          SizedBox(
            width: 7,
          ),
          Text(
            'Bella',
            style: TextStyle(
                color: Colors.grey, fontFamily: 'Pacifico', fontSize: 30),
          ),
          SizedBox(
            width: 7,
          ),
          Text(
            'Italia',
            style: TextStyle(
                color: Colors.red, fontFamily: 'Pacifico', fontSize: 30),
          ),
          SizedBox(
            width: 7,
          ),
        ],
      ),
    );
  }

  Widget _txtRecuperar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 50,
        ),
        Text(
          '¿ Olvidaste la contraseña ?',
          style: TextStyle(color: MyColors.primaryColor),
        ),
        SizedBox(
          width: 7,
        ),
        GestureDetector(
          onTap: () {
            _obj.recuperar();
          },
          child: Text(
            'Recuperar cuenta',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: MyColors.primaryColor,
                fontSize: 17),
          ),
        )
      ],
    );
  }
}
