import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:la_bella_italia/src/models/rol.dart';
import 'package:la_bella_italia/src/pages/roles/roles_controller.dart';

class RolesPage extends StatefulWidget {
  const RolesPage({Key key}) : super(key: key);

  @override
  _RolesPageState createState() => _RolesPageState();
}

class _RolesPageState extends State<RolesPage> {
  RolesController _obj = new RolesController();

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
        title: Text('Selecciona un rol'),
      ),
      body: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.14),
        child: ListView(
            children: _obj.user != null
                ? _obj.user.roles.map((Rol rol) {
                    return _cardRol(rol);
                  }).toList()
                : []),
      ),
    );
  }

  Widget _cardRol(Rol rol) {
    return GestureDetector(
      onTap: () {
        _obj.goToRol(rol.route);
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 100,
              child: rol.id == "3"
                  ? Icon(
                      Icons.delivery_dining,
                      size: 100,
                    )
                  : rol.id == "2"
                      ? Icon(
                          Icons.storefront,
                          size: 100,
                        )
                      : rol.id == "1"
                          ? Icon(
                              Icons.account_circle,
                              size: 100,
                            )
                          : Container(),
            ),
            SizedBox(height: 15),
            Text(
              rol.name ?? '',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
