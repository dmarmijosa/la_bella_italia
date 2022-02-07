import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:la_bella_italia/src/utils/my_colors.dart';
import 'package:lottie/lottie.dart';
import 'package:la_bella_italia/src/pages/cliente/estado/cliente_estado_controller.dart';

class ClienteEstadoPage extends StatefulWidget {
  const ClienteEstadoPage({key}) : super(key: key);

  @override
  _ClienteEstadoPageState createState() => _ClienteEstadoPageState();
}

class _ClienteEstadoPageState extends State<ClienteEstadoPage> {
  ClienteEstadoController _obj = new ClienteEstadoController();
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _obj.init(context, refresh);
      refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _animacionLogin(),
          _txtFinalizar(),
          Spacer(),
          _btnFinalizar(),
        ],
      ),
    );
  }

  Widget _txtFinalizar() {
    return Container(
      child: Text(
        'Gracias por tu compra',
        style: TextStyle(fontSize: 30, fontFamily: 'Pacifico'),
      ),
    );
  }

  Widget _btnFinalizar() {
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
      child: ElevatedButton(
        onPressed: _obj.finalizarCompra,
        child: Text('Finalizar compra'),
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            primary: MyColors.primaryColor),
      ),
    );
  }

  Widget _animacionLogin() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(
          top: 10, bottom: MediaQuery.of(context).size.height * 0.1),
      child: Lottie.asset('assets/json/happy.json',
          width: 250, height: 250, fit: BoxFit.fill),
    );
  }

  // ignore: missing_return
  Function refresh() {
    setState(() {});
  }
}
