import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import '../../globals.dart' as globals;
class Tipo1 extends StatefulWidget{
  final String idPreg;
  final String idTrat;
  Tipo1({required this.idPreg, required this.idTrat});

  State<StatefulWidget> createState() {
    return Tipo1State();
  }

}
class Tipo1State extends State<Tipo1>{

  String resp = "No";
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OutlinedButton(
          onPressed: () {
            print("ey");
          },
          child: Text("Enviar respuesta"),
        ),
        DropdownButton(
          value: resp,
          onChanged: (String? newValue) {
            setState(() {
              resp = newValue!;
            });
          },
          items: <String>["Si", "No"]          .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),)
      ]
    );
  }
}