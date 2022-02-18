import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:la_bella_italia/src/models/category.dart';
import 'package:la_bella_italia/src/models/product.dart';
import 'package:la_bella_italia/src/pages/restaurante/productos/actualizar/detalle/restaurante_productos_actualizar_detalle_controller.dart';
import 'package:la_bella_italia/src/utils/my_colors.dart';

// ignore: must_be_immutable
class RestauranteProductoActualizarDetallePage extends StatefulWidget {
  Product producto;
  RestauranteProductoActualizarDetallePage({key, @required this.producto})
      : super(key: key);

  @override
  _RestauranteProductoActualizarDetallePageState createState() =>
      _RestauranteProductoActualizarDetallePageState();
}

class _RestauranteProductoActualizarDetallePageState
    extends State<RestauranteProductoActualizarDetallePage> {
  RestauranteProductoActualizarDetalleController _obj =
      new RestauranteProductoActualizarDetalleController();

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
      appBar: AppBar(
        title: Text('Editar producto'),
      ),
      body: ListView(
        children: [
          SizedBox(height: 30),
          _edtNombre(),
          _edtDescripcion(),
          _edtPrecio(),
          Container(
            height: 100,
            margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _tarjetaImagen(_obj?.imageFile1, 1),
                _tarjetaImagen(_obj?.imageFile2, 2),
                _tarjetaImagen(_obj?.imageFile3, 3),
              ],
            ),
          ),
          _dropDownCategories(_obj.categorias),
          _btnCrear(),
        ],
      ),
    );
  }

  Widget _edtNombre() {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        controller: _obj.nombreController,
        maxLines: 1,
        maxLength: 180,
        decoration: InputDecoration(
            hintText: 'Nombre del producto',
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            hintStyle: TextStyle(color: MyColors.primaryColorDark),
            icon: Icon(
              Icons.local_pizza,
              color: MyColors.primaryColor,
            )),
      ),
    );
  }

  Widget _edtPrecio() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        controller: _obj.precioController,
        keyboardType: TextInputType.phone,
        maxLines: 1,
        decoration: InputDecoration(
            hintText: 'Precio',
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            hintStyle: TextStyle(color: MyColors.primaryColorDark),
            icon: Icon(
              Icons.euro,
              color: MyColors.primaryColor,
            )),
      ),
    );
  }

  Widget _dropDownCategories(List<Category> categories) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 33),
      child: Material(
        elevation: 2.0,
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.search,
                    color: MyColors.primaryColor,
                  ),
                  SizedBox(width: 15),
                  Text(
                    "Categoria",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  )
                ],
              ),
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
                    'Seleccionar categoria',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  items: _dropDownItems(categories),
                  value: _obj.idCategory,
                  onChanged: (option) {
                    setState(() {
                      print('Categoria seleccionda $option');
                      _obj.idCategory =
                          option; // ESTABLECIENDO EL VALOR SELECCIONADO
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

  List<DropdownMenuItem<String>> _dropDownItems(List<Category> categories) {
    List<DropdownMenuItem<String>> list = [];
    categories.forEach((category) {
      list.add(DropdownMenuItem(
        child: Text(category.name),
        value: category.id,
      ));
    });

    return list;
  }

  Widget _edtDescripcion() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        controller: _obj.descripcionController,
        maxLines: 3,
        maxLength: 255,
        decoration: InputDecoration(
          hintText: 'Descripcion de la categoria',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          hintStyle: TextStyle(color: MyColors.primaryColorDark),
          icon: Icon(
            Icons.description,
            color: MyColors.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _tarjetaImagen(File imageFile, int numberFile) {
    return GestureDetector(
      onTap: () {
        _obj.showAlertDialog(numberFile);
      },
      child: imageFile != null
          ? Card(
              elevation: 3.0,
              child: Container(
                height: 100,
                width: MediaQuery.of(context).size.width * 0.26,
                child: Image.file(
                  imageFile,
                  fit: BoxFit.cover,
                ),
              ),
            )
          : Card(
              elevation: 3.0,
              child: Container(
                  height: 140,
                  width: MediaQuery.of(context).size.width * 0.26,
                  child: numberFile == 1
                      ? _obj?.producto?.image1 == null
                          ? Image.asset('assets/img/no-image.png')
                          : Image?.network(_obj?.producto?.image1)
                      : numberFile == 2
                          ? _obj?.producto?.image2 == null
                              ? Image.asset('assets/img/no-image.png')
                              : Image.network(_obj?.producto?.image2)
                          : numberFile == 3
                              ? _obj?.producto?.image3 == null
                                  ? Image.asset('assets/img/no-image.png')
                                  : Image?.network(_obj?.producto?.image3)
                              : Image.asset('assets/img/no-image.png')),
            ),
    );
  }

  Widget _btnCrear() {
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      child: ElevatedButton(
        onPressed: _obj.updateProduct,
        child: Text('Editar producto'),
        style: ElevatedButton.styleFrom(
            primary: MyColors.primaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: EdgeInsets.symmetric(vertical: 15)),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
