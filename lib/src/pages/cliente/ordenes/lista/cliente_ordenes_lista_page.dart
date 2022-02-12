import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:la_bella_italia/src/models/orden.dart';
import 'package:la_bella_italia/src/pages/cliente/ordenes/lista/cliente_ordenes_lista_controller.dart';

import 'package:la_bella_italia/src/utils/my_colors.dart';

import 'package:la_bella_italia/src/utils/relative_time_util.dart';
import 'package:la_bella_italia/src/widgets/no_data_widget.dart';

class ClienteOrdenesListaPage extends StatefulWidget {
  const ClienteOrdenesListaPage({key}) : super(key: key);

  @override
  _ClienteOrdenesListaPageState createState() =>
      _ClienteOrdenesListaPageState();
}

class _ClienteOrdenesListaPageState extends State<ClienteOrdenesListaPage> {
  ClienteOrdenesListaController _obj = new ClienteOrdenesListaController();

  @override
  // ignore: must_call_super
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _obj.init(context, refresh);
      refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: DefaultTabController(
        length: _obj.status?.length,
        child: Scaffold(
          key: _obj.key,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(100),
            child: AppBar(
              title: Text('Mis pedidos'),
              backgroundColor: MyColors.primaryColor,
              bottom: TabBar(
                indicatorColor: Colors.black,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.white,
                isScrollable: true,
                tabs: List<Widget>.generate(
                  _obj.status.length,
                  (index) {
                    return Tab(
                      child: Text(_obj.status[index] ?? ''),
                    );
                  },
                ),
              ),
            ),
          ),
          body: TabBarView(
            children: _obj.status.map((String status) {
              return FutureBuilder(
                  future: _obj.obtenerOrdenes(status),
                  builder: (context, AsyncSnapshot<List<Orden>> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.length > 0) {
                        return ListView.builder(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            itemCount: snapshot.data?.length ?? 0,
                            itemBuilder: (_, index) {
                              print(snapshot.data[index].toJson());
                              return _tarjetaOrden(snapshot.data[index]);
                            });
                      } else {
                        return NoDataWidget(texto: 'No hay ordenes');
                      }
                    } else {
                      return NoDataWidget(texto: 'No hay ordenes');
                    }
                  });
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _tarjetaOrden(Orden orden) {
    return GestureDetector(
      onTap: () {
        _obj.abrirSheet(orden);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        height: 160,
        child: Card(
          elevation: 3.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Stack(
            children: [
              Positioned(
                child: Container(
                  height: 30,
                  width: MediaQuery.of(context).size.width * 1,
                  decoration: BoxDecoration(
                    color: MyColors.primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      'ORDEN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 40, left: 20, right: 20),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        'Pedido: ${RelativeTimeUtil.getRelativeTime(orden.timestamp)}',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        'Repartidor: ${orden.delivery?.name ?? 'No asignado'} ${orden.delivery?.lastname ?? ''} ',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                        maxLines: 1,
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        'Entregar en: ${orden.address.address}',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void refresh() {
    setState(
      () {},
    );
  }
}
