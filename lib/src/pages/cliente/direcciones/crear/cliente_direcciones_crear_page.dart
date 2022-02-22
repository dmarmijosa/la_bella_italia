import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:la_bella_italia/src/pages/cliente/direcciones/crear/cliente_direcciones_crear_controller.dart';
import 'package:la_bella_italia/src/utils/my_colors.dart';

class ClienteDireccionesCrearPage extends StatefulWidget {
  const ClienteDireccionesCrearPage({key}) : super(key: key);

  @override
  _ClienteDireccionesCrearPageState createState() =>
      _ClienteDireccionesCrearPageState();
}

class _ClienteDireccionesCrearPageState
    extends State<ClienteDireccionesCrearPage> {
  ClienteDireccionesCrerController _obj =
      new ClienteDireccionesCrerController();

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
        appBar: AppBar(
          title: Text('Crear nueva dirección'),
        ),
        //bottomNavigationBar: _btnAceptar(),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: ListView(
            children: [
              Column(
                children: [
                  _txtCompleteDate(),
                  _edtDirection(),
                  _edtTown(),
                  _edtPointRef(),
                  _btnAcept()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _edtPointRef() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: TextField(
        controller: _obj.refPointController,
        onTap: _obj.openMap,
        autofocus: false,
        focusNode: AlwaysDisabledFocused(),
        decoration: InputDecoration(
          labelText: 'Punto de referencia',
          suffixIcon: Icon(
            Icons.location_on,
            color: MyColors.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _edtTown() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: TextField(
        controller: _obj.townController,
        decoration: InputDecoration(
          labelText: 'Pueblo',
          suffixIcon: Icon(
            Icons.location_city,
            color: MyColors.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _edtDirection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextField(
        controller: _obj.directionController,
        decoration: InputDecoration(
          labelText: 'Dirección',
          suffixIcon: Icon(
            Icons.near_me,
            color: MyColors.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _txtCompleteDate() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      child: Text(
        'Completa los siguientes datos:',
        style: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _btnAcept() {
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
      child: ElevatedButton(
        onPressed: _obj.createDirection,
        child: Text('AGREGAR DIRECCIÓN'),
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            primary: MyColors.primaryColor),
      ),
    );
  }

  refresh() {
    setState(() {});
  }
}

class AlwaysDisabledFocused extends FocusNode {
  @override
  bool get hasFocus => false;
}
