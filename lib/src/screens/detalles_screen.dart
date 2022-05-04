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
            if (snapshot.data!['tipo']==1) { //si es caminar quiero healthapp
              return SlidingUpPanel(
                panel: Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: videoWidget(snapshot.data!['video']),
                ),
                body: Center(
                  child: HealthApp(),
                ),
                maxHeight: 480.0,
              );
            }else{ //si no ejercicio estandar
             return Text(ejer.descri);
            }
          }else{
            return CircularProgressIndicator();
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
        autoPlay: true,
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
      return data;
    }else{
      return jsonDecode(response.body);
    }
  }

  Future<Response> peticionOtros() {
    return post(
      Uri.parse('http://'+dotenv.env['server']!+'/paciente/detalleEjer'),
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



}
