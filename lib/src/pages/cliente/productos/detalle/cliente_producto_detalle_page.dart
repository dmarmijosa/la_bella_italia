import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:la_bella_italia/src/models/producto.dart';
import 'package:la_bella_italia/src/pages/cliente/productos/detalle/cliente_producto_detalle_controller.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:la_bella_italia/src/utils/my_colors.dart';

// ignore: must_be_immutable
class ClienteProductoDetallePage extends StatefulWidget {
  Producto producto;

  ClienteProductoDetallePage({key, @required this.producto}) : super(key: key);

  @override
  _ClienteProductoDetallePageState createState() =>
      _ClienteProductoDetallePageState();
}

class _ClienteProductoDetallePageState
    extends State<ClienteProductoDetallePage> {
  ClienteProductoDetalleController _obj =
      new ClienteProductoDetalleController();
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _obj.init(context, refresh, widget.producto);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 30),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              children: [
                _carouselProduct(),
                _txtNombre(),
                _txtDescripcion(),
                _edtDetalleProducto(),
                Spacer(),
                _cantidadPedido(),
                _iconoDelivery(),
                _btnAgregarABolsa()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _edtDetalleProducto() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 7),
      padding: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: _obj.detalleController,
        keyboardType: TextInputType.name,
        maxLength: 200,
        maxLines: 1,
        decoration: InputDecoration(
          hintText: 'Instrucción especial.',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(10),
          prefixIcon: Icon(
            Icons.edit,
            color: MyColors.primaryColor,
          ),
          hintStyle: TextStyle(color: MyColors.primaryColorDark),
        ),
      ),
    );
  }

  Widget _btnAgregarABolsa() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
      child: ElevatedButton(
        onPressed: _obj.productosEnBolsa,
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
                  'Agregar a la bolsa.'.toUpperCase(),
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
                child: Icon(Icons.shopping_bag),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _txtDescripcion() {
    return Container(
      alignment: Alignment.bottomLeft,
      margin: EdgeInsets.only(right: 30, left: 30, top: 15),
      child: Text(
        _obj.producto?.description?.toUpperCase() ?? '',
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _cantidadPedido() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 17),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.add_circle_outline,
              color: Colors.grey,
              size: 30,
            ),
            onPressed: _obj.sumarItem,
          ),
          Text(
            _obj.cantidad.toString(),
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.remove_circle_outline,
              color: Colors.grey,
              size: 30,
            ),
            onPressed: _obj.restarItem,
          ),
          Spacer(),
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Text(
              '${_obj.precioProductoAgregado ?? 0} \€',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _txtNombre() {
    return Container(
      alignment: Alignment.bottomLeft,
      margin: EdgeInsets.only(right: 30, left: 30, top: 30),
      child: Text(
        _obj.producto?.name?.toUpperCase() ?? '',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _iconoDelivery() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Row(
        children: [
          Icon(
            Icons.delivery_dining,
            color: MyColors.primaryColor,
            size: 20,
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            'Envío estándar.',
            style: TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: Colors.green,
            ),
          )
        ],
      ),
    );
  }

  Widget _carouselProduct() {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: 20),
          child: ImageSlideshow(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.4,
            initialPage: 0,
            indicatorColor: MyColors.primaryColor,
            indicatorBackgroundColor: Colors.grey,
            children: [
              FadeInImage(
                placeholder: AssetImage('assets/img/pizza2.png'),
                fit: BoxFit.contain,
                fadeInDuration: Duration(milliseconds: 50),
                image: _obj.producto?.image1 != null
                    ? NetworkImage(_obj.producto.image1)
                    : AssetImage('assets/img/pizza2.png'),
              ),
              FadeInImage(
                placeholder: AssetImage('assets/img/pizza2.png'),
                fit: BoxFit.contain,
                fadeInDuration: Duration(milliseconds: 50),
                image: _obj.producto?.image2 != null
                    ? NetworkImage(_obj.producto.image1)
                    : AssetImage('assets/img/no-image.png'),
              ),
              FadeInImage(
                placeholder: AssetImage('assets/img/pizza2.png'),
                fit: BoxFit.contain,
                fadeInDuration: Duration(milliseconds: 50),
                image: _obj.producto?.image3 != null
                    ? NetworkImage(_obj.producto.image1)
                    : AssetImage('assets/img/no-image.png'),
              ),
            ],
            autoPlayInterval: 7000,
          ),
        ),
        Positioned(
          left: 10,
          top: 5,
          child: IconButton(
            onPressed: _obj.regresarPaginaAnterior,
            icon: Icon(
              Icons.arrow_back_ios,
              color: MyColors.primaryColor,
            ),
          ),
        )
      ],
    );
  }

  void refresh() {
    setState(() {});
  }
}
