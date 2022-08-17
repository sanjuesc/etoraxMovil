import 'package:etorax/src/resources/enviar_resp_mixin.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import '../../globals.dart' as globals;
class Tipo5 extends StatefulWidget{
  final String idPreg;
  final String idTrat;
  Tipo5({required this.idPreg, required this.idTrat});

  State<StatefulWidget> createState() {
    return Tipo5State();
  }

}
class Tipo5State extends State<Tipo5> with Enviar{

  String resp = "";
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 30.0, right: 30.0),
            child: TextField(
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 5,
              onChanged: (texto){
                resp=texto;
              },
            ),
          ),
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