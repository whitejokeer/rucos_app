import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'skeleton.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = new GlobalKey<FormState>();
  final formKey2 = new GlobalKey<FormState>();
  String _email, _password, _forgotPassword;

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email no valido';
    } else {
      return null;
    }
  }

  loginRequest() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      Navigator.of(context).pushReplacementNamed("/home");
/*       api.login(_email, _password, context); */
    }
  }

  resetPasswordRequest() async {
    final form = formKey2.currentState;

    if (form.validate()) {
      form.save();
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _forgotPassword.trim())
          .then((value) => Navigator.of(context).pop())
          .catchError(
        (e) {
          Navigator.of(context).pop();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("UPS!"),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                content: Text(
                    "No encontramos a nadie con ese correo, prueba registrandote"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Volver"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text("Registrar"),
                    onPressed: () {
                      Navigator.of(context).pushNamed("/register");
                    },
                  )
                ],
              );
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: "logo",
      child: Container(
        height: 200.0,
        width: 150.0,
        child: Image.asset("assets/Logo.png"),
      ),
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      validator: emailValidator,
      onSaved: (val) => _email = val,
      decoration: InputDecoration(
        hintText: 'Correo',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      autofocus: false,
      obscureText: true,
      validator: (val) {
        return val.isEmpty ? "Este campo es obligatorio" : null;
      },
      onSaved: (val) => _password = val,
      decoration: InputDecoration(
        hintText: 'Contraseña',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Padding(
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
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Container(
                        height: 100.0,
                        child: Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Color(0xFFf15a24),
                            valueColor:
                                new AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ),
                    );
                  },
                );
                if (formKey.currentState.validate()) {
                  formKey.currentState.save();
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: _email.trim(), password: _password.trim())
                      .then(
                        (currentUser) => FirebaseFirestore.instance
                            .collection("users")
                            .doc(currentUser.user.uid)
                            .get()
                            .then(
                              (DocumentSnapshot result) =>
                                  Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EsqueletoScreen(),
                                ),
                                (_) => false,
                              ),
                            )
                            .catchError((err) {
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("UPS!"),
                                content:
                                    Text("Usuario o contraseña incorrecto"),
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
                        }),
                      )
                      .catchError(
                        (err) => showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("UPS!"),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0))),
                                content:
                                    Text("Usuario o contraseña incorrecto"),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text("Volver"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            }),
                      );
                }
              },
              child: Text('INGRESAR', style: TextStyle(color: Colors.white)),
            ),
          ),
        ),
      ),
    );

    final forgotLabel = Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        child: Text(
          'Recuperar contraseña',
          style: TextStyle(color: Colors.black54),
        ),
        onPressed: () => showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Ingrese tu Correo!"),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              content: Form(
                key: formKey2,
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  autofocus: false,
                  validator: emailValidator,
                  onSaved: (val) => _forgotPassword = val,
                  decoration: InputDecoration(
                    hintText: 'Correo registrado',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                  ),
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("Volver"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text("Mandar"),
                  onPressed: resetPasswordRequest,
                )
              ],
            );
          },
        ),
      ),
    );

    final registarLabel = Container(
      alignment: Alignment.center,
      child: FlatButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'No tienes cuenta? ',
              style: TextStyle(color: Colors.black54),
            ),
            Text(
              'Registrate',
              style:
                  TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        onPressed: () => Navigator.of(context).pushNamed("/register"),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 15.0),
            Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  email,
                  SizedBox(height: 8.0),
                  password,
                ],
              ),
            ),
            forgotLabel,
            loginButton,
            registarLabel
          ],
        ),
      ),
    );
  }
}
