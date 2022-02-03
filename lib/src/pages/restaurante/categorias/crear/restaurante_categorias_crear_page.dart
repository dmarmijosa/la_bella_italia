import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:la_bella_italia/src/pages/restaurante/categorias/crear/restaurante_categorias_crear_controller.dart';
import 'package:la_bella_italia/src/utils/my_colors.dart';

class RestauranteCategoriasCrearPage extends StatefulWidget {
  const RestauranteCategoriasCrearPage({key}) : super(key: key);

  @override
  _RestauranteCategoriasCrearPageState createState() =>
      _RestauranteCategoriasCrearPageState();
}

class _RestauranteCategoriasCrearPageState
    extends State<RestauranteCategoriasCrearPage> {
  RestauranteCategoriasCrearController _obj =
      new RestauranteCategoriasCrearController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _obj.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Nueva categoria'),
        ),
        body: Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: 50),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _edtNombreCategoria(),
                _edtDescripcionCategoria(),
                _btnRCrear(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _edtNombreCategoria() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 7),
      decoration: BoxDecoration(
        color: MyColors.primaryOpacityColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: _obj.nombreController,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          hintText: 'Nombre de la categoría',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          prefixIcon: Icon(
            Icons.create,
            color: MyColors.primaryColor,
          ),
          hintStyle: TextStyle(color: MyColors.primaryColorDark),
        ),
      ),
    );
  }

  Widget _edtDescripcionCategoria() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 7),
      decoration: BoxDecoration(
        color: MyColors.primaryOpacityColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: _obj.descripcionController,
        keyboardType: TextInputType.name,
        maxLength: 200,
        maxLines: 3,
        decoration: InputDecoration(
          hintText: 'Descripción de la categoría',
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

  Widget _btnRCrear() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      child: ElevatedButton.icon(
        icon: Icon(Icons.add),
        onPressed: _obj.crearCategoria,
        label: Text('Crear categoría'),
        style: ElevatedButton.styleFrom(
            primary: MyColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            padding: EdgeInsets.symmetric(vertical: 10)),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
