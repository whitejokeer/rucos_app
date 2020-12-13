import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/producto.dart';
import '../models/items.dart';

class CarritoInfo with ChangeNotifier {
  List<Items> items = [];
  String direccion, especificaciones, nombre, apellido, celular, uid;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CarritoInfo() {
    auth.authStateChanges().listen((currentUser) => (currentUser == null)
        ? direccion = "No encontrada"
        : firestore
            .collection("users")
            .doc(currentUser.uid)
            .collection("direcciones")
            .doc("1")
            .get()
            .then(
            (DocumentSnapshot result) {
              direccion =
                  "${result.data()['tipoVia']} ${result.data()['numeroVia']} #${result.data()['segundaVia']}";
              especificaciones = result.data()['referencia'];
            },
          ).catchError((err) => print(err)));

    auth.authStateChanges().listen((currentUser) => (currentUser == null)
        ? direccion = "No encontrada"
        : firestore.collection("users").doc(currentUser.uid).get().then(
            (DocumentSnapshot result) {
              uid = currentUser.uid;
              nombre = result.data()['nombre_usuario'];
              apellido = result.data()['apellido_usuario'];
              celular = result.data()['celular'];
            },
          ).catchError((err) => print(err)));
  }

  addItems(Producto item, int cant) {
    if (items.length > 0) {
      print("......................");
      print(item.id);
      Items itemFounded = items.firstWhere(
          (element) => element.product.id == item.id,
          orElse: () => null);
      print(itemFounded);
      if (itemFounded == null) {
        items.add(Items.map(item, cant));
      } else {
        for (int i = 0; i < items.length; i++) {
          if (items[i].product.id == item.id) {
            items[i] = Items.map(item, cant);
          }
        }
      }
    } else {
      items.add(Items.map(item, cant));
    }
  }

  eliminarItem(String id) {
    items.removeWhere((element) => element.product.id == id);
  }

  eliminarTodo() {
    items = [];
  }

  int getTotal() {
    int total = 0;
    for (int i = 0; i < items.length; i++) {
      total = total + items[i].precioTotal;
    }
    return total;
  }
}
