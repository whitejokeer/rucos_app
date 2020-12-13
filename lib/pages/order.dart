import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/carrito.dart';

class PedidosScreen extends StatefulWidget {
  @override
  _PedidosScreenState createState() => _PedidosScreenState();
}

class _PedidosScreenState extends State<PedidosScreen> {
  Map<int, String> months = {
    1: "Ene.",
    2: "Feb.",
    3: "Mar.",
    4: "Abr.",
    5: "May.",
    6: "Jun.",
    7: "Jul.",
    8: "Ago.",
    9: "Sep.",
    10: "Oct.",
    11: "Nov.",
    12: "Dic."
  };

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CarritoInfo>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Color(0xFFf15a24),
        ),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Pedidos",
          style: TextStyle(
            color: Color(0xFFf15a24),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Pedidos")
            .where('idUsuario', isEqualTo: cart.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text("No has realizado ningun pedido aun."),
            );
          } else {
            return ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Card(
                    elevation: 5,
                    child: ListTile(
                      leading: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          color: Color(0xFFf15a24),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${snapshot.data.documents[index]["dia"]}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  months[int.parse(
                                      "${snapshot.data.documents[index]["mes"]}")],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        snapshot.data.documents[index]["estado"],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "\$${snapshot.data.documents[index]["PrecioTotal"]}",
                        style: TextStyle(
                          color: Color(0xFFf15a24),
                        ),
                      ),
                      trailing: snapshot.data.documents[index]["estado"] ==
                              "Pendiente"
                          ? Icon(
                              Icons.assignment,
                              color: Colors.grey,
                              size: 35.0,
                            )
                          : Icon(
                              Icons.assignment_turned_in,
                              color: Color(0xFFf15a24),
                              size: 35.0,
                            ),
                    ),
                  ),
                );
              },
              itemCount: snapshot.data.documents.length,
            );
          }
        },
      ),
    );
  }
}
