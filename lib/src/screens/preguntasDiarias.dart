

import 'package:etorax/src/widgets/preguntas/tipo5.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import '../globals.dart' as globals;
import '../widgets/drawer.dart';
import '../widgets/preguntas/tipo1.dart';
import '../widgets/preguntas/tipo2.dart';
import '../widgets/preguntas/tipo3.dart';
import '../widgets/preguntas/tipo4.dart';
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
          List<Map<dynamic, dynamic>> preguntas = [];
          int i = 0;
          datos.forEach((element) {
            Map<dynamic, dynamic> algo = Map.from(element);
            preguntas.add(algo);
            i++;
          });
          return Scaffold(
              drawer: MiDrawer(),
              appBar: AppBar(title: Text("eTorax 2.0"),),
              body: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  switch (preguntas[index]['tipo']){
                    case 1:
                      return ExpansionTile(
                        title: Text(preguntas[index]['texto']),
                        subtitle: Text(preguntas[index]['periodo']),
                        children: [
                          Tipo1(
                              idPreg: preguntas[index]['idPreg'].toString(),
                              idTrat: preguntas[index]['idTrat'].toString()
                          ),
                        ],
                        maintainState: true,
                      );
                    case 2:
                      return ExpansionTile(
                        title: Text(preguntas[index]['texto']),
                        subtitle: Text(preguntas[index]['periodo']),
                        children: [
                          Tipo2(
                              idPreg: preguntas[index]['idPreg'].toString(),
                              idTrat: preguntas[index]['idTrat'].toString()
                          ),
                        ],
                        maintainState: true,
                      );
                    case 3:
                      return ExpansionTile(
                        title: Text(preguntas[index]['texto']),
                        subtitle: Text(preguntas[index]['periodo']),
                        children: [
                          Tipo3(
                              idPreg: preguntas[index]['idPreg'].toString(),
                              idTrat: preguntas[index]['idTrat'].toString()
                          ),
                        ],
                        maintainState: true,
                      );
                    case 4:
                      return ExpansionTile(
                        title: Text(preguntas[index]['texto']),
                        subtitle: Text(preguntas[index]['periodo']),
                        children: [
                          Tipo4(
                              idPreg: preguntas[index]['idPreg'].toString(),
                              idTrat: preguntas[index]['idTrat'].toString()
                          ),
                        ],
                        maintainState: true,
                      );
                    case 5:
                      return ExpansionTile(
                        title: Text(preguntas[index]['texto']),
                        subtitle: Text(preguntas[index]['periodo']),
                        children: [
                          Tipo5(
                              idPreg: preguntas[index]['idPreg'].toString(),
                              idTrat: preguntas[index]['idTrat'].toString()
                          ),                        ],
                        maintainState: true,
                      );
                    default:
                      return ExpansionTile(
                        title: Text(preguntas[index]['texto']),
                        subtitle: Text(preguntas[index]['periodo']),
                        children: [
                          Text(preguntas[index]['tipo'].toString()),
                        ],
                        maintainState: true,
                      );
                  }
                },
                itemCount: preguntas.length,
              ),
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
      Uri.parse('https://'+dotenv.env['server']!+'/paciente/preguntasHoy'),
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
    haRespondido = data['data'];
    setState(() {
      _state=AppState.CARGADO;
    });
  }


  getPreguntas(BuildContext context) async {
    Client client = Client();
    final respuesta = await client.post(
      Uri.parse('https://'+dotenv.env['server']!+'/paciente/getPreguntas'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'access-token': globals.token,
      },
      body: jsonEncode(<String, String>{
        'pacId': globals.usuario,
      }),
    );
    Map<String, dynamic> data = jsonDecode(respuesta.body);
    List<dynamic> datosAPI = data['data'];
    print(data);
    if(data['token']!=null) {
      globals.token = data['token'];
    }
    datos = datosAPI;
    setState(() {
      _state=AppState.RESPONDIDAS;
    });

  }
  
}
