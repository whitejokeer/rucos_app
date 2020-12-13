import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'skeleton.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;
  String userid;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  startTimer() {
    var duration = new Duration(seconds: 2);
    return new Timer(duration, navigatorPage);
  }

  navigatorPage() {
    auth.authStateChanges().listen((currentUser) => (currentUser == null)
        ? Navigator.pushReplacementNamed(context, "/login")
        : firestore
            .collection("users")
            .doc(currentUser.uid)
            .collection("direcciones")
            .doc("1")
            .get()
            .then(
            (DocumentSnapshot result) {
              print(result['tipoVia']);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => EsqueletoScreen(),
                ),
              );
            },
          ).catchError((err) => print(err)));
  }

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: 1,
      ),
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );
    animationController.forward();
    startTimer();
    super.initState();
  }

  @override
  dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: ScaleTransition(
              scale: animation,
              child: Hero(
                tag: "logo",
                child: Container(
                  color: Colors.transparent,
                  width: 250.0,
                  child: Image.asset("assets/Logo.png"),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
