import 'dart:convert';
import '../globals.dart' as globals;
import 'package:http/http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/ejercicio.dart';
import 'repository.dart';

const _root = 'https://hacker-news.firebaseio.com/v0';


class EtoraxAPIProvider implements Source{
  Client client = Client();


  Future<List<int>>? fetchEjercicios() async {
    print("hola");
    final respuesta = await client.post(
      Uri.parse('http://'+dotenv.env['server']!+'/paciente/getEjerciciosActuales'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'access-token': globals.token,
      },
      body: jsonEncode(<String, String>{
        'pacId': globals.usuario,
      }),
    );
    final ids = json.decode(respuesta.body);
    print(ids);
    return ids.cast<int>();
  }

  Future<Ejercicio?> fetchEjercicio(int tratEjerId) async {
    final respuesta = await client.post(
      Uri.parse('http://'+dotenv.env['server']!+'/paciente/getEjercicio'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'access-token': globals.token,
      },
      body: jsonEncode(<String, String>{
        'pacId': globals.usuario,
        'tratEjerId':tratEjerId.toString(),
      }),
    );
    final parsedJson = json.decode(respuesta.body);
    print(parsedJson);
    return Ejercicio.fromJson(parsedJson);
  }




}