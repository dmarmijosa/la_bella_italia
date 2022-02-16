import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:la_bella_italia/src/pages/login/recuperarCuenta/recuperar_cuenta_controller.dart';
import 'package:la_bella_italia/src/utils/my_colors.dart';

class RecuperarCuentaPage extends StatefulWidget {
  RecuperarCuentaPage({key}) : super(key: key);

  @override
  _RecuperarCuentaPageState createState() => _RecuperarCuentaPageState();
}

class _RecuperarCuentaPageState extends State<RecuperarCuentaPage> {
  RecuperarCuentaController _obj = new RecuperarCuentaController();
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _obj.init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Regresar'),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(),
              _txtRecordatorio(),
              _edtCorreo(),
              _btnRecuperar()
            ],
          ),
        ),
      ),
    );
  }

  Widget _edtCorreo() {
    return Container(
      margin: EdgeInsets.all(50),
      alignment: AlignmentDirectional.bottomStart,
      decoration: BoxDecoration(
        color: MyColors.primaryOpacityColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: _obj.correoController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'Correo eléctronico',
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

  Widget _txtRecordatorio() {
    return Container(
      margin: EdgeInsets.all(50),
      alignment: AlignmentDirectional.bottomStart,
      child: Text(
        'Ingrese un correo electrónico en el caso que se encuentre registrado se le enviará una clave de acceso.',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 20, color: Colors.black, fontStyle: FontStyle.italic),
      ),
    );
  }

  Widget _btnRecuperar() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      child: ElevatedButton.icon(
        icon: Icon(Icons.build),
        onPressed: _obj.recuperar,
        label: Text('Recuperar'),
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
