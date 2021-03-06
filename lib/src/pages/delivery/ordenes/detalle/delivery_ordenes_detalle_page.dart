import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:la_bella_italia/src/models/order.dart';
import 'package:la_bella_italia/src/models/product.dart';

import 'package:la_bella_italia/src/pages/delivery/ordenes/detalle/delivery_ordenes_detalle_controller.dart';
import 'package:la_bella_italia/src/utils/relative_time_util.dart';
import 'package:la_bella_italia/src/widgets/no_data_widget.dart';

// ignore: must_be_immutable
class DeliveryOrdenesDetallePage extends StatefulWidget {
  Order orden;

  DeliveryOrdenesDetallePage({key, @required this.orden}) : super(key: key);
  @override
  _DeliveryOrdenesDetallePageState createState() =>
      _DeliveryOrdenesDetallePageState();
}

class _DeliveryOrdenesDetallePageState
    extends State<DeliveryOrdenesDetallePage> {
  DeliveryOrdenesDetalleController _obj =
      new DeliveryOrdenesDetalleController();
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
      appBar: AppBar(
        title: Text('ORDEN #${_obj.order?.id ?? ''} '),
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
                _txtNameClientPhone(
                    'Cliente : ',
                    '${_obj.order?.client?.name ?? ''} ${_obj.order?.client?.lastname ?? ''}',
                    '${_obj.order?.client?.phone ?? ''}'),
                _txtDataClient(
                    'Entregar en : ', '${_obj.order?.address?.address ?? ''} '),
                _txtDataClient('Creada : ',
                    '${RelativeTimeUtil.getRelativeTime(_obj.order?.timestamp ?? 0) ?? ''} '),
                _txtPriceTotal(),
                _obj.order?.status != 'ENTREGADA'
                    ? _btnDispatchedOrder()
                    : Container(),
              ],
            ),
          )),
      body: (_obj.order?.products?.length ?? 0) > 0
          ? ListView(
              children: _obj.order?.products?.map(
                (Product producto) {
                  return _targetProduct(producto);
                },
              )?.toList(),
            )
          : NoDataWidget(
              text: 'Ningun producto agregado',
            ),
    );
  }

  Widget _txtNameClientPhone(String titulo, String contenido, String numero) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text(titulo),
        subtitle: Text(
          contenido,
          maxLines: 2,
        ),
        trailing: _obj.order?.status != 'ENTREGADA'
            ? Wrap(
                spacing: 12, // space between two icons
                children: <Widget>[
                  IconButton(
                      icon: Icon(Icons.call),
                      onPressed: () {
                        _obj.callPhone(_obj.order.client?.phone ?? '');
                      })
                ],
              )
            : null,
      ),
    );
  }

  Widget _txtDataClient(String titulo, String contenido) {
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

  Widget _btnDispatchedOrder() {
    return Container(
      margin: EdgeInsets.only(
        left: 30,
        right: 30,
        top: 20,
      ),
      child: ElevatedButton(
        //_crodc.updateOrden
        onPressed: () {
          _obj.order.status == 'DESPACHADA'
              ? _obj.updateOrder()
              : _obj.goToMap();
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
                  _obj.order?.status == 'DESPACHADA'
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
                child: _obj.order?.status == 'DESPACHADA'
                    ? Icon(Icons.delivery_dining)
                    : Icon(Icons.location_on),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _targetProduct(Product producto) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          _imageProduct(producto),
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
              _txtPrice(producto),
            ],
          )
        ],
      ),
    );
  }

  Widget _txtPriceTotal() {
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
            '${_obj.total}\???',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          )
        ],
      ),
    );
  }

  Widget _txtPrice(Product producto) {
    return Container(
      margin: EdgeInsets.only(top: 10, right: 10),
      child: Text(
        '${producto.price * producto.quantity} \???',
        style: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _imageProduct(Product producto) {
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
