import 'package:flutter/material.dart';

import 'package:flutter/scheduler.dart';
import 'package:la_bella_italia/src/models/categoria.dart';
import 'package:la_bella_italia/src/models/producto.dart';
import 'package:la_bella_italia/src/pages/cliente/productos/lista/cliente_producto_lista_controller.dart';
import 'package:la_bella_italia/src/utils/my_colors.dart';
import 'package:la_bella_italia/src/widgets/no_data_widget.dart';

class ClienteProductoListaPage extends StatefulWidget {
  const ClienteProductoListaPage({key}) : super(key: key);

  @override
  _ClienteProductoListaPageState createState() =>
      _ClienteProductoListaPageState();
}

class _ClienteProductoListaPageState extends State<ClienteProductoListaPage> {
  ClienteProductoListaController _obj = new ClienteProductoListaController();

  @override
  // ignore: must_call_super
  void initState() async {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _obj.init(context, refresh);
      refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: DefaultTabController(
        length: _obj.categorias?.length,
        child: Scaffold(
          key: _obj.key,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(170),
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              actions: [
                _menuShopping(),
              ],
              flexibleSpace: Column(
                children: [
                  SizedBox(height: 40),
                  _menuDraver(),
                  SizedBox(height: 20),
                  _edtBuscar(),
                ],
              ),
              bottom: TabBar(
                indicatorColor: Colors.black,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey[400],
                isScrollable: true,
                tabs: List<Widget>.generate(
                  _obj.categorias.length,
                  (index) {
                    return Tab(
                      child: Text(_obj.categorias[index].name ?? ''),
                    );
                  },
                ),
              ),
            ),
          ),
          drawer: _drawer(),
          body: TabBarView(
            children: _obj.categorias.map(
              (Categoria categoria) {
                return FutureBuilder(
                  future: _obj.obtenerProductos(categoria.id),
                  builder: (context, AsyncSnapshot<List<Producto>> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.length > 0) {
                        return GridView.builder(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                          ),
                          itemCount: snapshot.data?.length ?? 0,
                          itemBuilder: (_, index) {
                            return _tarjetaProducto(snapshot.data[index]);
                          },
                        );
                      } else {
                        return NoDataWidget(
                          texto: 'No hay productos',
                        );
                      }
                    } else {
                      return NoDataWidget(
                        texto: 'No hay productos',
                      );
                    }
                  },
                );
              },
            ).toList(),
          ),
        ),
      ),
    );
  }

  Widget _tarjetaProducto(Producto producto) {
    return GestureDetector(
      onTap: () {
        _obj.mostrarSheet(producto);
      },
      child: Container(
        height: 250,
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -1,
                right: -1,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: MyColors.primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 150,
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: FadeInImage(
                      placeholder: AssetImage('assets/img/pizza2.png'),
                      fit: BoxFit.contain,
                      fadeInDuration: Duration(milliseconds: 50),
                      image: producto.image1 != null
                          ? NetworkImage(producto.image1)
                          : AssetImage('assets/img/pizza2.png'),
                    ),
                  ),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    height: 33,
                    child: Text(
                      producto.name.toUpperCase() ?? 'PRODUCTO',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      '${producto.price ?? 0}\€',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuShopping() {
    return Stack(
      children: [
        Container(
            margin: EdgeInsets.only(right: 5, top: 5),
            child: IconButton(
              onPressed: _obj.irACrearOrdenPage,
              icon: Icon(
                Icons.shopping_bag_outlined,
                color: Colors.black,
              ),
            )),
        Positioned(
          right: 16,
          bottom: 30,
          child: Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(Radius.circular(30))),
          ),
        )
      ],
    );
  }

  Widget _edtBuscar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Buscar',
          suffixIcon: Icon(
            Icons.search,
            color: Colors.grey[400],
          ),
          hintStyle: TextStyle(
            fontSize: 17,
            color: Colors.grey[500],
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: Colors.grey[300]),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: Colors.grey[300]),
          ),
          contentPadding: EdgeInsets.all(15),
        ),
      ),
    );
  }

  Widget _menuDraver() {
    return GestureDetector(
      onTap: _obj.openDrawer,
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
                    image: _obj.user?.image != null
                        ? NetworkImage(_obj.user.image)
                        : AssetImage('assets/img/no-image.png'),
                    fit: BoxFit.contain,
                    fadeInDuration: Duration(milliseconds: 50),
                    placeholder: AssetImage('assets/img/no-image.png'),
                  ),
                ),
                Text(
                  '${_obj.user?.name ?? ' '} ${_obj.user?.lastname ?? ' '} ',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                ),
                Text(
                  '${_obj.user?.email ?? ''}',
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                  maxLines: 1,
                ),
                Text(
                  '${_obj.user?.phone ?? ''}',
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
            onTap: _obj.editarPerfil,
            title: Text('Editar perfil'),
            trailing: Icon(
              Icons.edit,
              color: Colors.black,
            ),
          ),
          ListTile(
            onTap: _obj.irACrearOrdenPage,
            title: Text('Mis pedidos'),
            trailing: Icon(
              Icons.shopping_bag,
              color: Colors.black,
            ),
          ),
          ListTile(
            onTap: _obj.irAEliminarDirecciones,
            title: Text('Mis direcciones'),
            trailing: Icon(
              Icons.my_location_sharp,
              color: Colors.black,
            ),
          ),
          _obj.user != null
              ? _obj.user.roles.length > 1
                  ? ListTile(
                      title: Text('Cambiar de rol'),
                      onTap: _obj.cambiarROl,
                      trailing: Icon(
                        Icons.sync,
                        color: Colors.black,
                      ),
                    )
                  : Container()
              : Container(),
          ListTile(
            onTap: _obj.logout,
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
