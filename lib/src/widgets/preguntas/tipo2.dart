import 'package:etorax/src/resources/enviar_resp_mixin.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:numberpicker/numberpicker.dart';
import 'dart:convert';
import '../../globals.dart' as globals;
class Tipo2 extends StatefulWidget{

  final String idPreg;
  final String idTrat;
  Tipo2({required this.idPreg, required this.idTrat});

  State<StatefulWidget> createState() {
    return Tipo2State();
  }

}
class Tipo2State extends State<Tipo2> with Enviar{

  final valorController = TextEditingController();


  String resp = "No";
  String cant="1";
  @override
  Widget build(BuildContext context) {
    if(resp=="No"){
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
              enviar(resp,"", this.widget.idTrat, this.widget.idPreg);
            },
            child: Text("Enviar respuesta"),
          ),
        ],
      );
    }else{
      return Column(
        children: [DropdownButton(
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Cuantos?"),
            SizedBox(
                width: 80,
                child: Padding(
                  child: TextField(
                    controller: valorController,
                    keyboardType: TextInputType.number,
                    onSubmitted: (valor){
                      setState(() {
                        if(valor!=""){
                          print("aqui");
                          cant=valor;
                        }else{
                          print("ALLA");
                          cant="0";
                        }
                        valorController.text=cant;
                      });
                      print(cant);
                    },
                    onChanged: (String valor){
                      print(valor);
                    },
                  ),
                  padding: EdgeInsets.only(left: 30.0),
                )
            ),
          ],
        ),
          OutlinedButton(
            onPressed: () {
              enviar(resp,cant, this.widget.idTrat, this.widget.idPreg);
            },
            child: Text("Enviar respuesta"),
          ),
        ],
      );
    }



  }
  //hace
}