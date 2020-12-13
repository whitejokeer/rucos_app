import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ActualizarScreen extends StatefulWidget {
  @override
  _ActualizarScreenState createState() => _ActualizarScreenState();
}

class _ActualizarScreenState extends State<ActualizarScreen> {
  final formKey = new GlobalKey<FormState>();
  String _contrasena, _ncontrasena;

  FirebaseAuth auth = FirebaseAuth.instance;

  String pwdValidator(String value) {
    if (value.length < 6) {
      return 'La Contraseña debe tener minimo 6 caracteres';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final contrasena = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: TextFormField(
        autofocus: false,
        obscureText: true,
        validator: pwdValidator,
        onSaved: (val) => _contrasena = val,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          labelText: 'Nueva Contraseña',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        ),
      ),
    );

    final contrasena2 = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: TextFormField(
        autofocus: false,
        obscureText: true,
        validator: pwdValidator,
        onSaved: (val) => _ncontrasena = val,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock),
          labelText: 'Verificar Contraseña',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        ),
      ),
    );

    final guardar = Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 60.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.lightBlueAccent.shade100,
        elevation: 5.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Container(
            padding: EdgeInsets.all(0.0),
            color: Color(0xFFf15a24),
            child: MaterialButton(
              minWidth: 200.0,
              height: 55.0,
              onPressed: () async {
                if (formKey.currentState.validate()) {
                  if (_contrasena.trim() == _ncontrasena.trim()) {
                    formKey.currentState.save();
                    auth.authStateChanges().listen((currentUser) {
                      currentUser.updatePassword(_contrasena);
                      Navigator.pop(context);
                    });
                  }
                }
              },
              child: Text(
                'Actualizar',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text(
          "Cambiar Contraseña",
          style: TextStyle(
            color: Color(0xFFf15a24),
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Color(0xFFf15a24),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                contrasena,
                contrasena2,
              ],
            ),
          ),
          guardar,
        ],
      ),
    );
  }
}
