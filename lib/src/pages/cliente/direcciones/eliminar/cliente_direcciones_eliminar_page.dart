import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:la_bella_italia/src/models/address.dart';
import 'package:la_bella_italia/src/pages/cliente/direcciones/eliminar/cliente_direcciones_eliminar_controller.dart';
import 'package:la_bella_italia/src/utils/my_colors.dart';
import 'package:la_bella_italia/src/utils/my_snackbar.dart';
import 'package:la_bella_italia/src/widgets/no_data_widget.dart';

class ClienteDireccionesEliminarPage extends StatefulWidget {
  const ClienteDireccionesEliminarPage({key}) : super(key: key);

  @override
  _ClienteDireccionesEliminarPageState createState() =>
      _ClienteDireccionesEliminarPageState();
}

class _ClienteDireccionesEliminarPageState
    extends State<ClienteDireccionesEliminarPage> {
  ClienteDireccionesEliminarController _obj =
      new ClienteDireccionesEliminarController();
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
        title: Text('Tu lista de direcciones'),
        actions: [
          _agregarDireccion(),
        ],
      ),
      body: Stack(
        children: [
          Positioned(top: 0, child: _txtSelecionaritem()),
          Container(
            margin: EdgeInsets.only(top: 50),
            child: _listaDirecciones(),
          )
        ],
      ),
      bottomNavigationBar: _btnEliminar(),
    );
  }

  Widget _noDirecciones() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 30),
          child: NoDataWidget(text: 'No tienes ninguna dirección agregada.'),
        ),
        _btnNuevaDireccion(),
      ],
    );
  }

  Widget _listaDirecciones() {
    return FutureBuilder(
        future: _obj.getDirecciones(),
        builder: (context, AsyncSnapshot<List<Address>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (_, index) {
                    return _radioDireccion(snapshot.data[index], index);
                  });
            } else {
              return _noDirecciones();
            }
          } else {
            return _noDirecciones();
          }
        });
  }

  Widget _radioDireccion(Address direccion, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Radio(
                value: index,
                groupValue: _obj.radioValue,
                onChanged: _obj.handleRadioCambio,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    direccion?.address ?? '',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    direccion?.town ?? '',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  )
                ],
              ),
            ],
          ),
          Divider(
            color: Colors.grey[400],
          )
        ],
      ),
    );
  }

  Widget _btnNuevaDireccion() {
    return Container(
      height: 40,
      child: ElevatedButton(
        onPressed: _obj.irACrearDireccion,
        child: Text('Nueva dirección.'),
        style: ElevatedButton.styleFrom(
          primary: Colors.green,
        ),
      ),
    );
  }

  Widget _btnEliminar() {
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
      child: ElevatedButton(
        onPressed: () => _obj.radioValue > 0
            ? showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Confirmar eliminación'),
                  content:
                      const Text('¿ Esta seguro de eliminar la dirección ?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => {
                        _obj.eliminarDireccion(),
                        Navigator.pop(context, 'OK'),
                      },
                      child: const Text('Si'),
                    ),
                  ],
                ),
              )
            : MyScnackbar.show(context, 'Debe seleccionar una dirección'),
        child: Text('Eliminar'),
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            primary: MyColors.primaryColor),
      ),
    );
  }

  Widget _txtSelecionaritem() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      child: Text(
        'Elige la dirección que vas a eliminar.',
        style: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _agregarDireccion() {
    return IconButton(
      icon: Icon(
        Icons.add,
        color: Colors.white,
      ),
      onPressed: _obj.irACrearDireccion,
    );
  }

  refresh() {
    setState(() {});
  }
}
