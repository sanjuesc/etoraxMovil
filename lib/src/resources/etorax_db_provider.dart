import '../globals.dart' as globals;
import '../models/ejercicio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'repository.dart';

class EtoraxDbProvider implements Source, Cache{
  Database? db;

  EtoraxDbProvider(){
    init();
  }

  void init() async{
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, "ejercicios.db");
    db = await openDatabase(
      path,
      version: 4,
      onCreate: (Database newDb, int Version){
        newDb.execute("""
          CREATE TABLE Ejercicios
            ( idTratEjer INTEGER PRIMARY KEY,
              idTrat INTEGER,
              idEjer INTEGER,
              nombre TEXT,
              descri TEXT, 
              repeticiones INTEGER,
              freq INTEGER,
              unidad TEXT,
              cantidad INTEGER,
              completado INTEGER
            )
        """);
      }
    );
  }

  Future<Ejercicio?> fetchEjercicio(int tratEjerId) async{
    final db = this.db;
    if(db!=null){
      final maps = await db.query(
        "Ejercicios",
        columns: null,
        where: "idTratEjer = ?",
        whereArgs: [tratEjerId]
      );
      if (maps.isNotEmpty){
        print("recuperamos de db");
        print(maps.first);
        return Ejercicio.fromDb(maps.first);
      }
      return null;
    }
  }

  Future<int>? addItem(Ejercicio ejer){
    return db?.insert("Ejercicios", ejer.toMap(), );

  }

  Future<int> clear() async{
    return await db!.delete("Ejercicios");
  }


  @override
  Future<List<int>>? fetchEjercicios() {
    return null;
  }





}