import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/carrito.dart';
import 'address.dart';
import 'skeleton.dart';
import 'product.dart';

class CarritoScreen extends StatefulWidget {
  @override
  _CarritoScreenState createState() => _CarritoScreenState();
}

class _CarritoScreenState extends State<CarritoScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final carrito = Provider.of<CarritoInfo>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Color(0xFFf15a24),
        ),
        title: Text(
          "Carrito",
          style: TextStyle(
            color: Color(0xFFf15a24),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              onPressed: () {
                setState(() {
                  carrito.eliminarTodo();
                });
              },
              icon: Icon(
                Icons.delete,
                color: Color(0xFFf15a24),
              ),
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Card(
                elevation: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DireccionScreen(),
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Color(0xFFf15a24),
                      ),
                      leading: Icon(
                        Icons.gps_fixed,
                        color: Color(0xFFf15a24),
                        size: 40.0,
                      ),
                      title: Text(carrito.direccion),
                      subtitle: Text(carrito.especificaciones),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(left: 25, top: 3.0, bottom: 10.0),
              child: Text(
                "Productos",
                style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFf15a24)),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Divider(
                  //color: Color(0xFFf15a24),
                  ),
            ),
          ),
          carrito.items.length == 0
              ? SliverToBoxAdapter(
                  child: Container(
                    height: 100,
                    child: Center(
                      child: Text("No has agregado ningun item al carrito"),
                    ),
                  ),
                )
              : SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5.0),
                          child: Card(
                            elevation: 5,
                            child: MaterialButton(
                              padding: EdgeInsets.all(0.0),
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductoScreen(
                                    pdr: carrito.items[index].product,
                                  ),
                                ),
                              ),
                              child: ListTile(
                                title: Text(carrito
                                    .items[index].product.nombreProducto),
                                leading: Image.network(
                                    carrito.items[index].product.imgUrl),
                                subtitle: Text(
                                  "\$ ${carrito.items[index].precioTotal}",
                                  style: TextStyle(
                                    color: Color(0xFFf15a24),
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    setState(
                                      () {
                                        carrito.eliminarItem(
                                            carrito.items[index].product.id);
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: carrito.items.length,
                    ),
                  ),
                ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Divider(
                  //color: Color(0xFFf15a24),
                  ),
            ),
          ),
          SliverToBoxAdapter(
              child: Center(
            child: MaterialButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => EsqueletoScreen()),
              ),
              child: Text(
                "Agregar más productos",
                style: TextStyle(
                  color: Color(0xFFf15a24),
                  fontSize: 20.0,
                ),
              ),
            ),
          )),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Divider(
                  //color: Color(0xFFf15a24),
                  ),
            ),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 40.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "\$ ${carrito.getTotal()}",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
              child: MaterialButton(
                color: Color(0xFFf15a24),
                onPressed: () {
                  carrito.getTotal() > 30000
                      ? auth
                          .authStateChanges()
                          .listen((currentUser) => firestore
                              .collection("Pedidos")
                              .add({
                                "idUsuario": currentUser.uid,
                                "direccionEntrega": carrito.direccion,
                                "especificacionDireccion":
                                    carrito.especificaciones,
                                "PrecioTotal": carrito.getTotal(),
                                "nombre": carrito.nombre,
                                "apellido": carrito.apellido,
                                "celular": carrito.celular,
                                "estado": 'Pendiente',
                                "mes": DateTime.now().month.toString(),
                                "dia": DateTime.now().day.toString(),
                              })
                              .then(
                                (DocumentReference val) =>
                                    carrito.items.forEach(
                                  (element) {
                                    firestore
                                        .collection("Pedidos")
                                        .doc(val.id)
                                        .collection("Productos")
                                        .add({
                                      "idProducto": element.product.id,
                                      "nombreProducto":
                                          element.product.nombreProducto,
                                      "cantidad": element.cantidad,
                                      "precio": element.product.precio,
                                    });
                                  },
                                ),
                              )
                              .then(
                                (value) {
                                  Navigator.of(context).pop();
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                          "Tu pedido se a realizado con exito!",
                                          style: TextStyle(
                                            color: Color(0xFFf15a24),
                                          ),
                                        ),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text(
                                              "Volver",
                                              style: TextStyle(
                                                color: Color(0xFFf15a24),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              )
                              .catchError((err) => print(err))
                              .catchError((err) => print(err)))
                      // ignore: unnecessary_statements
                      : null;
                  carrito.getTotal() < 30000
                      ? showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                "Ups!",
                                style: TextStyle(
                                  color: Color(0xFFf15a24),
                                ),
                              ),
                              content: Text(
                                  "El pedido minimo es de \$30000 pesos colombianos"),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text(
                                    "Volver",
                                    style: TextStyle(
                                      color: Color(0xFFf15a24),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            );
                          },
                        )
                      : showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                "Estamos realizando tu pedido",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFFf15a24),
                                ),
                              ),
                              content: Container(
                                height: 100.0,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    backgroundColor: Color(0xFFf15a24),
                                    valueColor:
                                        new AlwaysStoppedAnimation<Color>(
                                            Colors.white),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                },
                child: Container(
                  height: 60.0,
                  child: Center(
                    child: Text(
                      "Hacer pedido",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
              child: Divider(
                color: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
