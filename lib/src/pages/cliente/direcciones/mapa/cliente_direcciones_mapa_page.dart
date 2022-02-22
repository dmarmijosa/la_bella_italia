import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:la_bella_italia/src/pages/cliente/direcciones/mapa/cliente_direcciones_mapa_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:la_bella_italia/src/utils/my_colors.dart';

class ClienteDireccionesMapaPage extends StatefulWidget {
  const ClienteDireccionesMapaPage({key}) : super(key: key);

  @override
  _ClienteDireccionesMapaPageState createState() =>
      _ClienteDireccionesMapaPageState();
}

class _ClienteDireccionesMapaPageState
    extends State<ClienteDireccionesMapaPage> {
  ClienteDireccionesMapaController _obj =
      new ClienteDireccionesMapaController();

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
        title: Text('Selecciona la ubicación.'),
      ),
      body: Stack(
        children: [
          _mapGoogle(),
          Container(
            alignment: Alignment.center,
            child: _iconLocalization(),
          ),
          Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.only(top: 30),
            child: _targetPosition(),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: _btnSelect(),
          )
        ],
      ),
    );
  }

  Widget _btnSelect() {
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 40, horizontal: 70),
      child: ElevatedButton(
        onPressed: _obj.selectRefPoint,
        child: Text('SELECCIONAR DIRECCIÓN'),
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            primary: MyColors.primaryColor),
      ),
    );
  }

  Widget _iconLocalization() {
    return Image.asset(
      'assets/img/my_location.png',
      width: 65,
      height: 65,
    );
  }

  Widget _targetPosition() {
    return Container(
      child: Card(
        color: Colors.grey[700],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            _obj.addressName ?? '',
            style: TextStyle(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _mapGoogle() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _obj.positionInit,
      onMapCreated: _obj.onMapCreate,
      myLocationButtonEnabled: false,
      myLocationEnabled: false,
      onCameraMove: (position) {
        _obj.positionInit = position;
      },
      onCameraIdle: () async {
        await _obj.setLocalizacionInfo();
      },
    );
  }

  void refresh() {
    setState(() {});
  }
}
