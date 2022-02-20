import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:la_bella_italia/src/pages/restaurante/mensajeros/agregar/restaurante_mensajeros_agregar_controller.dart';
import 'package:la_bella_italia/src/utils/my_colors.dart';

class RestauranteMensajerosAgregarPage extends StatefulWidget {
  const RestauranteMensajerosAgregarPage({key}) : super(key: key);

  @override
  _RestauranteMensajerosAgregarPageState createState() =>
      _RestauranteMensajerosAgregarPageState();
}

class _RestauranteMensajerosAgregarPageState
    extends State<RestauranteMensajerosAgregarPage> {
  RestauranteMensajerosAgregarController _obj =
      new RestauranteMensajerosAgregarController();
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
          title: Text('Regresar'),
        ),
        body: Container(
          child: Column(
            children: [_edtEmail(), _btnAdd()],
          ),
        ),
      ),
    );
  }

  Widget _btnAdd() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      child: ElevatedButton.icon(
        icon: Icon(Icons.how_to_reg),
        onPressed: _obj.addDelivery,
        label: Text('Agregar delivery'),
        style: ElevatedButton.styleFrom(
            primary: MyColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            padding: EdgeInsets.symmetric(vertical: 10)),
      ),
    );
  }

  Widget _edtEmail() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 100),
      decoration: BoxDecoration(
        color: MyColors.primaryOpacityColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: _obj.emailController,
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

  void refresh() {
    setState(() {});
  }
}
