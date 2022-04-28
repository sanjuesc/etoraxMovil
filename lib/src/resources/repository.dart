import 'dart:async';
import 'etorax_api_provider.dart';
import 'etorax_db_provider.dart';
import '../models/ejercicio.dart';


class Repository {
  List<Source> sources = <Source>[
    EtoraxDbProvider(),
    EtoraxAPIProvider()
  ];


  List<Cache> caches = <Cache>[
    EtoraxDbProvider()
  ];

  Future<List<int>>? fetchEjercicios(){
    print("fetchEjercicios");
    return sources[1].fetchEjercicios();

  }

  Future<Ejercicio?> fetchEjercio(int tratEjerId) async {
    Ejercicio? item;
    var source;

    for(source in sources){
      item = await source.fetchEjercicio(tratEjerId);
      if (item!=null){
        break;
      }
    }

    for (var cache in caches){
      cache.addItem(item!);
    }

    return item;
  }

  clearCache() async {
    for (var cache in caches){
      await cache.clear();
    }
  }

}

abstract class Source{
  Future<List<int>>? fetchEjercicios();
  Future<Ejercicio?> fetchEjercicio(int tratEjerId);
}

abstract class Cache{
  Future<int>? addItem(Ejercicio ejer);
  clear();


}