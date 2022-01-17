import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:la_bella_italia/src/pages/delivery/ordenes/lista/delivery_ordenes_lista_controller.dart';
import 'package:la_bella_italia/src/utils/my_colors.dart';

class DeliveryOrdenesListaPage extends StatefulWidget {
  const DeliveryOrdenesListaPage({key}) : super(key: key);

  @override
  _DeliveryOrdenesListaPageState createState() =>
      _DeliveryOrdenesListaPageState();
}

class _DeliveryOrdenesListaPageState extends State<DeliveryOrdenesListaPage> {
  DeliveryOrdenesListaController _cdolc = new DeliveryOrdenesListaController();

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _cdolc.init(context, refresh);
      refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _cdolc.key,
      appBar: AppBar(
        leading: _menuDraver(),
      ),
      drawer: _drawer(),
      body: Center(
        child: Text('delivery list'),
      ),
    );
  }

  Widget _menuDraver() {
    return GestureDetector(
      onTap: _cdolc.openDrawer,
      child: Container(
        margin: EdgeInsets.only(left: 20),
        alignment: Alignment.centerLeft,
        child: Icon(Icons.menu),
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
                    image: AssetImage('assets/img/no-image.png'),
                    fit: BoxFit.contain,
                    fadeInDuration: Duration(milliseconds: 50),
                    placeholder: AssetImage('assets/img/no-image.png'),
                  ),
                ),
                Text(
                  '${_cdolc.user?.name ?? ''} ${_cdolc.user?.lastname ?? ''}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                ),
                Text(
                  '${_cdolc.user?.email ?? ''}',
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                  maxLines: 1,
                ),
                Text(
                  '${_cdolc.user?.phone ?? ''}',
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
          ListTile(
            title: Text('Editar perfil'),
            trailing: Icon(
              Icons.edit,
              color: Colors.black,
            ),
          ),
          ListTile(
            title: Text('Mis pedidos'),
            trailing: Icon(
              Icons.shopping_bag,
              color: Colors.black,
            ),
          ),
          _cdolc.user != null
              ? _cdolc.user.roles.length > 1
                  ? ListTile(
                      title: Text('Cambiar de rol'),
                      onTap: _cdolc.cambiarROl,
                      trailing: Icon(
                        Icons.sync,
                        color: Colors.black,
                      ),
                    )
                  : Container()
              : Container(),
          ListTile(
            onTap: _cdolc.logout,
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
