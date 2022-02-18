import 'package:flutter/material.dart';
import 'package:la_bella_italia/src/models/order.dart';
import 'package:la_bella_italia/src/models/response_api.dart';
import 'package:la_bella_italia/src/models/user.dart';
import 'package:la_bella_italia/src/pages/restaurante/ordenes/detalle/restaurante_ordenes_detalle_page.dart';
import 'package:la_bella_italia/src/providers/order_provider.dart';
import 'package:la_bella_italia/src/providers/user_provider.dart';
import 'package:la_bella_italia/src/utils/UtilsApp.dart';
import 'package:la_bella_italia/src/utils/shared_pref.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class RestauranteOrdenesListaController {
  BuildContext context;
  SharedPref _sharedPref = new SharedPref();
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  User user;

  Function refresh;
  UserProvider _userProvider = new UserProvider();
  OrderProvider _orderProvider = new OrderProvider();
  bool estado = false;
  bool abiertoOCerrado = true;

  List<String> status = [
    'CREADA',
    'DESPACHADA',
    'EN CAMINO',
    'ENTREGADA',
    'CANCELADA'
  ];

  Future init(BuildContext context, Function refresh) async {
    this.context = context;

    this.refresh = refresh;

    UtilsApp utilsApp = new UtilsApp();
    if (await utilsApp.internetConnectivity() == false) {
      Navigator.pushNamed(context, 'desconectado');
    }
    user = User.fromJson(await _sharedPref.read('user') ?? {});
    _orderProvider.init(context, user);
    abiertoOCerrado = await _userProvider.restaurantIsAvaiable();

    refresh();
  }

  Future<List<Order>> obtenerOrdenes(String status) async {
    return await _orderProvider.getByStatus(status);
  }

  void abrirSheet(Order orden) async {
    estado = await showMaterialModalBottomSheet(
      context: context,
      builder: (context) => RestauranteOrdenesDetallePage(
        orden: orden,
      ),
    );
    refresh();

    try {
      if (estado) {
        refresh();
      }
    } catch (e) {
      print(e);
    }
  }

  void actualizarEstado() async {
    ResponseApi responseApi = await _userProvider.setValorRestaurant(user.id);

    Fluttertoast.showToast(msg: responseApi.message);
    print(responseApi.message);
  }

  void logout() {
    _sharedPref.logout(context, user.id);
  }

  void openDrawer() {
    key.currentState.openDrawer();
  }

  void irAAdministarCategoria() {
    Navigator.pushNamed(context, 'restaurante/categorias/opciones');
  }

  void irAAdministrarMensajeros() {
    Navigator.pushNamed(context, 'restaurante/mensajeros/opciones');
  }

  void irAAdministarProducto() {
    //Navigator.pushNamed(context, 'restaurante/producto/crear');
    Navigator.pushNamed(context, 'restaurante/productos/opciones');
  }

  void cambiarRol() {
    Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
  }
}
