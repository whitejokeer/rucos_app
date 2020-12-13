import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import '../controllers/http_get_products.dart';
import '../core.dart';
import '../models/producto.dart';
import '../providers/carrito.dart';
import 'address.dart';
import 'product.dart';
import 'search.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ProductProvider controller = ProductProvider();
  List<Producto> _products = productos;

  @override
  void initState() {
    // ignore: unnecessary_statements
    _products.length == 0 ? getData() : null;
    super.initState();
  }

  getData() async {
    productos = await controller.getProducts();
    setState(() {
      _products = productos;
    });
  }

  @override
  Widget build(BuildContext context) {
    final carrito = Provider.of<CarritoInfo>(context);

    final searchBar = InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BuscarScreen(),
        ),
      ),
      child: Row(
        children: <Widget>[
          Flexible(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Card(
                  elevation: 3,
                  child: Container(
                    height: double.infinity,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          ),
          Flexible(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: Container(
                  color: Color(0xFFf15a24),
                  height: double.infinity,
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      "Buscar",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverSafeArea(
              sliver: SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  minHeight: 120,
                  maxHeight: 120,
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        Flexible(
                          child: Row(
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Flexible(
                                    flex: 1,
                                    child: MaterialButton(
                                      padding: EdgeInsets.only(
                                          top: 10.0, left: 14.0),
                                      onPressed: () {},
                                      child: Text(
                                        "ENTREGAR EN",
                                        style: TextStyle(
                                          fontSize: 19.0,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: MaterialButton(
                                      padding: EdgeInsets.only(left: 18.0),
                                      onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DireccionScreen(),
                                          )),
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            carrito.direccion ??
                                                "No encontrada",
                                            overflow: TextOverflow.fade,
                                            style: TextStyle(
                                              fontSize: 18.0,
                                            ),
                                            maxLines: 1,
                                          ),
                                          Icon(
                                            Icons.keyboard_arrow_down,
                                            color: Color(0xFFf15a24),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Flexible(child: searchBar),
                      ],
                    ),
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
            _products.length == 0
                ? SliverToBoxAdapter(
                    child: Container(
                      child: Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Color(0xFFf15a24),
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    ),
                  )
                : SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2 / 3,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Container(
                              height: 200.0,
                              child: MaterialButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductoScreen(
                                      pdr: _products[index],
                                    ),
                                  ),
                                ),
                                padding: EdgeInsets.all(0.0),
                                child: Card(
                                  elevation: 3,
                                  child: Column(
                                    children: [
                                      Flexible(
                                        flex: 3,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  _products[index].imgUrl),
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Flexible(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 2.0, left: 5.0),
                                                child: Text(
                                                  _products[index]
                                                      .nombreProducto,
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                                  "\$${_products[index].precio}",
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
                          ),
                        );
                      },
                      childCount: _products.length,
                    ),
                  )
          ],
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
