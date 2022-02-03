import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:la_bella_italia/src/pages/cliente/ordenes/mapa/cliente_ordenes_mapa_controller.dart';
import 'package:la_bella_italia/src/utils/my_colors.dart';

import 'package:url_launcher/url_launcher.dart';

class ClienteOrdenesMapaPage extends StatefulWidget {
  const ClienteOrdenesMapaPage({key}) : super(key: key);

  @override
  _ClienteOrdenesMapaPageState createState() => _ClienteOrdenesMapaPageState();
}

class _ClienteOrdenesMapaPageState extends State<ClienteOrdenesMapaPage> {
  ClienteOrdenesMapaController _obj = new ClienteOrdenesMapaController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _obj.init(context, refresh);
    });
    refresh();
  }

  @override
  void dispose() {
    super.dispose();
    _obj.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ubicación del cliente.'),
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.49,
            child: _mapaGoogle(),
          ),
          SafeArea(
            child: Column(
              children: [
                Spacer(),
                _tarjetaOrdenInfo(),
              ],
            ),
          ),
          Positioned(
            child: _iconGoogleMaps(),
          ),
        ],
      ),
    );
  }

  Widget _iconGoogleMaps() {
    return GestureDetector(
      onTap: _obj.launchGoogleMaps,
      child: Container(
        child: Image.asset('assets/img/google_maps.png'),
        width: 40,
        height: 40,
      ),
    );
  }

  Widget _tarjetaOrdenInfo() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _listaTitulo(
                _obj.orden?.address?.town, 'Pueblo', Icons.my_location),
            _listaTitulo(
                _obj.orden?.address?.address, 'Dirección', Icons.location_on),
            Divider(
              color: Colors.grey[400],
              endIndent: 30,
              indent: 30,
            ),
            _clienteInfo(),
            Container(
              alignment: Alignment.bottomCenter,
              child: _btnEntregar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _clienteInfo() {
    refresh();
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 35),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            child: FadeInImage(
              placeholder: AssetImage('assets/img/no-image.png'),
              fit: BoxFit.contain,
              fadeInDuration: Duration(milliseconds: 50),
              image: _obj.orden?.client?.image != null
                  ? NetworkImage(_obj.orden?.client?.image)
                  : AssetImage('assets/img/no-image.png'),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Text(
              '${_obj.orden?.client?.name ?? ''} ${_obj.orden?.client?.lastname ?? ''}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              maxLines: 1,
            ),
          ),
          Spacer(),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Colors.grey,
            ),
            child: IconButton(
              onPressed: () {
                launch("tel:${_obj.orden?.client?.phone ?? ''}");
              },
              icon: Icon(
                Icons.phone,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _listaTitulo(String titulo, String subTitulo, IconData icon) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: ListTile(
        title: Text(
          titulo ?? '',
          style: TextStyle(
            fontSize: 13,
          ),
        ),
        subtitle: Text(subTitulo),
        trailing: Icon(icon),
      ),
    );
  }

  Widget _btnEntregar() {
    return Container(
      margin: EdgeInsets.only(
        left: 30,
        right: 30,
      ),
      child: ElevatedButton(
        onPressed: _obj.updateDelivered,
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          primary: MyColors.primaryColor,
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 50,
                alignment: Alignment.center,
                child: Text(
                  'ENTREGAR ORDEN.',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(left: 20, top: 10),
                height: 20,
                child: Icon(Icons.check),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _mapaGoogle() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _obj.posicionIncial,
      onMapCreated: _obj.onMapCrear,
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      markers: Set<Marker>.of(_obj.markers.values),
      polylines: _obj.polylines,
    );
  }

  void refresh() {
    if (!mounted) return;
    setState(() {});
  }
}
