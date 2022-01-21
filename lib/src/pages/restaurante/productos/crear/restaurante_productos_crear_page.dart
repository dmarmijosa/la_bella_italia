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
  RestauranteProductoCrearController _crpcc =
      new RestauranteProductoCrearController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _crpcc.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Agregar producto'),
        ),
        body: Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: 50),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _edtNombreProducto(),
                _edtDescripcionProducto(),
                _edtCostoProducto(),
                Container(
                  height: 100,
                  margin: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  child: Row(
                    children: [
                      _tarjetaImagen(null, 1),
                      _tarjetaImagen(null, 2),
                      _tarjetaImagen(null, 3),
                    ],
                  ),
                ),
                _dropDCategorias(_crpcc.categorias),
                _btnCrearProducto()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _btnCrearProducto() {
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      child: ElevatedButton(
        onPressed: () {},
        child: Text('Crear producto'),
        style: ElevatedButton.styleFrom(
            primary: MyColors.primaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: EdgeInsets.symmetric(vertical: 15)),
      ),
    );
  }

  Widget _dropDCategorias(List<Categoria> categorias) {
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
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    'Categoria',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
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
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  items: _dropDownItems(categorias),
                  value: _crpcc.idCategoria,
                  onChanged: (opcion) {
                    setState(() {
                      _crpcc.idCategoria = opcion;
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

  List<DropdownMenuItem<String>> _dropDownItems(List<Categoria> categorias) {
    List<DropdownMenuItem<String>> list = [];
    categorias.forEach((categoria) {
      list.add(
        DropdownMenuItem(
          child: Text(categoria.name),
          value: categoria.id,
        ),
      );
    });
    return list;
  }

  Widget _edtNombreProducto() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 7),
      decoration: BoxDecoration(
        color: MyColors.primaryOpacityColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: _crpcc.nombreController,
        keyboardType: TextInputType.name,
        maxLength: 100,
        maxLines: 2,
        decoration: InputDecoration(
          hintText: 'Nombre del producto',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          prefixIcon: Icon(
            Icons.local_pizza,
            color: MyColors.primaryColor,
          ),
          hintStyle: TextStyle(color: MyColors.primaryColorDark),
        ),
      ),
    );
  }

  Widget _edtDescripcionProducto() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 7),
      decoration: BoxDecoration(
        color: MyColors.primaryOpacityColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: _crpcc.descripcionController,
        keyboardType: TextInputType.name,
        maxLength: 200,
        maxLines: 3,
        decoration: InputDecoration(
          hintText: 'Descripción del producto',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          prefixIcon: Icon(
            Icons.description,
            color: MyColors.primaryColor,
          ),
          hintStyle: TextStyle(color: MyColors.primaryColorDark),
        ),
      ),
    );
  }

  Widget _tarjetaImagen(File imageFile, int numberFile) {
    return GestureDetector(
      onTap: () {},
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

  Widget _edtCostoProducto() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 7),
      decoration: BoxDecoration(
        color: MyColors.primaryOpacityColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: _crpcc.precioController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'costo del producto',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          prefixIcon: Icon(
            Icons.monetization_on,
            color: MyColors.primaryColor,
          ),
          hintStyle: TextStyle(color: MyColors.primaryColorDark),
        ),
      ),
    );
  }

  Function refresh() {
    setState(() {});
  }
}
