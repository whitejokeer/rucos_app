import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';

import '../models/producto.dart';
import 'product.dart';

import '../core.dart';

class BuscarScreen extends StatefulWidget {
  @override
  _BuscarScreenState createState() => _BuscarScreenState();
}

class _BuscarScreenState extends State<BuscarScreen> {
  List<Producto> _products = productos;

  @override
  Widget build(BuildContext context) {
    Future<List<Producto>> search(String search) async {
      List<Producto> datos = [];
      if (_products.isNotEmpty) {
        for (int i = 0; i < _products.length; i++) {
          if (_products[i]
              .nombreProducto
              .toLowerCase()
              .contains(search.toLowerCase())) {
            datos.add(_products[i]);
            print(i);
          }
        }
      }

      return datos;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: SearchBar<Producto>(
            onSearch: search,
            crossAxisCount: 2,
            loader: Center(
              child: Text(
                "loading...",
                style: TextStyle(color: Colors.orange),
              ),
            ),
            cancellationWidget: Text("Cancelar"),
            placeHolder: Center(
              child: Text(
                "Encuentra todo en un solo lugar!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            onError: (er) {
              return Center(
                child: Text(
                  "Ups!. Algo ha ido mal, vuelve a intentarlo",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0),
                ),
              );
            },
            emptyWidget: Center(
              child: Text(
                "Lo sentimos, no hemos encontrado ningun producto con ese nombre, prueba con otro!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            onItemFound: (Producto pdr, int index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  height: 240.0,
                  child: MaterialButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductoScreen(
                          pdr: pdr,
                        ),
                      ),
                    ),
                    padding: EdgeInsets.all(0.0),
                    child: Card(
                      elevation: 3,
                      child: Column(
                        children: [
                          Flexible(
                            flex: 5,
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(pdr.imgUrl),
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 2.0, left: 5.0),
                                    child: Text(
                                      pdr.nombreProducto,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 2.0, left: 8.0),
                                    child: Text(
                                      "\$${pdr.precio}",
                                      style: TextStyle(
                                        color: Color(0xFFf15a24),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
