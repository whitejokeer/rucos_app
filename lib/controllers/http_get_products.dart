import 'package:rucos_app/models/categorias.dart';

import '../models/producto.dart';
import '../models/especificaciones.dart';

import 'package:dio/dio.dart';

class ProductProvider {
  /// This function get the products from the web server and map them into a Product list
  Future<List<Producto>> getProducts() async {
    List<Producto> datos = [];
    try {
      Dio dio = new Dio();

      dio.options.baseUrl = "https://rucosweb.herokuapp.com";
      dio.options.connectTimeout = 15000; // 15 seconds
      dio.options.receiveTimeout = 15000; // 15 seconds

      Response productos = await dio.get("/productos");

      var productosMap = productos.data;

      productosMap.forEach(
        (dataMap) async {
          List<Especificaciones> esp = [];
          dataMap["EspecificacionesDetalle"].forEach(
            (dataInfo) async {
              esp.add(Especificaciones.map(dataInfo));
            },
          );
          Producto _producto = Producto.map(dataMap, esp);
          datos.add(_producto);
        },
      );
      return datos;
    } catch (e) {
      print(e);
      return datos;
    }
  }

  Future<List<Categorias>> getCategorias() async {
    List<Categorias> categoriaList = [];
    try {
      Dio dio = new Dio();

      dio.options.baseUrl = "https://rucosweb.herokuapp.com";
      dio.options.connectTimeout = 15000; // 15 seconds
      dio.options.receiveTimeout = 15000; // 15 seconds

      Response categorias = await dio.get("/categorias");

      var categoriasMap = categorias.data;

      categoriasMap.forEach(
        (dataMap) async {
          List<Producto> pdr = [];
          dataMap['productos'].forEach(
            (dataInfo) async {
              List<Especificaciones> esp = [];
              dataInfo['EspecificacionesDetalle'].forEach(
                (especInfo) async {
                  esp.add(Especificaciones.map(especInfo));
                },
              );
              pdr.add(Producto.map(dataInfo, esp));
            },
          );

          categoriaList.add(Categorias.map(dataMap, pdr));
        },
      );
      return categoriaList;
    } catch (e) {
      print(e);
      return categoriaList;
    }
  }
}
