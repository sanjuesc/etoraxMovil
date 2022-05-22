import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../models/ejercicio.dart';
import '../widgets/podometro.dart';
import 'package:http/http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../globals.dart' as globals;
import 'dart:convert';
class DetallesScreen extends StatelessWidget{

  final Ejercicio ejer;
  const DetallesScreen({Key? key, required this.ejer}) : super (key : key);


  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(ejer.nombre),
      ),
      body: FutureBuilder(
        builder: (context, AsyncSnapshot<Map<String, dynamic>>snapshot) {
          if(snapshot.hasData){
            if(snapshot.data!['mensaje'].toString().contains("expirado")){
              return Text("Tu sesión ha expirado");
            }else{
              if (snapshot.data!['tipo']==1) { //si es caminar quiero healthapp
                return SlidingUpPanel(
                  panel: Container(
                    height: double.infinity,
                    width: double.infinity,
                    child: videoWidget(snapshot.data!['video']),
                  ),
                  body: HealthApp(ejerc: ejer),
                  maxHeight: 480.0,
                );
              }else{ //si no ejercicio estandar
                if(ejer.completado==1){
                  return SlidingUpPanel(
                    panel: Container(
                      height: double.infinity,
                      width: double.infinity,
                      child: videoWidget(snapshot.data!['video']),
                    ),
                    body: Align(
                      child: ejercicioEstandarTerminado(ejer),
                      alignment: Alignment.topCenter,
                    ),
                    maxHeight: 480.0,
                  );
                }else{
                  return SlidingUpPanel(
                    panel: Container(
                      height: double.infinity,
                      width: double.infinity,
                      child: videoWidget(snapshot.data!['video']),
                    ),
                    body: Align(
                      child: ejercicioEstandar(ejer, context),
                      alignment: Alignment.topCenter,
                    ),
                    maxHeight: 480.0,
                  );
                }
              }
            }
          }else{
            return  Center(child: CircularProgressIndicator(),);
          }
        },
        future: obtenerOtros(),
      ),
    );
  }

  videoWidget(String vidId) {
    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: vidId,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        loop: true,
      ),
    );

    return YoutubePlayer(
      controller: _controller,
      bottomActions: [CurrentPosition(),
      ProgressBar(isExpanded: true,),],
      showVideoProgressIndicator: true,
      progressIndicatorColor: Colors.amber,
      onReady: () {
        _controller.addListener(() {

        },);
        },
    );
  }


  Future<Map<String, dynamic>> obtenerOtros() async{
    final response = await peticionOtros();
    if(response.statusCode==200){
      Map<String, dynamic> data = jsonDecode(response.body);
      if(data['token']!=null) {
        print(data['token']);
        globals.token = data['token'];
      }
      print(data);
      return data['data'];
    }else{
      return jsonDecode(response.body);
    }
  }

  Future<Response> peticionOtros() {
    return post(
      Uri.parse('https://'+dotenv.env['server']!+'/paciente/detalleEjer'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'access-token': globals.token,
      },
      body: jsonEncode(<String, String>{
        'pacId' : globals.usuario,
        'ejerId' : ejer.idEjer.toString()
      }),
    );
  }

  Widget ejercicioEstandar(Ejercicio ejer, BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.pending_actions, color: Colors.red),
            title: Text(ejer.nombre),
            subtitle: Text(ejer.descri),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text("Objetivo: ${ejer.repeticiones} repeticiones de ${ejer.cantidad} ${ejer.unidad}"),
            ],
          ),
          OutlinedButton(
            onPressed: () {
              completar(context);
            },
            child: Text("He finalizado  ✔"),
          ),
        ],
      ),
    );
  }

  ejercicioEstandarTerminado(Ejercicio ejer) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.check, color: Colors.green),
            title: Text(ejer.nombre),
            subtitle: Text(ejer.descri),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 20.0,),
              Flexible(child: Text("Objetivo: ${ejer.repeticiones} repeticiones de ${ejer.cantidad} ${ejer.unidad}", style: TextStyle(fontSize: 15)),),
            ],
          ),
        ],
      ),
    );


  }

  Future<void> completar(BuildContext context) async {
    Client client = Client();
    final respuesta = await client.post(
      Uri.parse('https://'+dotenv.env['server']!+'/paciente/completarEjer'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'access-token': globals.token,
      },
      body: jsonEncode(<String, String>{
        'pacId': globals.usuario,
        'idTratEjer': ejer.idTratEjer.toString(),
      }),
    );
    Map<String, dynamic> data = jsonDecode(respuesta.body);
    if(data['token']!=null) {
      globals.token = data['token'];
    }
    print("completarejer");
    print("ALLEVOY");
    print(data);
    if(data['data'].toString().contains("correctamente")){
      Navigator.popAndPushNamed(context, "menu");
    }
  }


}
