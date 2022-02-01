import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:la_bella_italia/src/models/orden.dart';
import 'package:la_bella_italia/src/models/producto.dart';
import 'package:la_bella_italia/src/models/user.dart';
import 'package:la_bella_italia/src/pages/restaurante/ordenes/detalle/restaurante_ordenes_detalle_controller.dart';
import 'package:la_bella_italia/src/utils/my_colors.dart';
import 'package:la_bella_italia/src/utils/my_snackbar.dart';
import 'package:la_bella_italia/src/utils/relative_time_util.dart';
import 'package:la_bella_italia/src/widgets/no_data_widget.dart';

// ignore: must_be_immutable
class RestauranteOrdenesDetallePage extends StatefulWidget {
  Orden orden;

  RestauranteOrdenesDetallePage({key, @required this.orden}) : super(key: key);
  @override
  _RestauranteOrdenesDetallePageState createState() =>
      _RestauranteOrdenesDetallePageState();
}

class _RestauranteOrdenesDetallePageState
    extends State<RestauranteOrdenesDetallePage> {
  RestauranteOrdenesDetalleController _crodc =
      new RestauranteOrdenesDetalleController();
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _crodc.init(context, refresh, widget.orden);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ORDEN #${_crodc.orden?.id ?? ''} '),
      ),
      bottomNavigationBar: Container(
          height: MediaQuery.of(context).size.height * 0.5,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Divider(
                  color: Colors.grey[400],
                  endIndent: 30,
                  indent: 30,
                ),
                _txtRepartidor(),
                _crodc.orden.status != 'CREADA' ? _deliveryData() : Container(),
                _crodc.orden.status == 'CREADA'
                    ? _dropDown(_crodc.users)
                    : Container(),
                _txtNombreClienteLlamar(
                    'Cliente : ',
                    '${_crodc.orden.client?.name ?? ''} ${_crodc.orden.client?.lastname ?? ''}',
                    '${_crodc.orden.client?.phone ?? ''}'),
                _txtDatosCliente('Entregar en : ',
                    '${_crodc.orden.address?.address ?? ''} '),
                _txtDatosCliente('Creada : ',
                    '${RelativeTimeUtil.getRelativeTime(_crodc.orden.timestamp) ?? ''} '),
                _txtPRecioTotal(),
                _crodc.orden.status == 'CREADA'
                    ? _btnDespacharOrden()
                    : Container(),
              ],
            ),
          )),
      body: _crodc.orden.products.length > 0
          ? ListView(
              children: _crodc.orden.products.map(
                (Producto producto) {
                  return _tarjetaProducto(producto);
                },
              ).toList(),
            )
          : NoDataWidget(
              texto: 'Ningun producto agregado',
            ),
    );
  }

  Widget _txtRepartidor() {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(left: 30),
      child: Text(
        _crodc.orden.status == 'CREADA'
            ? 'Asignar repartidor: '
            : 'Repartidor asignado: ',
        style: TextStyle(
          color: Colors.red,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _dropDown(List<User> usuarios) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: Material(
        elevation: 2.0,
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: DropdownButton(
                  underline: Container(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.arrow_drop_down_circle,
                      color: MyColors.primaryColor,
                    ),
                  ),
                  elevation: 3,
                  isExpanded: true,
                  hint: Text(
                    'Seleccione repartidor',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  items: _dropDownItems(usuarios),
                  value: _crodc.idDelivery,
                  onChanged: (option) {
                    setState(() {
                      print('Repartidor seleccionda $option');
                      _crodc.idDelivery = option;
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _deliveryData() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              color: Colors.grey[200],
            ),
            child: FadeInImage(
              placeholder: AssetImage('assets/img/no-image.png'),
              fit: BoxFit.cover,
              fadeInDuration: Duration(milliseconds: 50),
              image: _crodc.orden.delivery?.image != null
                  ? NetworkImage(_crodc.orden.delivery?.image)
                  : AssetImage('assets/img/no-image.png'),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Text(
              '${_crodc.orden.delivery?.name} ${_crodc.orden.delivery?.lastname}'),
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItems(List<User> usuarios) {
    List<DropdownMenuItem<String>> list = [];
    usuarios.forEach((usuario) {
      list.add(DropdownMenuItem(
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                color: Colors.grey[200],
              ),
              child: FadeInImage(
                placeholder: AssetImage('assets/img/no-image.png'),
                fit: BoxFit.cover,
                fadeInDuration: Duration(milliseconds: 50),
                image: usuario.image != null
                    ? NetworkImage(usuario.image)
                    : AssetImage('assets/img/no-image.png'),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Text(usuario.name),
          ],
        ),
        value: usuario.id,
      ));
    });

    return list;
  }

  Widget _txtNombreClienteLlamar(
      String titulo, String contenido, String numero) {
    return GestureDetector(
      onTap: () {
        if (_crodc.orden.status == 'CREADA') {
          _crodc.llamarCliente();
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: ListTile(
          title: Text(titulo),
          subtitle: Text(
            contenido,
            maxLines: 2,
          ),
        ),
      ),
    );
  }

  Widget _txtDatosCliente(String titulo, String contenido) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text(titulo),
        subtitle: Text(
          contenido,
          maxLines: 2,
        ),
      ),
    );
  }

  Widget _btnDespacharOrden() {
    return Container(
      margin: EdgeInsets.only(
        left: 30,
        right: 30,
      ),
      child: ElevatedButton(
        onPressed: _crodc.updateOrden,
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
                  'DESPACHAR ORDEN.',
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
                child: Icon(Icons.done),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tarjetaProducto(Producto producto) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          _imagenProducto(producto),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                producto.name.toUpperCase() ?? '',
                style: (TextStyle(
                  fontWeight: FontWeight.bold,
                )),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Cantidad: ${producto.quantity}' ?? '',
                  style: (TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
                ),
              ),
              Text(
                'Detalles: ${producto.detail == null ? 'Ninguno' : producto.detail}' ??
                    'Ninguno',
                style: (TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                )),
                maxLines: 2,
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
          Spacer(),
          Column(
            children: [
              _txtPrecio(producto),
            ],
          )
        ],
      ),
    );
  }

  Widget _txtPRecioTotal() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          Text(
            '${_crodc.total}\€',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          )
        ],
      ),
    );
  }

  Widget _txtPrecio(Producto producto) {
    return Container(
      margin: EdgeInsets.only(top: 10, right: 10),
      child: Text(
        '${producto.price * producto.quantity} \€',
        style: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _imagenProducto(Producto producto) {
    return Container(
      width: 90,
      height: 90,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        color: Colors.grey[200],
      ),
      child: FadeInImage(
        placeholder: AssetImage('assets/img/no-image.png'),
        fit: BoxFit.contain,
        fadeInDuration: Duration(milliseconds: 50),
        image: producto.image1 != null
            ? NetworkImage(producto.image1)
            : AssetImage('assets/img/no-image.png'),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
