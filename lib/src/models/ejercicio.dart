class Ejercicio {
  final int idTratEjer;
  final int idTrat;
  final int idEjer;
  final String nombre;
  final String descri;
  final int repeticiones;
  final int freq;
  final String unidad;
  final int cantidad;

  Ejercicio.fromJson(Map<String, dynamic> parsedJson)
    : idTratEjer = parsedJson['idTratEjer'] ?? 1,
      idTrat = parsedJson['idTrat'] ?? 1,
      idEjer = parsedJson['idEjer'] ?? 1,
      nombre = parsedJson['nombre'] ?? '',
      descri = parsedJson['descri'] ?? '',
      repeticiones = parsedJson['repeticiones'] ?? '',
      freq = parsedJson['freq'] ?? 1,
      unidad = parsedJson['unidad'] ?? '',
      cantidad = parsedJson['cantidad'] ?? 1;
  Ejercicio.fromDb(Map<String, dynamic> parsedJson)
      : idTratEjer = parsedJson['idTratEjer'] ?? 1,
        idTrat = int.parse(parsedJson['idTrat']),
        idEjer = int.parse(parsedJson['idEjer']),
        nombre = parsedJson['nombre']?? '',
        descri = parsedJson['descri']?? '',
        repeticiones = parsedJson['repeticiones']?? '',
        freq = parsedJson['freq'] ?? 1,
        unidad = parsedJson['unidad']?? '',
        cantidad = parsedJson['cantidad'] ?? 1;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "idTratEjer": idTratEjer,
      "idTrat": idTrat,
      "idEjer": idEjer,
      "nombre": nombre,
      "descri": descri,
      "repeticiones": repeticiones,
      "freq": freq,
      "unidad": unidad,
      "cantidad": cantidad,
    };
  }

}