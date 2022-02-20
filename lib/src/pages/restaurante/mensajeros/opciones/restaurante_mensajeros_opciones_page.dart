import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:la_bella_italia/src/pages/restaurante/mensajeros/opciones/restaurante_mensajeros_opciones_controller.dart';
import 'package:la_bella_italia/src/utils/my_colors.dart';

class RestauranteMensajerosOpcionesPage extends StatefulWidget {
  const RestauranteMensajerosOpcionesPage({key}) : super(key: key);

  @override
  _RestauranteMensajerosOpcionesPageState createState() =>
      _RestauranteMensajerosOpcionesPageState();
}

class _RestauranteMensajerosOpcionesPageState
    extends State<RestauranteMensajerosOpcionesPage> {
  RestauranteMensajerosOpcionesController _obj =
      new RestauranteMensajerosOpcionesController();
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _obj.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Regresar'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _btnOptions(
                  _obj.goToAddDelivery, "Agregar mensajero", Icon(Icons.add)),
              _btnOptions(_obj.goToDeleteDelivery, "Eliminar mensajero",
                  Icon(Icons.remove)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _btnOptions(Function opcion, String texto, Icon icono) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      child: ElevatedButton.icon(
        icon: icono,
        onPressed: opcion,
        label: Text(texto),
        style: ElevatedButton.styleFrom(
            primary: MyColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            padding: EdgeInsets.symmetric(vertical: 10)),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
