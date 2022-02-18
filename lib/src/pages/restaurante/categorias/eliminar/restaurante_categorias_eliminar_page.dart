import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:la_bella_italia/src/models/category.dart';

import 'package:la_bella_italia/src/pages/restaurante/categorias/eliminar/restaurante_categorias_eliminar_controller.dart';

class RestauranteCategoriasEliminarPage extends StatefulWidget {
  const RestauranteCategoriasEliminarPage({key}) : super(key: key);

  @override
  _RestauranteCategoriasEliminarPageState createState() =>
      _RestauranteCategoriasEliminarPageState();
}

class _RestauranteCategoriasEliminarPageState
    extends State<RestauranteCategoriasEliminarPage> {
  ResaturanteCategoriasEliminarController _obj =
      new ResaturanteCategoriasEliminarController();
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

  Widget _buildItem(Category categoria) {
    return new ListTile(
      title: new Text(categoria.name),
      subtitle: new Text(
        'Descripción: ${categoria.description}',
        maxLines: 2,
      ),
      leading: new Icon(Icons.delete),
      onTap: () {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Confirmar eliminación'),
            content: Text(
                '¿ Esta seguro de eliminar la categoria con los productos ?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => {
                  _obj.confirmarEliminar(categoria.id),
                  Navigator.pop(context),
                  refresh()
                },
                child: Text('Si'),
              ),
            ],
          ),
        );
      },
    );
  }

  void refresh() {
    setState(() {});
  }
}
