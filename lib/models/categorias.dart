import 'package:rucos_app/models/producto.dart';

class Categorias {
  String nombreCategoria, urlImagenCategoria;
  List<Producto> productos;

  Categorias.map(Map<String, dynamic> parsedJson, List<Producto> productos)
      : nombreCategoria = parsedJson['NombreCategoria'],
        urlImagenCategoria = parsedJson['CategoriaImagen']['url'],
        productos = productos;
}
