import 'dart:ffi';

import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import '../globals.dart' as globals;
import '../widgets/drawer.dart';
class PreguntasDiarias extends StatefulWidget{

  State<StatefulWidget> createState() {
    return PreguntasDiariasState();
  }

}

enum AppState {
  INICIO,
  RESPONDIDAS,
  CARGADO
}

class PreguntasDiariasState extends State<PreguntasDiarias> {
  AppState _state = AppState.INICIO;
  late List<dynamic> datos;
  bool haRespondido = false;
  @override
  initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(_state);
    if(_state == AppState.INICIO){
      hayPreguntas(context);
      return Scaffold(
        drawer: MiDrawer(),
        appBar: AppBar(title: Text("eTorax 2.0"),),
        body: CircularProgressIndicator(),
      );
    }else{
      if(_state==AppState.CARGADO){
        if(haRespondido){
          return Scaffold(
            drawer: MiDrawer(),
            appBar: AppBar(title: Text("eTorax 2.0"),),
            body: Text("Ya has completado tus preguntas para el dia de hoy"),
          );
        }else{
          getPreguntas(context);
          return Scaffold(
            drawer: MiDrawer(),
            appBar: AppBar(title: Text("eTorax 2.0"),),
            body: CircularProgressIndicator(),
          );
        }
      }else{
        if(_state == AppState.RESPONDIDAS){
          datos.forEach((element) {
            Map<String, dynamic> algo = Map.from(element);
            print(algo);
          });
          return Scaffold(
              drawer: MiDrawer(),
              appBar: AppBar(title: Text("eTorax 2.0"),),
              body: Text("ey"),
          );
        }else{
          return Scaffold(
            drawer: MiDrawer(),
            appBar: AppBar(title: Text("eTorax 2.0"),),
            body: CircularProgressIndicator(),
          );
        }
      }
    }

  }


  hayPreguntas(BuildContext context) async {
    Client client = Client();
    final respuesta = await client.post(
      Uri.parse('http://'+dotenv.env['server']!+'/paciente/preguntasHoy'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'access-token': globals.token,
      },
      body: jsonEncode(<String, String>{
        'pacId': globals.usuario,
      }),
    );
    Map<String, dynamic> data = jsonDecode(respuesta.body);
    if(data['token']!=null) {
      globals.token = data['token'];
    }
    print(data);
    haRespondido = data['mensaje'];
    setState(() {
      _state=AppState.CARGADO;
    });
  }


  getPreguntas(BuildContext context) async {
    Client client = Client();
    final respuesta = await client.post(
      Uri.parse('http://'+dotenv.env['server']!+'/paciente/getPreguntas'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'access-token': globals.token,
      },
      body: jsonEncode(<String, String>{
        'pacId': globals.usuario,
      }),
    );
    List<dynamic> data = jsonDecode(respuesta.body);
    datos = data;
    setState(() {
      _state=AppState.RESPONDIDAS;
    });

  }
  
}
