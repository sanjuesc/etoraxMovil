import 'package:flutter/material.dart';
import '../widgets/drawer.dart';
import '../globals.dart' as globals;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart';

class MisDetalles extends StatelessWidget {
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, AsyncSnapshot<Map<String, dynamic>> datosSnap){
        if (!datosSnap.hasData){
          return Scaffold(
            drawer: MiDrawer(),
            appBar: AppBar(title: Text("eTorax 2.0"),),
            body: Text('No hay info'),
          );
        }else{
          return Scaffold(
            drawer: MiDrawer(),
            appBar: AppBar(title: Text("eTorax 2.0"),),
            body: Text(datosSnap.data!['mensaje'].toString()),
          );
        }
      },
      future: completar(context),
    );
  }



  Future<Map<String, dynamic>> completar(BuildContext context) async {
    Client client = Client();
    final respuesta = await client.post(
      Uri.parse('http://'+dotenv.env['server']!+'/paciente/detalles'),
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