import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:la_bella_italia/src/models/direccion.dart';
import 'package:la_bella_italia/src/pages/cliente/direcciones/lista/cliente_direcciones_lista_controller.dart';
import 'package:la_bella_italia/src/utils/my_colors.dart';
import 'package:la_bella_italia/src/widgets/no_data_widget.dart';

class ClienteDireccionesListaPage extends StatefulWidget {
  const ClienteDireccionesListaPage({key}) : super(key: key);

  @override
  _ClienteDireccionesListaPageState createState() =>
      _ClienteDireccionesListaPageState();
}

class _ClienteDireccionesListaPageState
    extends State<ClienteDireccionesListaPage> {
  ClienteDireccionesListaController _ccdlc =
      new ClienteDireccionesListaController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _ccdlc.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dirección'),
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
      bottomNavigationBar: _btnAceptar(),
    );
  }

  Widget _noDirecciones() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 30),
          child: NoDataWidget(texto: 'No tienes ninguna dirección agregada.'),
        ),
        _btnNuevaDireccion(),
      ],
    );
  }

  Widget _listaDirecciones() {
    return FutureBuilder(
        future: _ccdlc.getDirecciones(),
        builder: (context, AsyncSnapshot<List<Direccion>> snapshot) {
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

  Widget _radioDireccion(Direccion direccion, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Radio(
                value: index,
                groupValue: _ccdlc.radioValue,
                onChanged: _ccdlc.handleRadioCambio,
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
        onPressed: _ccdlc.irACrearDireccion,
        child: Text('Nueva dirección.'),
        style: ElevatedButton.styleFrom(
          primary: Colors.green,
        ),
      ),
    );
  }

  Widget _btnAceptar() {
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
      child: ElevatedButton(
        onPressed: _ccdlc.crearOrden,
        child: Text('ACEPTAR'),
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
        'Elige donde recibir tus compras.',
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
      onPressed: _ccdlc.irACrearDireccion,
    );
  }

  refresh() {
    setState(() {});
  }
}
