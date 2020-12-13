class Especificaciones {
  String titulo, especificacion;

  Especificaciones.map(Map<String, dynamic> parsedJson)
      : titulo = parsedJson["Titulo"],
        especificacion = parsedJson["Especificacion"];
}
