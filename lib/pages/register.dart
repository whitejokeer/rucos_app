import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rucos_app/providers/carrito.dart';

import 'skeleton.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = new GlobalKey<FormState>();
  String _name,
      _lastName,
      _cel,
      _email,
      _password,
      _verifyPassword,
      _addressType,
      _addressNumber,
      _addressSecondNumber,
      _reference;

  Future<Null> firebaseRegister() async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: _email.trim(), password: _password.trim())
        .then(
      (currentUser) async {
        FirebaseFirestore.instance
            .collection("users")
            .doc(currentUser.user.uid)
            .set({
              "id_usuario": currentUser.user.uid,
              "nombre_usuario": _name.trim(),
              "apellido_usuario": _lastName.trim(),
              "celular": _cel.trim(),
              "email": _email.trim(),
              "estado": true
            })
            .then(
              (result) async => await FirebaseFirestore.instance
                  .collection("users")
                  .doc(currentUser.user.uid)
                  .collection("direcciones")
                  .doc('1')
                  .set({
                    "tipoVia": _addressType.trim(),
                    "numeroVia": _addressNumber.trim(),
                    "segundaVia": _addressSecondNumber.trim(),
                    "referencia": _reference.trim() ?? "",
                  })
                  .then((value) => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EsqueletoScreen(),
                        ),
                        (_) => false,
                      ))
                  .catchError((err) => print(err)),
            )
            .catchError((err) => print(err));
      },
    ).catchError(
      (err) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Ups!"),
              content: Text("Ocurrio un error, vuelve a intentarlo"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Volver"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          },
        );
      },
    );
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Formato de email invalido';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 6) {
      return 'La Contraseña debe tener minimo 6 caracteres';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CarritoInfo>(context);

    final appBar = AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Color(0xFFf15a24),
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        "Registrate",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );

    final name = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: TextFormField(
        textCapitalization: TextCapitalization.sentences,
        keyboardType: TextInputType.text,
        autofocus: false,
        validator: (val) {
          return val.isEmpty ? "Este campo es obligatorio" : null;
        },
        onSaved: (val) => _name = val,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.person),
          labelText: 'Nombre',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        ),
      ),
    );

    final lastName = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: TextFormField(
        textCapitalization: TextCapitalization.sentences,
        keyboardType: TextInputType.text,
        autofocus: false,
        validator: (val) {
          return val.isEmpty ? "Este campo es obligatorio" : null;
        },
        onSaved: (val) => _lastName = val,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.person_outline),
          labelText: 'Apellido',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        ),
      ),
    );

    final celphone = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: TextFormField(
        keyboardType: TextInputType.phone,
        autofocus: false,
        validator: (val) {
          return val.isEmpty ? "Este campo es obligatorio" : null;
        },
        onSaved: (val) => _cel = val,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.phone),
          labelText: 'Celular',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        ),
      ),
    );

    final addressType = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: TextFormField(
        textCapitalization: TextCapitalization.sentences,
        autofocus: false,
        validator: (val) {
          return val.isEmpty ? "Este campo es obligatorio" : null;
        },
        onSaved: (val) => _addressType = val,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.pin_drop),
          labelText: 'Tipo de Via',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        ),
      ),
    );

    final addressNumbers = Padding(
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
              onSaved: (val) => _addressNumber = val,
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
              onSaved: (val) => _addressSecondNumber = val,
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

    final reference = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: TextFormField(
        textCapitalization: TextCapitalization.sentences,
        maxLines: 4,
        autofocus: false,
        validator: null,
        onSaved: (val) => _reference = val,
        decoration: InputDecoration(
          labelText: 'Referencia dirección',
          alignLabelWithHint: true,
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
      ),
    );

    final email = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: TextFormField(
        textCapitalization: TextCapitalization.sentences,
        validator: emailValidator,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        onSaved: (val) => _email = val,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.email),
          labelText: 'Correo',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        ),
      ),
    );

    final password = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: TextFormField(
        autofocus: false,
        obscureText: true,
        validator: pwdValidator,
        onSaved: (val) => _password = val,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          labelText: 'Contraseña',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        ),
      ),
    );

    final verifyPassword = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: TextFormField(
        autofocus: false,
        obscureText: true,
        validator: pwdValidator,
        onSaved: (val) => _verifyPassword = val,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock),
          labelText: 'Verificar Contraseña',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        ),
      ),
    );

    final register = Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 40.0),
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
                  if (_password.trim() == _verifyPassword.trim()) {
                    cart.direccion =
                        "$_addressType $_addressNumber #$_addressSecondNumber";
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Container(
                            height: 100.0,
                            child: Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Color(0xFFf15a24),
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                    firebaseRegister();
                  }
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Ups!"),
                        content: Text(
                            "Las Contraseñas no coinciden, vuelve a intentarlo"),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("Volver"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      );
                    },
                  );
                }
              },
              child: Text(
                'REGISTRARSE',
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
      appBar: appBar,
      body: ListView(
        children: <Widget>[
          Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                name,
                lastName,
                celphone,
                email,
                password,
                verifyPassword,
                addressType,
                addressNumbers,
                reference,
              ],
            ),
          ),
          register,
        ],
      ),
    );
  }
}
