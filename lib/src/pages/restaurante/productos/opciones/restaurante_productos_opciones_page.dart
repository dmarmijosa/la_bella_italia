import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:la_bella_italia/src/pages/restaurante/productos/opciones/restaurante_productos_opciones_controller.dart';
import 'package:la_bella_italia/src/utils/my_colors.dart';

class RestauranteProductosOpcionesPage extends StatefulWidget {
  const RestauranteProductosOpcionesPage({key}) : super(key: key);

  @override
  _RestauranteProductosOpcionesPageState createState() =>
      _RestauranteProductosOpcionesPageState();
}

class _RestauranteProductosOpcionesPageState
    extends State<RestauranteProductosOpcionesPage> {
  RestauranteProductosOpcionesController _obj =
      new RestauranteProductosOpcionesController();

  @override
  void initState() {
    // TODO: implement initState
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
              _btnCrear(
                  _obj.irACreacionProductos, "Crear producto", Icon(Icons.add)),
              _btnCrear(_obj.irAActualizarProductos, "Modificar producto",
                  Icon(Icons.edit)),
              _btnCrear(() {}, "Eliminar producto", Icon(Icons.delete)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _btnCrear(Function opcion, String texto, Icon icono) {
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
