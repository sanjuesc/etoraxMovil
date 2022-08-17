import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import '../../globals.dart' as globals;
import '../../resources/enviar_resp_mixin.dart';
class Tipo1 extends StatefulWidget{
  final String idPreg;
  final String idTrat;
  Tipo1({required this.idPreg, required this.idTrat});

  State<StatefulWidget> createState() {
    return Tipo1State();
  }

}
class Tipo1State extends State<Tipo1> with Enviar{

  String resp = "No";
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
          }).toList(),),
        OutlinedButton(
          onPressed: () {
            enviar(resp, "", this.widget.idTrat, this.widget.idPreg);
          },
          child: Text("Enviar respuesta"),
        ),
      ]
    );
  }
}