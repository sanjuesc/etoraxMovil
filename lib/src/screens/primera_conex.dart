import 'dart:ui';

import 'package:flutter/material.dart';
import '../widgets/drawer.dart';

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
              onPressed: () { print(preg4); },
              child: Text("Enviar"),)
          ],
        )
    );
  }
}
