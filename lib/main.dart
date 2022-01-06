import 'package:flutter/material.dart';
import 'package:la_bella_italia/src/models/rol.dart';
import 'package:la_bella_italia/src/pages/cliente/productos/lista/cliente_producto_lista_page.dart';
import 'package:la_bella_italia/src/pages/delivery/ordenes/lista/delivery_ordenes_lista_page.dart';
import 'package:la_bella_italia/src/pages/login/login_page.dart';
import 'package:la_bella_italia/src/pages/registro/registro_page.dart';
import 'package:la_bella_italia/src/pages/restaurante/ordenes/lista/restaurante_ordenes_list_page.dart';
import 'package:la_bella_italia/src/pages/roles/roles_page.dart';
import 'package:la_bella_italia/src/utils/my_colors.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'La Bella Italia',
      debugShowCheckedModeBanner: false,
      initialRoute: 'login',
      routes: {
        'login': (BuildContext context) => LoginPage(),
        'registro': (BuildContext context) => Registro(),
        'roles': (BuildContext context) => RolesPage(),
        'cliente/productos/lista': (BuildContext context) =>
            ClienteProductoListaPage(),
        'delivery/ordenes/lista': (BuildContext context) =>
            DeliveryOrdenesListaPage(),
        'restaurante/ordenes/lista': (BuildContext context) =>
            RestauranteOrdenesListaPage(),
      },
      theme: ThemeData(
        primaryColor: MyColors.primaryColor,
      ),
    );
  }
}
