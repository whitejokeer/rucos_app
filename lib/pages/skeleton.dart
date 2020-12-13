import 'package:flutter/material.dart';

import 'home.dart';
import 'order.dart';
import 'profile.dart';
import 'search.dart';
import 'sopping_cart.dart';

class EsqueletoScreen extends StatefulWidget {
  @override
  _EsqueletoScreenState createState() => _EsqueletoScreenState();
}

class _EsqueletoScreenState extends State<EsqueletoScreen> {
  //Propiedades
  int currentTap = 0;

  final List<Widget> screens = [
    CarritoScreen(),
    HomeScreen(),
    BuscarScreen(),
    PedidosScreen(),
    PerfilScreen(),
  ]; //Active P

  Widget currentScreen = HomeScreen();

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    //Bottom Icon Button
    final homeButton = MaterialButton(
      minWidth: 40,
      onPressed: () {
        setState(
          () {
            currentScreen = HomeScreen();
            currentTap = 0;
          },
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.store,
            color: currentTap == 0 ? Color(0xFFf15a24) : Colors.grey,
          ),
          Text(
            'Inicio',
            style: TextStyle(
              color: currentTap == 0 ? Color(0xFFf15a24) : Colors.grey,
            ),
          ),
        ],
      ),
    );

    final searchButton = MaterialButton(
      minWidth: 40,
      onPressed: () {
        setState(
          () {
            currentScreen = BuscarScreen();
            currentTap = 1;
          },
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.search,
            color: currentTap == 1 ? Color(0xFFf15a24) : Colors.grey,
          ),
          Text(
            'Busca',
            style: TextStyle(
              color: currentTap == 1 ? Color(0xFFf15a24) : Colors.grey,
            ),
          ),
        ],
      ),
    );

    final pedidosButton = MaterialButton(
      minWidth: 30,
      onPressed: () {
        setState(
          () {
            currentScreen = PedidosScreen();
            currentTap = 2;
          },
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.receipt,
            color: currentTap == 2 ? Color(0xFFf15a24) : Colors.grey,
          ),
          Text(
            'Pedidos',
            style: TextStyle(
              color: currentTap == 2 ? Color(0xFFf15a24) : Colors.grey,
            ),
          ),
        ],
      ),
    );

    final profileButton = MaterialButton(
      minWidth: 40,
      onPressed: () {
        setState(
          () {
            currentScreen = PerfilScreen();
            currentTap = 3;
          },
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.person,
            color: currentTap == 3 ? Color(0xFFf15a24) : Colors.grey,
          ),
          Text(
            'Perfil',
            style: TextStyle(
              color: currentTap == 3 ? Color(0xFFf15a24) : Colors.grey,
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),

      //Floating Car Button

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.local_grocery_store),
        backgroundColor: Color(0xFFf15a24),
        onPressed: () {
          setState(() {
            currentScreen = CarritoScreen();
            currentTap = 4;
          });
        },
      ),

      //Floating Car Position

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      //Bottom App Bar

      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  homeButton,
                  searchButton,
                ],
              ),
              Row(
                children: <Widget>[
                  pedidosButton,
                  profileButton,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
