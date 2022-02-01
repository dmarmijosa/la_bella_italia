import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:la_bella_italia/src/models/orden.dart';
import 'package:la_bella_italia/src/pages/restaurante/ordenes/lista/restaurante_ordenes_lista_controller.dart';
import 'package:la_bella_italia/src/utils/my_colors.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:la_bella_italia/src/utils/relative_time_util.dart';
import 'package:la_bella_italia/src/widgets/no_data_widget.dart';

class RestauranteOrdenesListaPage extends StatefulWidget {
  const RestauranteOrdenesListaPage({key}) : super(key: key);

  @override
  _RestauranteOrdenesListaPageState createState() =>
      _RestauranteOrdenesListaPageState();
}

class _RestauranteOrdenesListaPageState
    extends State<RestauranteOrdenesListaPage> {
  RestauranteOrdenesListaController _crolc =
      new RestauranteOrdenesListaController();

  @override
  // ignore: must_call_super
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _crolc.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: DefaultTabController(
        length: _crolc.status?.length,
        child: Scaffold(
          key: _crolc.key,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(100),
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              flexibleSpace: Column(
                children: [
                  SizedBox(height: 40),
                  _menuDraver(),
                  SizedBox(height: 20),
                ],
              ),
              bottom: TabBar(
                indicatorColor: Colors.black,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey[400],
                isScrollable: true,
                tabs: List<Widget>.generate(
                  _crolc.status.length,
                  (index) {
                    return Tab(
                      child: Text(_crolc.status[index] ?? ''),
                    );
                  },
                ),
              ),
            ),
          ),
          drawer: _drawer(),
          body: TabBarView(
            children: _crolc.status.map((String status) {
              return FutureBuilder(
                  future: _crolc.obtenerOrdenes(status),
                  builder: (context, AsyncSnapshot<List<Orden>> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.length > 0) {
                        return ListView.builder(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            itemCount: snapshot.data?.length ?? 0,
                            itemBuilder: (_, index) {
                              print(snapshot.data[index].toJson());
                              return _tarjetaOrden(snapshot.data[index]);
                            });
                      } else {
                        return NoDataWidget(texto: 'No hay ordenes');
                      }
                    } else {
                      return NoDataWidget(texto: 'No hay ordenes');
                    }
                  });
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _tarjetaOrden(Orden orden) {
    return GestureDetector(
      onTap: () {
        _crolc.abrirSheet(orden);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        height: 160,
        child: Card(
          elevation: 3.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Stack(
            children: [
              Positioned(
                child: Container(
                  height: 30,
                  width: MediaQuery.of(context).size.width * 1,
                  decoration: BoxDecoration(
                    color: MyColors.primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      'ORDEN ${orden.id}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 40, left: 20, right: 20),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        'Pedido: ${RelativeTimeUtil.getRelativeTime(orden.timestamp)}',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    orden.status != 'CREADA'
                        ? Container(
                            alignment: Alignment.centerLeft,
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              'Repartidor: ${orden.delivery?.name ?? ''} ${orden.delivery?.lastname ?? ''}',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          )
                        : Container(),
                    Container(
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        'Cliente: ${orden.client.name}',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                        maxLines: 1,
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        'Entregar en: ${orden.address.address}',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuDraver() {
    return GestureDetector(
      onTap: _crolc.openDrawer,
      child: Container(
        margin: EdgeInsets.only(left: 20),
        alignment: Alignment.centerLeft,
        child: Icon(
          Icons.menu,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _drawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: MyColors.primaryColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 60,
                  margin: EdgeInsets.only(top: 10, bottom: 4),
                  child: FadeInImage(
                    image: _crolc.user?.image != null
                        ? NetworkImage(_crolc.user.image)
                        : AssetImage('assets/img/no-image.png'),
                    fit: BoxFit.contain,
                    fadeInDuration: Duration(milliseconds: 50),
                    placeholder: AssetImage('assets/img/no-image.png'),
                  ),
                ),
                Text(
                  '${_crolc.user?.name ?? ''} ${_crolc.user?.lastname ?? ''}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                ),
                Text(
                  '${_crolc.user?.email ?? ''}',
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                  maxLines: 1,
                ),
                Text(
                  '${_crolc.user?.phone ?? ''}',
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                  maxLines: 1,
                ),
              ],
            ),
          ),
          Container(
            child: FlutterSwitch(
              width: 125.0,
              height: 55.0,
              valueFontSize: 25.0,
              toggleSize: 45.0,
              value: _crolc.abiertoOCerrado,
              borderRadius: 30.0,
              padding: 8.0,
              showOnOff: true,
              onToggle: (val) {
                setState(() {
                  _crolc.abiertoOCerrado = val;
                  _crolc.actualizarEstado();
                });
              },
            ),
          ),
          ListTile(
            onTap: _crolc.irACrearProducto,
            title: Text('Crear producto'),
            trailing: Icon(
              Icons.create,
              color: Colors.black,
            ),
          ),
          ListTile(
            onTap: _crolc.irACrearCategoria,
            title: Text('Crear categoría'),
            trailing: Icon(
              Icons.create_new_folder,
              color: Colors.black,
            ),
          ),
          _crolc.user != null
              ? _crolc.user.roles.length > 1
                  ? ListTile(
                      title: Text('Cambiar de rol'),
                      onTap: _crolc.cambiarRol,
                      trailing: Icon(
                        Icons.sync,
                        color: Colors.black,
                      ),
                    )
                  : Container()
              : Container(),
          ListTile(
            onTap: _crolc.logout,
            title: Text('Cerrar sesión'),
            trailing: Icon(
              Icons.login_rounded,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  void refresh() {
    setState(
      () {},
    );
  }
}
