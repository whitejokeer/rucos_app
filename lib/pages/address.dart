import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/carrito.dart';
import 'skeleton.dart';

class DireccionScreen extends StatefulWidget {
  @override
  _DireccionScreenState createState() => _DireccionScreenState();
}

class _DireccionScreenState extends State<DireccionScreen> {
  final formKey = new GlobalKey<FormState>();
  String _tipoVia, _numeroVia, _segundaVia, _referencia;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final carrito = Provider.of<CarritoInfo>(context);

    final tipoVia = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: TextFormField(
        textCapitalization: TextCapitalization.sentences,
        autofocus: false,
        validator: (val) {
          return val.isEmpty ? "Este campo es obligatorio" : null;
        },
        onSaved: (val) => _tipoVia = val,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.pin_drop),
          labelText: 'Tipo de Via',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        ),
      ),
    );

    final segundaVia = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        children: [
          Flexible(
            flex: 2,
            child: TextFormField(
              textCapitalization: TextCapitalization.sentences,
              autofocus: false,
              validator: (val) {
                return val.isEmpty ? "Este campo es obligatorio" : null;
              },
              onSaved: (val) => _numeroVia = val,
              decoration: InputDecoration(
                //prefixIcon: Icon(Icons.pin_drop),
                labelText: 'Numero',
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              ),
            ),
          ),
          SizedBox(
            width: 5.0,
          ),
          Flexible(
            flex: 3,
            child: TextFormField(
              textCapitalization: TextCapitalization.sentences,
              autofocus: false,
              validator: (val) {
                return val.isEmpty ? "Este campo es obligatorio" : null;
              },
              onSaved: (val) => _segundaVia = val,
              decoration: InputDecoration(
                //prefixIcon: Icon(Icons.pin_drop),
                labelText: '#Segunda Via',
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              ),
            ),
          ),
        ],
      ),
    );

    final referencia = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: TextFormField(
        textCapitalization: TextCapitalization.sentences,
        maxLines: 4,
        autofocus: false,
        validator: null,
        onSaved: (val) => _referencia = val,
        decoration: InputDecoration(
          labelText: 'Referencia dirección',
          alignLabelWithHint: true,
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
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
                  formKey.currentState.save();
                  auth.authStateChanges().listen(
                        (currentUser) => firestore
                            .collection("users")
                            .doc(currentUser.uid)
                            .collection("direcciones")
                            .doc('1')
                            .update({
                          "numeroVia": _numeroVia,
                          "referencia": _referencia,
                          "segundaVia": _segundaVia,
                          "tipoVia": _tipoVia
                        }).then(
                          (value) {
                            carrito.direccion =
                                "$_tipoVia $_numeroVia #$_segundaVia";
                            carrito.especificaciones = "$_referencia";
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EsqueletoScreen(),
                              ),
                            );
                          },
                        ),
                      );
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
          "Nueva direccion",
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
                tipoVia,
                segundaVia,
                referencia,
              ],
            ),
          ),
          guardar,
        ],
      ),
    );
  }
}
