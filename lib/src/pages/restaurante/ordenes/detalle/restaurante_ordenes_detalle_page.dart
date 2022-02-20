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
  Order order;

  RestauranteOrdenesDetallePage({key, @required this.order}) : super(key: key);
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
      _obj.init(context, refresh, widget.order);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ORDEN #${_obj.order?.id ?? ''} '),
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
                _obj.order?.status == 'CANCELADA'
                    ? Container()
                    : _txtInfoDelivery(),
                (_obj.order?.status == 'EN CAMINO' ||
                        _obj.order?.status == 'DESPACHADA')
                    ? _dropDownStatu(_obj.status)
                    : Container(),
                (_obj.order?.status != 'CREADA' &&
                        _obj.order?.status != 'CANCELADA' &&
                        _obj.order?.delivery?.name != null)
                    ? _deliveryData()
                    : Container(),
                _obj.order?.status == 'CREADA'
                    ? _dropDown(_obj.users)
                    : Container(),
                _txtInfoClient('Cliente : ',
                    '${_obj.order?.client?.name ?? ''} ${_obj.order?.client?.lastname ?? ''}'),
                _txtDataClient(
                    'Entregar en : ', '${_obj.order?.address?.address ?? ''} '),
                _txtDataClient('Creada : ',
                    '${RelativeTimeUtil.getRelativeTime(_obj.order?.timestamp ?? 0) ?? ''} '),
                _txtPriceTotal(),
                _obj.order?.status == 'CREADA'
                    ? _btnDispatchedOrder()
                    : Container(),
                (_obj.order?.status == 'EN CAMINO' ||
                        _obj.order?.status == 'DESPACHADA')
                    ? _btnChangeState()
                    : Container(),
              ],
            ),
          )),
      // ignore: null_aware_before_operator
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

  Widget _txtInfoDelivery() {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(left: 30),
      child: Text(
        _obj.order?.status == 'CREADA'
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
                  value: _obj.state,
                  onChanged: (option) {
                    setState(() {
                      print('Repartidor seleccionda $option');
                      _obj.state = option;
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

  Widget _dropDown(List<User> users) {
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
                  items: _dropDownItems(users),
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
              image: _obj.order?.delivery?.image != null
                  ? NetworkImage(_obj.order?.delivery?.image)
                  : AssetImage('assets/img/no-image.png'),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Text(
              '${_obj.order?.delivery?.name} ${_obj.order?.delivery?.lastname}'),
          Spacer(),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Colors.grey,
            ),
            child: IconButton(
              onPressed: () {
                print(_obj.order?.delivery?.phone);
                _obj.callPhone(_obj.order?.delivery?.phone);
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

  List<DropdownMenuItem<String>> _dropDownItems(List<User> users) {
    List<DropdownMenuItem<String>> list = [];
    users.forEach((usuario) {
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

  Widget _txtInfoClient(String title, String detail) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Flexible(
            child: ListTile(
              title: Text(title),
              subtitle: Text(
                detail,
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
                _obj.callPhone(_obj.order?.client?.phone);
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

  Widget _txtDataClient(String title, String detail) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text(title),
        subtitle: Text(
          detail,
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
      ),
      child: ElevatedButton(
        onPressed: _obj.updateOrder,
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

  Widget _btnChangeState() {
    return Container(
      margin: EdgeInsets.only(
        left: 30,
        right: 30,
      ),
      child: ElevatedButton(
        onPressed: () {
          if (_obj.state == 'DESPACHADA') {
            _obj.updateToTheDispatchedBack();
          } else {
            if (_obj.state == 'EN CAMINO') {
              _obj.updateOrderToOnWay();
            } else {
              if (_obj.state == 'ENTREGADA') {
                _obj.updateOrderToDelivered();
              } else {
                if (_obj.state == 'CANCELADA') {
                  _obj.updateOrderToCancel();
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

  Widget _targetProduct(Product product) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          _imageProduct(product),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name.toUpperCase() ?? '',
                style: (TextStyle(
                  fontWeight: FontWeight.bold,
                )),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Cantidad: ${product.quantity}' ?? '',
                  style: (TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
                ),
              ),
              Text(
                'Detalles: ${product.detail == null ? 'Ninguno' : product.detail}' ??
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
              _txtPrice(product),
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

  Widget _txtPrice(Product product) {
    return Container(
      margin: EdgeInsets.only(top: 10, right: 10),
      child: Text(
        '${product.price * product.quantity} \€',
        style: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _imageProduct(Product product) {
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
        image: product.image1 != null
            ? NetworkImage(product.image1)
            : AssetImage('assets/img/no-image.png'),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
