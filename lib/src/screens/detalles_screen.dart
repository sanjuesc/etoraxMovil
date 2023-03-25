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
final PanelController pc = PanelController();
class DetallesScreen extends StatelessWidget{

  final Ejercicio ejer;
  const DetallesScreen({Key? key, required this.ejer}) : super (key : key);

  Widget build(BuildContext context) {
    SlidingUpPanel panel;
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
                panel = SlidingUpPanel(
                    controller: pc,
                    collapsed: getCollapsed(),
                    panel: Container(
                      height: double.infinity,
                      width: double.infinity,
                      child: videoWidget(snapshot.data!['video']),
                    ),
                    body: HealthApp(ejerc: ejer, pc: pc),
                    maxHeight: 480.0,
                    minHeight: 120.0
                );
              }else{ //si no ejercicio estandar
                if(ejer.completado==1){
                  panel = SlidingUpPanel(
                      controller: pc,
                      collapsed: getCollapsed(),
                      panel: Container(
                        height: double.infinity,
                        width: double.infinity,
                        child: videoWidget(snapshot.data!['video']),
                      ),
                      body: Align(
                        child: ejercicioEstandarTerminado(ejer, pc),
                        alignment: Alignment.topCenter,
                      ),
                      maxHeight: 480.0,
                      minHeight: 120.0
                  );
                }else{
                  panel = SlidingUpPanel(
                      controller: pc,
                      collapsed: getCollapsed(),
                      panel: Container(
                        height: double.infinity,
                        width: double.infinity,
                        child: videoWidget(snapshot.data!['video']),
                      ),
                      body: Align(
                        child: ejercicioEstandar(ejer, context, pc),
                        alignment: Alignment.topCenter,
                      ),
                      maxHeight: 480.0,
                      minHeight: 120.0
                  );
                }
              }
            }
            return panel;
          }else{
            return  Center(child: CircularProgressIndicator(),);
          }
        },
        future: obtenerOtros(),
      ),
    );
  }

  getCollapsed(){
    return Container(
      decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          )
      ),
      child: Center(
        child: Text(
          "Desliza hacia arriba para ver un video explicativo",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  videoWidget(vidId) {

    if(vidId.runtimeType == String){
      YoutubePlayerController _controller = YoutubePlayerController(
        initialVideoId: vidId,
        flags: YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          loop: true,
        ),
      );
      return
        Container(
            child:  YoutubePlayer(
              controller: _controller,
              bottomActions: [CurrentPosition(),
                ProgressBar(isExpanded: true,),],
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.amber,
              onReady: () {
                _controller.addListener(() {
                },);
              },
            )
        );
    }else{
      YoutubePlayerController _controller = YoutubePlayerController(
        initialVideoId: vidId.first,
        flags: YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          loop: true,
        ),
      );
      return
        Container(
            child:  YoutubePlayer(
              controller: _controller,
              bottomActions: [CurrentPosition(),
                ProgressBar(isExpanded: true,),],
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.amber,
              onReady: () {
                _controller.addListener(() {
                },);
              },
              onEnded: (data){
                _controller
                    .load(vidId[(vidId.indexOf(data.videoId) + 1) % vidId.length]);
              },
            )
        );
    }
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

  Widget ejercicioEstandar(Ejercicio ejer, BuildContext context, PanelController pc) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.pending_actions, color: Colors.red),
            title: Text(ejer.nombre),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                child: Text(
                  "Objetivo: ${ejer.repeticiones} repeticiones de ${ejer.cantidad} ${ejer.unidad}",
                  style: TextStyle(color: Colors.black.withOpacity(0.6)),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 0.0),
                child: Text(
                  "Descripción del ejercicio:",
                  style: TextStyle(color: Colors.black.withOpacity(0.6)),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 8.0),
                child: Text(
                  "${ejer.descri}",
                  style: TextStyle(color: Colors.black.withOpacity(0.6)),
                ),
              ),
            ],
          ),
          ButtonBar(
            alignment: MainAxisAlignment.start,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20, color: Color(0xFF6200EE)),
                ),
                onPressed: () {
                  completar(context);
                },
                child: const Text("Finalizar ejercicio"),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20, color: Color(0xFF6200EE)),
                ),
                onPressed: () {
                  pc.isAttached ? pc.open() : print("no estaba");
                },
                child: const Text("Ver video"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ejercicioEstandarTerminado(Ejercicio ejer, PanelController pc) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.check, color: Colors.green),
            title: Text(ejer.nombre),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                child: Text(
                  "Objetivo: ${ejer.repeticiones} repeticiones de ${ejer.cantidad} ${ejer.unidad}",
                  style: TextStyle(color: Colors.black.withOpacity(0.6)),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 0.0),
                child: Text(
                  "Descripción del ejercicio:",
                  style: TextStyle(color: Colors.black.withOpacity(0.6)),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 8.0),
                child: Text(
                  "${ejer.descri}",
                  style: TextStyle(color: Colors.black.withOpacity(0.6)),
                ),
              ),
            ],
          ),
          ButtonBar(
            alignment: MainAxisAlignment.start,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20, color: Color(0xFF6200EE)),
                ),
                onPressed: () {
                  pc.isAttached ? pc.open() : print("no estaba");
                },
                child: const Text("Ver video"),
              ),
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
