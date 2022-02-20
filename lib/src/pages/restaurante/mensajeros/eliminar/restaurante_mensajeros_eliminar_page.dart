import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:la_bella_italia/src/models/user.dart';
import 'package:la_bella_italia/src/pages/restaurante/mensajeros/eliminar/restaurante_mensajeros_eliminar_controller.dart';

class RestauranteMensajerosEliminarPage extends StatefulWidget {
  const RestauranteMensajerosEliminarPage({key}) : super(key: key);

  @override
  _RestauranteMensajerosEliminarPageState createState() =>
      _RestauranteMensajerosEliminarPageState();
}

class _RestauranteMensajerosEliminarPageState
    extends State<RestauranteMensajerosEliminarPage> {
  RestauranteMensajerosEliminarController _obj =
      new RestauranteMensajerosEliminarController();
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
        children: _obj.deliverys.map(_buildItem).toList(),
      ),
    );
  }

  Widget _buildItem(User usuario) {
    return new ListTile(
      title: new Text('${usuario.name} ${usuario.lastname}'),
      subtitle: new Text(
        'Correo: ${usuario.email}',
        maxLines: 2,
      ),
      leading: new Icon(Icons.delete),
      onTap: () {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Confirmar eliminación'),
            content: const Text('¿ Esta seguro de eliminar el mensajero ?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => {
                  _obj.confirmDelete(usuario.id),
                  Navigator.pop(context),
                  refresh()
                },
                child: const Text('Si'),
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
