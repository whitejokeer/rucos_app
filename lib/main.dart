import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'pages/login.dart';
import 'pages/register.dart';
import 'pages/skeleton.dart';
import 'pages/splash.dart';
import 'providers/carrito.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .whenComplete(() => runApp(RucosApp()));
}

class RucosApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CarritoInfo(),
      child: MaterialApp(
        title: 'Domicilios Ruco',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Color(0xFFf15a24),
        ),
        routes: routes,
      ),
    );
  }
}

final routes = {
  "/": (BuildContext context) => SplashScreen(),
  "/login": (BuildContext context) => LoginScreen(),
  "/register": (BuildContext context) => RegisterScreen(),
  "/home": (BuildContext context) => EsqueletoScreen(),
};
