import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:la_bella_italia/src/pages/delivery/ordenes/mapa/delivery_ordenes_mapa_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:la_bella_italia/src/utils/my_colors.dart';

import 'package:url_launcher/url_launcher.dart';

class DeliveryOrdenesMapaPage extends StatefulWidget {
  const DeliveryOrdenesMapaPage({key}) : super(key: key);

  @override
  _DeliveryOrdenesMapaPageState createState() =>
      _DeliveryOrdenesMapaPageState();
}

class _DeliveryOrdenesMapaPageState extends State<DeliveryOrdenesMapaPage> {
  DeliveryOrdenesMapaController _ccdmc = new DeliveryOrdenesMapaController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _ccdmc.init(context, refresh);
    });
    refresh();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _ccdmc.dispose();
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
          )
        ],
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
      child: Column(
        children: [
          _listaTitulo(
              _ccdmc.orden?.address?.town, 'Pueblo', Icons.my_location),
          _listaTitulo(
              _ccdmc.orden?.address?.address, 'Dirección', Icons.location_on),
          Divider(
            color: Colors.grey[400],
            endIndent: 30,
            indent: 30,
          ),
          _clienteInfo(),
          Container(
            alignment: Alignment.bottomCenter,
            child: _btnSeleccionar(),
          ),
        ],
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
              image: _ccdmc.orden?.client?.image != null
                  ? NetworkImage(_ccdmc.orden?.client?.image)
                  : AssetImage('assets/img/no-image.png'),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Text(
              '${_ccdmc.orden?.client?.name ?? ''} ${_ccdmc.orden?.client?.lastname ?? ''}',
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
                launch("tel:${_ccdmc.orden?.client?.phone ?? ''}");
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

  Widget _btnSeleccionar() {
    return Container(
      margin: EdgeInsets.only(
        left: 30,
        right: 30,
      ),
      child: ElevatedButton(
        onPressed: () {},
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
                child: Icon(Icons.people_alt_rounded),
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
      initialCameraPosition: _ccdmc.posicionIncial,
      onMapCreated: _ccdmc.onMapCrear,
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      markers: Set<Marker>.of(_ccdmc.markers.values),
      polylines: _ccdmc.polylines,
    );
  }

  void refresh() {
    if (!mounted) return;
    setState(() {});
  }
}
