import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:la_bella_italia/src/pages/restaurante/ordenes/lista/restaurante_ordenes_lista_controller.dart';
import 'package:la_bella_italia/src/utils/my_colors.dart';

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
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _crolc.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _crolc.key,
      appBar: AppBar(
        leading: _menuDraver(),
      ),
      drawer: _drawer(),
      body: Center(
        child: Text('Restaurant list'),
      ),
    );
  }

  Widget _menuDraver() {
    return GestureDetector(
      onTap: _crolc.openDrawer,
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
          _crolc.user != null
              ? _crolc.user.roles.length > 1
                  ? ListTile(
                      title: Text('Cambiar de rol'),
                      onTap: _crolc.cambiarROl,
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
