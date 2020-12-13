import 'producto.dart';

class Items {
  Producto product;
  int cantidad;
  int precioTotal;

  Items.map(Producto pdr, int cant)
      : product = pdr,
        cantidad = cant,
        precioTotal = pdr.precio * cant;
}
