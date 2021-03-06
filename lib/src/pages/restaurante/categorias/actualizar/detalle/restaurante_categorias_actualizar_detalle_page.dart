import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:la_bella_italia/src/models/category.dart';
import 'package:la_bella_italia/src/pages/restaurante/categorias/actualizar/detalle/restaurante_categorias_actualizar_detalle_controller.dart';

import 'package:la_bella_italia/src/utils/my_colors.dart';

// ignore: must_be_immutable
class RestauranteCategoriasActualizarDetallePage extends StatefulWidget {
  Category categoria;
  RestauranteCategoriasActualizarDetallePage({key, @required this.categoria})
      : super(key: key);

  @override
  _RestauranteCategoriasActualizarDetallePageState createState() =>
      _RestauranteCategoriasActualizarDetallePageState();
}

class _RestauranteCategoriasActualizarDetallePageState
    extends State<RestauranteCategoriasActualizarDetallePage> {
  RestauranteCategoriasActualizarDetalleController _obj =
      new RestauranteCategoriasActualizarDetalleController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _obj.init(context, refresh, widget.categoria);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Editar categoria'),
        ),
        body: Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: 50),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _edtNameCategory(),
                _edtDescriptionCategory(),
                _btnEdit(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _edtNameCategory() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 7),
      decoration: BoxDecoration(
        color: MyColors.primaryOpacityColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: _obj.nameController,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          hintText: 'Nombre de la categor??a',
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

  Widget _edtDescriptionCategory() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 7),
      decoration: BoxDecoration(
        color: MyColors.primaryOpacityColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: _obj.descriptionController,
        keyboardType: TextInputType.name,
        maxLength: 200,
        maxLines: 3,
        decoration: InputDecoration(
          hintText: 'Descripci??n de la categor??a',
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

  Widget _btnEdit() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      child: ElevatedButton.icon(
        icon: Icon(Icons.edit),
        onPressed: _obj.updateCategoria,
        label: Text('Editar categor??a'),
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
