import 'package:flutter/material.dart';

import 'package:la_bella_italia/src/pages/cliente/actualizar/cliente_actualizar_page.dart';
import 'package:la_bella_italia/src/pages/cliente/direcciones/crear/cliente_direcciones_crear_page.dart';
import 'package:la_bella_italia/src/pages/cliente/direcciones/eliminar/cliente_direcciones_eliminar_page.dart';

import 'package:la_bella_italia/src/pages/cliente/direcciones/lista/cliente_direcciones_lista_page.dart';
import 'package:la_bella_italia/src/pages/cliente/direcciones/mapa/cliente_direcciones_mapa_page.dart';
import 'package:la_bella_italia/src/pages/cliente/estado/cliente_estado_page.dart';
import 'package:la_bella_italia/src/pages/cliente/ordenes/crear/cliente_ordenes_crear_page.dart';
import 'package:la_bella_italia/src/pages/cliente/ordenes/lista/cliente_ordenes_lista_page.dart';
import 'package:la_bella_italia/src/pages/cliente/ordenes/mapa/cliente_ordenes_mapa_page.dart';
import 'package:la_bella_italia/src/pages/cliente/productos/lista/cliente_producto_lista_page.dart';
import 'package:la_bella_italia/src/pages/delivery/ordenes/lista/delivery_ordenes_lista_page.dart';
import 'package:la_bella_italia/src/pages/delivery/ordenes/mapa/delivery_ordenes_mapa_page.dart';
import 'package:la_bella_italia/src/pages/login/login_page.dart';
import 'package:la_bella_italia/src/pages/login/recuperarCuenta/recuperar_cuenta_page.dart';
import 'package:la_bella_italia/src/pages/registro/registro_page.dart';
import 'package:la_bella_italia/src/pages/restaurante/categorias/crear/restaurante_categorias_crear_page.dart';
import 'package:la_bella_italia/src/pages/restaurante/ordenes/detalle/restaurante_ordenes_detalle_page.dart';

import 'package:la_bella_italia/src/pages/restaurante/ordenes/lista/restaurante_ordenes_lista_page.dart';
import 'package:la_bella_italia/src/pages/restaurante/productos/crear/restaurante_productos_crear_page.dart';
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
        'recuperar': (BuildContext context) => RecuperarCuentaPage(),
        'roles': (BuildContext context) => RolesPage(),
        'cliente/productos/lista': (BuildContext context) =>
            ClienteProductoListaPage(),
        'cliente/actualizar': (BuildContext context) => ClienteActualizarPage(),
        'cliente/ordenes/crear': (BuildContext context) =>
            ClienteOrdenesCrearPage(),
        'cliente/ordenes/lista': (BuildContext context) =>
            ClienteOrdenesListaPage(),
        'cliente/ordenes/mapa': (BuildContext context) =>
            ClienteOrdenesMapaPage(),
        'cliente/direcciones/lista': (BuildContext context) =>
            ClienteDireccionesListaPage(),
        'cliente/direcciones/crear': (BuildContext context) =>
            ClienteDireccionesCrearPage(),
        'cliente/direcciones/eliminar': (BuildContext context) =>
            ClienteDireccionesEliminarPage(),
        'cliente/direcciones/mapa': (BuildContext context) =>
            ClienteDireccionesMapaPage(),
        'cliente/estado': (BuildContext context) => ClienteEstadoPage(),
        'delivery/ordenes/lista': (BuildContext context) =>
            DeliveryOrdenesListaPage(),
        'delivery/ordenes/mapa': (BuildContext context) =>
            DeliveryOrdenesMapaPage(),
        'restaurante/ordenes/lista': (BuildContext context) =>
            RestauranteOrdenesListaPage(),
        'restaurante/categorias/crear': (BuildContext context) =>
            RestauranteCategoriasCrearPage(),
        'restaurante/producto/crear': (BuildContext context) =>
            RestauranteProductosCrearPage(),
        'restaurante/ordenes/detalle': (BuildContext context) =>
            RestauranteOrdenesDetallePage(
              orden: null,
            ),
      },
      theme: ThemeData(
        primaryColor: MyColors.primaryColor,
        appBarTheme: AppBarTheme(elevation: 0),
      ),
    );
  }
}
