import 'especificaciones.dart';

class Producto {
  String id, nombreProducto, caracteristicas, imgUrl;
  int precio;
  List<Especificaciones> especificaciones;

  Producto.map(Map<String, dynamic> parsedJson, List<Especificaciones> esp)
      : id = parsedJson["_id"],
        nombreProducto = parsedJson["NombreProducto"],
        precio = parsedJson["Precio"],
        caracteristicas = parsedJson["Caracteristicas"],
        imgUrl = parsedJson["ImagenProducto"]["url"],
        especificaciones = esp;
}
