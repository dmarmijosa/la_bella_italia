import 'package:flutter/material.dart';

import 'package:flutter/scheduler.dart';
import 'package:la_bella_italia/src/pages/cliente/productos/lista/cliente_producto_lista_controller.dart';
import 'package:la_bella_italia/src/utils/my_colors.dart';

class ClienteProductoListaPage extends StatefulWidget {
  const ClienteProductoListaPage({key}) : super(key: key);

  @override
  _ClienteProductoListaPageState createState() =>
      _ClienteProductoListaPageState();
}

class _ClienteProductoListaPageState extends State<ClienteProductoListaPage> {
  ClienteProductoListaController _cplc = new ClienteProductoListaController();

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _cplc.init(context, refresh);
      refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _cplc.key,
      appBar: AppBar(
        leading: _menuDraver(),
      ),
      drawer: _drawer(),
      body: Center(
        child: ElevatedButton(
          onPressed: _cplc.logout,
          child: Text('Cerrar Sessión'),
        ),
      ),
    );
  }

  Widget _menuDraver() {
    return GestureDetector(
      onTap: _cplc.openDrawer,
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
                    image: _cplc.user?.image != null
                        ? NetworkImage(_cplc.user.image)
                        : AssetImage('assets/img/no-image.png'),
                    fit: BoxFit.contain,
                    fadeInDuration: Duration(milliseconds: 50),
                    placeholder: AssetImage('assets/img/no-image.png'),
                  ),
                ),
                Text(
                  '${_cplc.user?.name ?? ' '} ${_cplc.user?.lastname ?? ' '} ',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                ),
                Text(
                  '${_cplc.user?.email ?? ''}',
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                  maxLines: 1,
                ),
                Text(
                  '${_cplc.user?.phone ?? ''}',
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
            onTap: _cplc.editarPerfil,
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
          _cplc.user != null
              ? _cplc.user.roles.length > 1
                  ? ListTile(
                      title: Text('Cambiar de rol'),
                      onTap: _cplc.cambiarROl,
                      trailing: Icon(
                        Icons.sync,
                        color: Colors.black,
                      ),
                    )
                  : Container()
              : Container(),
          ListTile(
            onTap: _cplc.logout,
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
