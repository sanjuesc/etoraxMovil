import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../models/ejercicio.dart';
import '../resources/repository.dart';

class EjercBloc {
  final _repository = Repository();
  final _idsTratEjer = PublishSubject<List<int>>();
  final _itemsOutput = BehaviorSubject<Map<int, Future<Ejercicio?>>>();
  final _itemsFetcher = PublishSubject<int>();

  Stream<List<int>> get idsTE => _idsTratEjer.stream;
  Stream<Map<int, Future<Ejercicio?>>> get items => _itemsOutput.stream;

  Function(int) get fetchItem => _itemsFetcher.sink.add;

  EjercBloc() {
    _itemsFetcher.stream.transform(_itemsTransformer()).pipe(_itemsOutput);
  }

  fetchEjercicios() async {
    final ids = await _repository.fetchEjercicios();
    _idsTratEjer.sink.add(ids!);
  }

  clearCache(){
    return _repository.clearCache();
  }

  _itemsTransformer() {
    return ScanStreamTransformer(
          (Map<int, Future<Ejercicio?>> cache, int id, index) {
        cache[id] = _repository.fetchEjercio(id);
        return cache;
      },
      <int, Future<Ejercicio?>>{},
    );
  }

  dispose() {
    _idsTratEjer.close();
    _itemsFetcher.close();
    _itemsOutput.close();
  }
}
