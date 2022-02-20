import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:la_bella_italia/src/pages/login/recoverAccount/recover_account_controller.dart';
import 'package:la_bella_italia/src/utils/my_colors.dart';

class RecoverAccountPage extends StatefulWidget {
  RecoverAccountPage({key}) : super(key: key);

  @override
  _RecoverAccountPageState createState() => _RecoverAccountPageState();
}

class _RecoverAccountPageState extends State<RecoverAccountPage> {
  RecoverAccountController _obj = new RecoverAccountController();
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
            children: [SizedBox(), _txtLavelInfo(), _edtEmail(), _btnRecover()],
          ),
        ),
      ),
    );
  }

  Widget _edtEmail() {
    return Container(
      margin: EdgeInsets.all(50),
      alignment: AlignmentDirectional.bottomStart,
      decoration: BoxDecoration(
        color: MyColors.primaryOpacityColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: _obj.emailController,
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

  Widget _txtLavelInfo() {
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

  Widget _btnRecover() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      child: ElevatedButton.icon(
        icon: Icon(Icons.build),
        onPressed: _obj.recoverAccount,
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
