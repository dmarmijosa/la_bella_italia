import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:la_bella_italia/src/models/categoria.dart';
import 'package:la_bella_italia/src/pages/restaurante/productos/crear/restaurante_productos_crear_Controller.dart';
import 'package:la_bella_italia/src/utils/my_colors.dart';

class RestauranteProductosCrearPage extends StatefulWidget {
  const RestauranteProductosCrearPage({key}) : super(key: key);

  @override
  _RestauranteProductosCrearPageState createState() =>
      _RestauranteProductosCrearPageState();
}

class _RestauranteProductosCrearPageState
    extends State<RestauranteProductosCrearPage> {
  RestauranteProductoCrearController _obj =
      new RestauranteProductoCrearController();

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
        title: Text('Nueva producto'),
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
                _tarjetaImagen(_obj.imageFile1, 1),
                _tarjetaImagen(_obj.imageFile2, 2),
                _tarjetaImagen(_obj.imageFile3, 3),
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
            hintText: 'Nombre de la producto',
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

  Widget _dropDownCategories(List<Categoria> categories) {
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
                    'Categorias',
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

  List<DropdownMenuItem<String>> _dropDownItems(List<Categoria> categories) {
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
                child: Image(
                  image: AssetImage('assets/img/add_image.png'),
                ),
              ),
            ),
    );
  }

  Widget _btnCrear() {
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      child: ElevatedButton(
        onPressed: _obj.createProduct,
        child: Text('Crear producto'),
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
