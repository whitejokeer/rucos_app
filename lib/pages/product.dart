import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/carrito.dart';
import '../models/producto.dart';
import 'skeleton.dart';

class ProductoScreen extends StatefulWidget {
  final Producto pdr;

  ProductoScreen({Key key, this.pdr}) : super(key: key);
  @override
  _ProductoScreenState createState() => _ProductoScreenState();
}

class _ProductoScreenState extends State<ProductoScreen> {
  Color text1 = Colors.white;
  Color text2 = Colors.white70;
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CarritoInfo>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFf15a24),
        body: ListView(
          children: [
            Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 2 - 30,
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: 20.0, left: 20.0, right: 10.0),
                            child: Text(
                              widget.pdr.nombreProducto,
                              style: TextStyle(
                                color: text1,
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text(
                              "\$${widget.pdr.precio}",
                              style: TextStyle(
                                color: text1,
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: Text(
                              "${widget.pdr.caracteristicas}",
                              style: TextStyle(
                                color: text2,
                                fontSize: 15.0,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: Text(
                              "Especificaciones:",
                              style: TextStyle(
                                color: text1,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: widget.pdr.especificaciones.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 30.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 2,
                                      child: Text(
                                        "${widget.pdr.especificaciones[index].titulo}:",
                                        style: TextStyle(
                                            color: text2,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 3,
                                      child: Text(
                                        widget.pdr.especificaciones[index]
                                            .especificacion,
                                        softWrap: true,
                                        maxLines: 3,
                                        textAlign: TextAlign.justify,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: text2, fontSize: 15.0),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 15.0, left: 10.0, right: 10.0),
                            child: ClipRRect(
                              child: Container(
                                height: 60.0,
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: Card(
                                            color: Colors.white,
                                            child: Center(
                                              child: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    quantity > 1
                                                        ? quantity =
                                                            quantity - 1
                                                        // ignore: unnecessary_statements
                                                        : null;
                                                  });
                                                },
                                                icon: Icon(
                                                  Icons.remove,
                                                  color: Color(0xFFf15a24),
                                                  size: 30.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(13.0),
                                          child: Card(
                                            color: Colors.white,
                                            child: Center(
                                              child: Text(
                                                "$quantity",
                                                style: TextStyle(
                                                  //color: Color(0xFFf15a24),
                                                  fontSize: 20.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: Card(
                                            color: Colors.white,
                                            child: Center(
                                              child: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    quantity = quantity + 1;
                                                  });
                                                },
                                                icon: Icon(
                                                  Icons.add,
                                                  color: Color(0xFFf15a24),
                                                  size: 30.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(13.0),
                                          child: MaterialButton(
                                            padding: EdgeInsets.all(0.0),
                                            onPressed: () {
                                              setState(() {
                                                cart.addItems(
                                                    widget.pdr, quantity);
                                              });
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EsqueletoScreen()),
                                              );
                                            },
                                            child: Card(
                                                color: Colors.white,
                                                child: Center(
                                                  child: Text(
                                                    "Agregar",
                                                    style: TextStyle(
                                                      color: Color(0xFFf15a24),
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                )),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35),
                    bottomRight: Radius.circular(35),
                  ),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2 - 30,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(35.0),
                          image: DecorationImage(
                            image: NetworkImage(widget.pdr.imgUrl),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, top: 10.0),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Color(0xFFf15a24),
                        size: 30.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
