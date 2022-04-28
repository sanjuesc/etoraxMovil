import 'dart:async';
import 'package:etorax/src/blocs/validators.dart';
import 'package:rxdart/rxdart.dart';
import '../models/ejercicio.dart';
import '../resources/repository.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../globals.dart' as globals;
class EjercBloc extends Object with Validators{
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

  Future<bool> ejercCompletado(String ejerId, String tratId) async{
    Response response = await getCompletado(globals.usuario, ejerId, tratId);
    final ids = json.decode(response.body);
    bool algo = validarRespuesta(ids, response.statusCode);
    return algo;
  }

  Future<Response> getCompletado(String nombre, String ejerId, String tratId) {
    print("$nombre $ejerId $tratId");

    return post(
      Uri.parse('http://'+dotenv.env['local']!+'/paciente/getTEActivo'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'access-token': globals.token,
      },
      body: jsonEncode(<String, String>{
        'pacId': nombre,
        'tratId' : tratId,
        'ejerId' : ejerId
      }),
    );
  }
  dispose() {
    _idsTratEjer.close();
    _itemsFetcher.close();
    _itemsOutput.close();
  }
}
