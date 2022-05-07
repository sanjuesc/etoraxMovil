import 'dart:convert';
import 'package:etorax/src/globals.dart';

import '../globals.dart' as globals;
import 'package:http/http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/ejercicio.dart';
import 'repository.dart';



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
    //aqui habria que gestionar que el token estuviera expirado
    final ids = json.decode(respuesta.body);
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
    Map<String, dynamic> data = jsonDecode(respuesta.body);
    if(data['token']!=null) {
      globals.token = data['token'];
    }
    print("ALLEVOY");
    print(data);
    final parsedJson = json.decode(respuesta.body);
    return Ejercicio.fromJson(parsedJson);
  }




}