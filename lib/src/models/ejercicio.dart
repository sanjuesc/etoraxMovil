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
  final int completado;

  Ejercicio.fromJson(Map<String, dynamic> parsedJson)
    : idTratEjer = parsedJson['idTratEjer'] ?? 1,
      idTrat = parsedJson['idTrat'] ?? 1,
      idEjer = parsedJson['idEjer'] ?? 1,
      nombre = parsedJson['nombre'] ?? '',
      descri = parsedJson['descri'] ?? '',
      repeticiones = parsedJson['repeticiones'] ?? '',
      freq = parsedJson['freq'] ?? 1,
      unidad = parsedJson['unidad'] ?? '',
      cantidad = parsedJson['cantidad'] ?? 1,
      completado = parsedJson['completado'] ?? 0;
  Ejercicio.fromDb(Map<String, dynamic> parsedJson)
      : idTratEjer = parsedJson['idTratEjer'] ?? 1,
        idTrat = parsedJson['idTrat'],
        idEjer = parsedJson['idEjer'],
        nombre = parsedJson['nombre']?? '',
        descri = parsedJson['descri']?? '',
        repeticiones = parsedJson['repeticiones']?? '',
        freq = parsedJson['freq'] ?? 1,
        unidad = parsedJson['unidad']?? '',
        cantidad = parsedJson['cantidad'] ?? 1,
        completado = parsedJson['completado'] ?? 0;

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
      "completado": completado
    };
  }

}