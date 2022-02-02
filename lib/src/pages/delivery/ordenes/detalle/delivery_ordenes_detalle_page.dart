import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:la_bella_italia/src/models/orden.dart';
import 'package:la_bella_italia/src/models/producto.dart';
import 'package:la_bella_italia/src/models/user.dart';
import 'package:la_bella_italia/src/utils/my_colors.dart';
import 'package:la_bella_italia/src/pages/delivery/ordenes/detalle/delivery_ordenes_detalle_controller.dart';
import 'package:la_bella_italia/src/utils/relative_time_util.dart';
import 'package:la_bella_italia/src/widgets/no_data_widget.dart';

// ignore: must_be_immutable
class DeliveryOrdenesDetallePage extends StatefulWidget {
  Orden orden;

  DeliveryOrdenesDetallePage({key, @required this.orden}) : super(key: key);
  @override
  _DeliveryOrdenesDetallePageState createState() =>
      _DeliveryOrdenesDetallePageState();
}

class _DeliveryOrdenesDetallePageState
    extends State<DeliveryOrdenesDetallePage> {
  DeliveryOrdenesDetalleController _crodc =
      new DeliveryOrdenesDetalleController();
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
          height: MediaQuery.of(context).size.height * 0.45,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Divider(
                  color: Colors.grey[400],
                  endIndent: 30,
                  indent: 30,
                ),
                _txtNombreClienteLlamar(
                    'Cliente : ',
                    '${_crodc.orden?.client?.name ?? ''} ${_crodc.orden?.client?.lastname ?? ''}',
                    '${_crodc.orden?.client?.phone ?? ''}'),
                _txtDatosCliente('Entregar en : ',
                    '${_crodc.orden?.address?.address ?? ''} '),
                _txtDatosCliente('Creada : ',
                    '${RelativeTimeUtil.getRelativeTime(_crodc.orden?.timestamp ?? 0) ?? ''} '),
                _txtPRecioTotal(),
                _btnDespacharOrden(),
              ],
            ),
          )),
      body: (_crodc.orden?.products?.length ?? 0) > 0
          ? ListView(
              children: _crodc.orden?.products?.map(
                (Producto producto) {
                  return _tarjetaProducto(producto);
                },
              )?.toList(),
            )
          : NoDataWidget(
              texto: 'Ningun producto agregado',
            ),
    );
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
        top: 20,
      ),
      child: ElevatedButton(
        //_crodc.updateOrden
        onPressed: () {
          _crodc.orden.status == 'DESPACHADA'
              ? _crodc.updateOrden()
              : _crodc.irAMapa();
        },
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          primary: Colors.blue[600],
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 50,
                alignment: Alignment.center,
                child: Text(
                  _crodc.orden?.status == 'DESPACHADA'
                      ? 'INCIAR ENTREGA'
                      : 'VER MAPA',
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
                child: _crodc.orden?.status == 'DESPACHADA'
                    ? Icon(Icons.delivery_dining)
                    : Icon(Icons.location_on),
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
