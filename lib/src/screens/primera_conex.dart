import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import '../globals.dart' as globals;
class PrimeraConex extends StatefulWidget{

  State<StatefulWidget> createState() {
    return PrimeraConexState();
  }

}



class PrimeraConexState extends State<PrimeraConex>{ //hacer stateful widget https://api.flutter.dev/flutter/material/TextField-class.html
  String preg1 = "Si";
  String preg2 = "Si";
  String preg3 = "Si";
  String preg4 = "Si";
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Antes de comenzar..."),),
        body:ListView(
          padding: EdgeInsets.all(8.0),
          children: <Widget>[
            ListTile(title: Text("¿Toma inhaladores?", style: TextStyle(fontSize: 20)),
                trailing: DropdownButton(
                  value: preg1,
                  onChanged: (String? newValue) {
                    setState(() {
                      preg1 = newValue!;
                    });
                  },
                  items: <String>["Si", "No"]          .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),),),
            ListTile(title: Text("¿Tiene o ha tenido problemas de corazón?", style: TextStyle(fontSize: 20)),
              trailing: DropdownButton(
                value: preg2,
                onChanged: (String? newValue) {
                  setState(() {
                    preg2 = newValue!;
                  });
                },
                items: <String>["Si", "No"]          .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),),),
            ListTile(title: Text("¿Tiene o ha tenido problemas de circulación en las piernas?", style: TextStyle(fontSize: 20)),
              trailing: DropdownButton(
                value: preg3,
                onChanged: (String? newValue) {
                  setState(() {
                    preg3 = newValue!;
                  });
                },
                items: <String>["Si", "No"]          .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),),),
            ListTile(title: Text("¿Tiene dificultad para caminar?", style: TextStyle(fontSize: 20)),
              trailing: DropdownButton(
                value: preg4,
                onChanged: (String? newValue) {
                  setState(() {
                    preg4 = newValue!;
                  });
                },
                items: <String>["Si", "No"]          .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),),),
            ElevatedButton(
              onPressed: () {
                completarPreguntas();
                Navigator.pushReplacementNamed(context, "menu");
                },
              child: Text("Enviar"),)
          ],
        )
    );
  }


  completarPreguntas(){
    Client client = Client();
    client.post(
      Uri.parse('http://'+dotenv.env['server']!+'/paciente/completarPrimeraConex'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'access-token': globals.token,
      },
      body: jsonEncode(<String, String>{
        'pacId': globals.usuario,
        'preg1': castellanoToBool(preg1),
        'preg2': castellanoToBool(preg2),
        'preg3': castellanoToBool(preg3),
        'preg4': castellanoToBool(preg4),
      }),
    );
  }

  String castellanoToBool(String valor){
    if(valor=="Si"){
      return "1";
    }else{
      return "0";
    }
  }

}
