import 'dart:async';
import 'package:http/http.dart';
import 'dart:convert';
import '../globals.dart' as globals;
import 'package:flutter_dotenv/flutter_dotenv.dart';


class Enviar{



  Future<int> obtenerOtros(String resp, String otro, String idTrat, String idPreg) async{
    final response = await peticionOtros(resp, otro, idTrat,idPreg);
    if(response.statusCode==200){
      Map<String, dynamic> data = jsonDecode(response.body);
      if(data['token']!=null) {
        print(data['token']);
        globals.token = data['token'];
      }
      print(data);
      return data['codigo'];
    }else{
      print("mal");
      return 400;
    }
  }


  Future<Response> peticionOtros(String resp, String otro, String idTrat, String idPreg) {
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    String fecha = date.toString().replaceAll("00:00:00.000", "");
    return post(
      Uri.parse('https://'+dotenv.env['server']!+'/paciente/responderPreg'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'access-token': globals.token,
      },
      body: jsonEncode(<String, String>{
        'pacId' : globals.usuario,
        'idTrat': idTrat,
        'idPreg':idPreg,
        'fecha': fecha,
        'resp':resp,
        'otro': otro
      }),
    );
  }
}