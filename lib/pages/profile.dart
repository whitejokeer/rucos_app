import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'update_password.dart';

class PerfilScreen extends StatefulWidget {
  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  String nombre = "";
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final nombre = Text(
      "Perfil",
      style: TextStyle(
        color: Color(0xFFf15a24),
      ),
    );
    final cerrarSesion = ListTile(
      leading: Icon(
        Icons.exit_to_app,
        color: Color(0xFFf15a24),
      ),
      onTap: () => FirebaseAuth.instance
          .signOut()
          .then((value) => Navigator.pushReplacementNamed(context, "/login")),
      title: Text("Cerrar Sesion"),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: nombre,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Color(0xFFf15a24),
        ),
      ),
      body: Column(
        children: [
          ListTile(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ActualizarScreen(),
              ),
            ),
            leading: Icon(
              Icons.lock,
              color: Color(0xFFf15a24),
            ),
            title: Text("Cambiar contraseña"),
          ),
          Divider(),
          ListTile(
            onTap: () => launch("whatsapp://send?phone=+573147251438"),
            leading: Icon(
              Icons.call,
              color: Color(0xFFf15a24),
            ),
            title: Text("Contactar Supermercado"),
          ),
          Divider(),
          cerrarSesion,
        ],
      ),
    );
  }
}
