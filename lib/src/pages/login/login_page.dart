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
  LoginController _login = new LoginController();
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _login.init(context);
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
                _edtCorreo(),
                _edtPassword(),
                _btnLogin(),
                _txtRegistrarse()
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
        controller: _login.correoController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'Correo electronico',
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
        controller: _login.passController,
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
        onPressed: _login.login,
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
            _login.irA();
          },
          child: Text(
            'Registrate',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: MyColors.primaryColor),
          ),
        )
      ],
    );
  }
}
