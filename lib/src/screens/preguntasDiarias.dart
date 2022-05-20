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

class PreguntasDiariasState extends State<PreguntasDiarias> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MiDrawer(),
        appBar: AppBar(title: Text("eTorax 2.0"),),
        body: FutureBuilder(
          builder: (context, AsyncSnapshot<Map<String, dynamic>> datosSnap){
            if(!datosSnap.hasData){
              return CircularProgressIndicator();
            }else{
              bool respuesta  = datosSnap.data!['mensaje'];
              if(!respuesta){
                return Text("Ya has completado tus preguntas para el dia de hoy");
              }else{
                return Text("responder");
              }
            }
          },
          future:completar(context),
        ),
    );





  }


  Future<Map<String, dynamic>> completar(BuildContext context) async {
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
    return data;
  }
  
}
