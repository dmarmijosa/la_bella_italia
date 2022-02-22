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
          _addAddress(),
        ],
      ),
      body: Stack(
        children: [
          Positioned(top: 0, child: _txtSelectItem()),
          Container(
            margin: EdgeInsets.only(top: 50),
            child: _listAddress(),
          )
        ],
      ),
      bottomNavigationBar: _btnDelete(),
    );
  }

  Widget _noAddress() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 30),
          child: NoDataWidget(text: 'No tienes ninguna dirección agregada.'),
        ),
        _btnNewAddress(),
      ],
    );
  }

  Widget _listAddress() {
    return FutureBuilder(
        future: _obj.getAddress(),
        builder: (context, AsyncSnapshot<List<Address>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (_, index) {
                    return _radioAddressValue(snapshot.data[index], index);
                  });
            } else {
              return _noAddress();
            }
          } else {
            return _noAddress();
          }
        });
  }

  Widget _radioAddressValue(Address direccion, int index) {
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

  Widget _btnNewAddress() {
    return Container(
      height: 40,
      child: ElevatedButton(
        onPressed: _obj.goToCreateAddress,
        child: Text('Nueva dirección.'),
        style: ElevatedButton.styleFrom(
          primary: Colors.green,
        ),
      ),
    );
  }

  Widget _btnDelete() {
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
                        _obj.deleteAddress(),
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

  Widget _txtSelectItem() {
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

  Widget _addAddress() {
    return IconButton(
      icon: Icon(
        Icons.add,
        color: Colors.white,
      ),
      onPressed: _obj.goToCreateAddress,
    );
  }

  refresh() {
    setState(() {});
  }
}
