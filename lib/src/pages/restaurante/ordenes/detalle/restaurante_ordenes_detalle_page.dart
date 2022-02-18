import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:la_bella_italia/src/models/order.dart';
import 'package:la_bella_italia/src/models/product.dart';
import 'package:la_bella_italia/src/models/user.dart';
import 'package:la_bella_italia/src/pages/restaurante/ordenes/detalle/restaurante_ordenes_detalle_controller.dart';
import 'package:la_bella_italia/src/utils/my_colors.dart';

import 'package:la_bella_italia/src/utils/relative_time_util.dart';
import 'package:la_bella_italia/src/widgets/no_data_widget.dart';

// ignore: must_be_immutable
class RestauranteOrdenesDetallePage extends StatefulWidget {
  Order orden;

  RestauranteOrdenesDetallePage({key, @required this.orden}) : super(key: key);
  @override
  _RestauranteOrdenesDetallePageState createState() =>
      _RestauranteOrdenesDetallePageState();
}

class _RestauranteOrdenesDetallePageState
    extends State<RestauranteOrdenesDetallePage> {
  RestauranteOrdenesDetalleController _obj =
      new RestauranteOrdenesDetalleController();
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
        title: Text('ORDEN #${_obj.orden?.id ?? ''} '),
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
                _obj.orden?.status == 'CANCELADA'
                    ? Container()
                    : _txtRepartidor(),
                (_obj.orden?.status == 'EN CAMINO' ||
                        _obj.orden?.status == 'DESPACHADA')
                    ? _dropDownStatu(_obj.status)
                    : Container(),
                (_obj.orden?.status != 'CREADA' &&
                        _obj.orden?.status != 'CANCELADA' &&
                        _obj.orden?.delivery?.name != null)
                    ? _deliveryData()
                    : Container(),
                _obj.orden?.status == 'CREADA'
                    ? _dropDown(_obj.users)
                    : Container(),
                _txtNombreClienteLlamar('Cliente : ',
                    '${_obj.orden?.client?.name ?? ''} ${_obj.orden?.client?.lastname ?? ''}'),
                _txtDatosCliente(
                    'Entregar en : ', '${_obj.orden?.address?.address ?? ''} '),
                _txtDatosCliente('Creada : ',
                    '${RelativeTimeUtil.getRelativeTime(_obj.orden?.timestamp ?? 0) ?? ''} '),
                _txtPRecioTotal(),
                _obj.orden?.status == 'CREADA'
                    ? _btnDespacharOrden()
                    : Container(),
                (_obj.orden?.status == 'EN CAMINO' ||
                        _obj.orden?.status == 'DESPACHADA')
                    ? _btnCambioDeEstado()
                    : Container(),
              ],
            ),
          )),
      // ignore: null_aware_before_operator
      body: (_obj.orden?.products?.length ?? 0) > 0
          ? ListView(
              children: _obj.orden?.products?.map(
                (Product producto) {
                  return _tarjetaProducto(producto);
                },
              )?.toList(),
            )
          : NoDataWidget(
              text: 'Ningun producto agregado',
            ),
    );
  }

  Widget _txtRepartidor() {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(left: 30),
      child: Text(
        _obj.orden?.status == 'CREADA'
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

  Widget _dropDownStatu(List<String> status) {
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
                    'Seleccione estado',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  items: _dropDownStatus(status),
                  value: _obj.estado,
                  onChanged: (option) {
                    setState(() {
                      print('Repartidor seleccionda $option');
                      _obj.estado = option;
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
                  value: _obj.idDelivery,
                  onChanged: (option) {
                    setState(() {
                      print('Repartidor seleccionda $option');
                      _obj.idDelivery = option;
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
              image: _obj.orden?.delivery?.image != null
                  ? NetworkImage(_obj.orden?.delivery?.image)
                  : AssetImage('assets/img/no-image.png'),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Text(
              '${_obj.orden?.delivery?.name} ${_obj.orden?.delivery?.lastname}'),
          Spacer(),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Colors.grey,
            ),
            child: IconButton(
              onPressed: () {
                print(_obj.orden?.delivery?.phone);
                _obj.llamarTelefono(_obj.orden?.delivery?.phone);
              },
              icon: Icon(
                Icons.phone,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownStatus(List<String> status) {
    List<DropdownMenuItem<String>> list = [];
    status.forEach((statu) {
      list.add(DropdownMenuItem(
        child: Row(
          children: [
            SizedBox(
              width: 20,
            ),
            Text(statu),
          ],
        ),
        value: statu,
      ));
    });

    return list;
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

  Widget _txtNombreClienteLlamar(String titulo, String contenido) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Flexible(
            child: ListTile(
              title: Text(titulo),
              subtitle: Text(
                contenido,
                maxLines: 2,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Colors.grey,
            ),
            child: IconButton(
              onPressed: () {
                _obj.llamarTelefono(_obj.orden?.client?.phone);
              },
              icon: Icon(
                Icons.phone,
                color: Colors.white,
              ),
            ),
          )
        ],
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
        onPressed: _obj.updateOrden,
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

  Widget _btnCambioDeEstado() {
    return Container(
      margin: EdgeInsets.only(
        left: 30,
        right: 30,
      ),
      child: ElevatedButton(
        onPressed: () {
          if (_obj.estado == 'DESPACHADA') {
            _obj.updateToTheDispatchedBack();
          } else {
            if (_obj.estado == 'EN CAMINO') {
              _obj.updateOrdenToOnWay();
            } else {
              if (_obj.estado == 'ENTREGADA') {
                _obj.updateOrdenToDelivered();
              } else {
                if (_obj.estado == 'CANCELADA') {
                  _obj.updateOrdenToCancel();
                }
              }
            }
          }
        },
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
                  'CAMBIO DE ESTADO.',
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

  Widget _tarjetaProducto(Product producto) {
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

  Widget _txtPrecio(Product producto) {
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

  Widget _imagenProducto(Product producto) {
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
