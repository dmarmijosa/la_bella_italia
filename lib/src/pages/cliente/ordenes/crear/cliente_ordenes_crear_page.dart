import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:la_bella_italia/src/models/product.dart';
import 'package:la_bella_italia/src/pages/cliente/ordenes/crear/cliente_ordenes_crear_controller.dart';
import 'package:la_bella_italia/src/utils/my_colors.dart';
import 'package:la_bella_italia/src/widgets/no_data_widget.dart';

class ClienteOrdenesCrearPage extends StatefulWidget {
  const ClienteOrdenesCrearPage({key}) : super(key: key);

  @override
  _ClienteOrdenesCrearPageState createState() =>
      _ClienteOrdenesCrearPageState();
}

class _ClienteOrdenesCrearPageState extends State<ClienteOrdenesCrearPage> {
  ClienteOrdenesCrearController _obj = new ClienteOrdenesCrearController();
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _obj.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi orden'),
      ),
      bottomNavigationBar: Container(
          height: MediaQuery.of(context).size.height * 0.23,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Divider(
                  color: Colors.grey[400],
                  endIndent: 30,
                  indent: 30,
                ),
                _txtPRecioTotal(),
                _btnConfirmarOrden()
              ],
            ),
          )),
      body: _obj.productosSeleccionados.length > 0
          ? ListView(
              children: _obj.productosSeleccionados.map(
                (Product producto) {
                  return _tarjetaProducto(producto);
                },
              ).toList(),
            )
          : NoDataWidget(
              text: 'Ningun producto agregado',
            ),
    );
  }

  Widget _btnConfirmarOrden() {
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 40),
      child: ElevatedButton(
        onPressed: _obj.irADirecciones,
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
                  'Confirmar compra.'.toUpperCase(),
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
                child: Icon(Icons.check_circle_sharp),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tarjetaProducto(Product producto) {
    return Container(
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
              Text(
                producto.detail ?? '',
                style: (TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                )),
              ),
              SizedBox(
                height: 10,
              ),
              _agregarOEliminar(producto)
            ],
          ),
          Spacer(),
          Column(
            children: [
              _txtPrecio(producto),
              _btnIconBorrarProduct(producto),
            ],
          )
        ],
      ),
    );
  }

  Widget _txtPRecioTotal() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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

  Widget _btnIconBorrarProduct(Product producto) {
    return IconButton(
      icon: Icon(
        Icons.delete,
        color: MyColors.primaryColor,
      ),
      onPressed: () {
        _obj.eliminarItem(producto);
      },
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

  Widget _agregarOEliminar(Product producto) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            _obj.reducirItem(producto);
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
              color: Colors.grey[200],
            ),
            child: Text('-'),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 7,
          ),
          color: Colors.grey[200],
          child: Text('${producto?.quantity}' ?? 0),
        ),
        GestureDetector(
          onTap: () {
            _obj.aumentarItem(producto);
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              color: Colors.grey[200],
            ),
            child: Text('+'),
          ),
        ),
      ],
    );
  }

  void refresh() {
    setState(() {});
  }
}
