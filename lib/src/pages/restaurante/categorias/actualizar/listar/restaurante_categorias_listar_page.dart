import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:la_bella_italia/src/models/categoria.dart';
import 'package:la_bella_italia/src/pages/restaurante/categorias/actualizar/listar/restaurante_categorias_listar_controller.dart';

class RestauranteCategoriasListarPage extends StatefulWidget {
  const RestauranteCategoriasListarPage({key}) : super(key: key);

  @override
  _RestauranteCategoriasListarPageState createState() =>
      _RestauranteCategoriasListarPageState();
}

class _RestauranteCategoriasListarPageState
    extends State<RestauranteCategoriasListarPage> {
  ResaturanteCategoriasListarController _obj =
      new ResaturanteCategoriasListarController();
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _obj.init(context, refresh);
      refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Regresar'),
      ),
      body: new ListView(
        children: _obj.categorias.map(_buildItem).toList(),
      ),
    );
  }

  Widget _buildItem(Categoria categoria) {
    return new ListTile(
      title: new Text(categoria.name),
      subtitle: new Text(
        'Descripción: ${categoria.description}',
        maxLines: 2,
      ),
      leading: new Icon(Icons.edit),
      onTap: () {
        _obj.mostrarSheet(categoria);
      },
    );
  }

  void refresh() {
    setState(() {});
  }
}
