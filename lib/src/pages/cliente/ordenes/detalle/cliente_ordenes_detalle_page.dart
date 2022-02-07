import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:la_bella_italia/src/models/orden.dart';
import 'package:la_bella_italia/src/models/producto.dart';
import 'package:la_bella_italia/src/pages/cliente/ordenes/detalle/cliente_ordenes_detalle_controller.dart';
import 'package:la_bella_italia/src/utils/relative_time_util.dart';
import 'package:la_bella_italia/src/widgets/no_data_widget.dart';

// ignore: must_be_immutable
class ClienteOrdenesDetallePage extends StatefulWidget {
  Orden orden;

  ClienteOrdenesDetallePage({key, @required this.orden}) : super(key: key);
  @override
  _ClienteOrdenesDetallePageState createState() =>
      _ClienteOrdenesDetallePageState();
}

class _ClienteOrdenesDetallePageState extends State<ClienteOrdenesDetallePage> {
  ClienteOrdenesDetalleController _obj = new ClienteOrdenesDetalleController();
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _obj.init(context, refresh, widget.orden);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                    'Repartidor : ',
                    '${_obj.orden?.delivery?.name ?? 'No asignado'} ${_obj.orden?.delivery?.lastname ?? ''}',
                    '${_obj.orden?.delivery?.phone ?? ''}'),
                _obj.orden?.status == 'CREADA' ||
                        _obj.orden?.status == 'DESPACHADA'
                    ? _txtNombreResturanteLlamar(
                        'Restaurante : ',
                        '${_obj.restaurante?.name ?? 'No asignado'} ${_obj.restaurante?.lastname ?? ''}',
                        '${_obj.restaurante?.phone ?? ''}')
                    : Container(),
                _txtDatosCliente(
                    'Entregar en : ', '${_obj.orden?.address?.address ?? ''} '),
                _txtDatosCliente('Creada : ',
                    '${RelativeTimeUtil.getRelativeTime(_obj.orden?.timestamp ?? 0) ?? ''} '),
                _txtPRecioTotal(),
                _obj.orden?.status == 'EN CAMINO'
                    ? _btnDespacharOrden()
                    : Container(),
              ],
            ),
          )),
      body: (_obj.orden?.products?.length ?? 0) > 0
          ? ListView(
              children: _obj.orden?.products?.map(
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
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text(titulo),
        subtitle: Text(
          contenido,
          maxLines: 2,
        ),
        trailing:
            _obj.orden?.status != 'CREADA' && _obj.orden?.status != 'ENTREGADA'
                ? Wrap(
                    spacing: 12, // space between two icons
                    children: <Widget>[
                      IconButton(
                          icon: Icon(Icons.call),
                          onPressed: () {
                            _obj.llamar(numero ?? '');
                          })
                    ],
                  )
                : null,
      ),
    );
  }

  Widget _txtNombreResturanteLlamar(
      String titulo, String contenido, String numero) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text(titulo),
        subtitle: Text(
          contenido,
          maxLines: 2,
        ),
        trailing:
            _obj.orden?.status == 'CREADA' || _obj.orden?.status == 'DESPACHADA'
                ? Wrap(
                    spacing: 12, // space between two icons
                    children: <Widget>[
                      IconButton(
                          icon: Icon(Icons.call),
                          onPressed: () {
                            _obj.llamar(numero ?? '');
                          })
                    ],
                  )
                : null,
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
          _obj.orden.status == 'DESPACHADA'
              ? _obj.updateOrden()
              : _obj.irAMapa();
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
                  _obj.orden?.status == 'DESPACHADA'
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
                child: _obj.orden?.status == 'DESPACHADA'
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
            '${_obj.total}\€',
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
