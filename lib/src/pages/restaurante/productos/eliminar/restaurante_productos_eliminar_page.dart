import 'package:flutter/material.dart';

import 'package:flutter/scheduler.dart';
import 'package:la_bella_italia/src/models/category.dart';
import 'package:la_bella_italia/src/models/product.dart';

import 'package:la_bella_italia/src/pages/restaurante/productos/eliminar/restaurante_productos_eliminar_controller.dart';
import 'package:la_bella_italia/src/utils/my_colors.dart';
import 'package:la_bella_italia/src/widgets/no_data_widget.dart';

class RestauranteProductosEliminarListaPage extends StatefulWidget {
  const RestauranteProductosEliminarListaPage({key}) : super(key: key);

  @override
  _RestauranteProductosEliminarListaPageState createState() =>
      _RestauranteProductosEliminarListaPageState();
}

class _RestauranteProductosEliminarListaPageState
    extends State<RestauranteProductosEliminarListaPage> {
  RestauranteProductosEliminarListaController _obj =
      new RestauranteProductosEliminarListaController();

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
        length: _obj.categories?.length,
        child: Scaffold(
          key: _obj.key,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(170),
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              flexibleSpace: Column(
                children: [
                  SizedBox(height: 40),
                  _menuDraver(),
                  SizedBox(height: 20),
                  _edtSearch(),
                ],
              ),
              bottom: TabBar(
                indicatorColor: Colors.black,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey[400],
                isScrollable: true,
                tabs: List<Widget>.generate(
                  _obj.categories.length,
                  (index) {
                    return Tab(
                      child: Text(_obj.categories[index].name ?? ''),
                    );
                  },
                ),
              ),
            ),
          ),
          body: TabBarView(
            children: _obj.categories.map(
              (Category categoria) {
                return FutureBuilder(
                  future: _obj.getProduct(categoria.id, _obj.productSearch),
                  builder: (context, AsyncSnapshot<List<Product>> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.length > 0) {
                        return GridView.builder(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                          ),
                          itemCount: snapshot.data?.length ?? 0,
                          itemBuilder: (_, index) {
                            return _targetProduct(snapshot.data[index]);
                          },
                        );
                      } else {
                        return NoDataWidget(
                          text: 'No hay productos',
                        );
                      }
                    } else {
                      return NoDataWidget(
                        text: 'No hay productos',
                      );
                    }
                  },
                );
              },
            ).toList(),
          ),
        ),
      ),
    );
  }

  Widget _menuDraver() {
    return GestureDetector(
      onTap: _obj.goToback,
      child: Container(
          margin: EdgeInsets.only(left: 20),
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Icon(
                Icons.arrow_back_sharp,
                color: Colors.black,
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                'REGRESAR',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          )),
    );
  }

  Widget _targetProduct(Product producto) {
    return GestureDetector(
      onTap: () {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Confirmar eliminaci??n'),
            content: const Text('?? Esta seguro de eliminar el producto ?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => {
                  _obj.confirmDelete(producto),
                  Navigator.pop(context, 'Si'),
                },
                child: const Text('Si'),
              ),
            ],
          ),
        );
      },
      child: Container(
        height: 250,
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -1,
                right: -1,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: MyColors.primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 150,
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: FadeInImage(
                      placeholder: AssetImage('assets/img/pizza2.png'),
                      fit: BoxFit.contain,
                      fadeInDuration: Duration(milliseconds: 50),
                      image: producto.image1 != null
                          ? NetworkImage(producto.image1)
                          : AssetImage('assets/img/pizza2.png'),
                    ),
                  ),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    height: 33,
                    child: Text(
                      producto.name.toUpperCase() ?? 'PRODUCTO',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      '${producto.price ?? 0}\???',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _edtSearch() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        onChanged: _obj.textSearch,
        decoration: InputDecoration(
          hintText: 'Buscar',
          suffixIcon: Icon(
            Icons.search,
            color: Colors.grey[400],
          ),
          hintStyle: TextStyle(
            fontSize: 17,
            color: Colors.grey[500],
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: Colors.grey[300]),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: Colors.grey[300]),
          ),
          contentPadding: EdgeInsets.all(15),
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
