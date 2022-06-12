import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'dart:convert';
import '../../globals.dart' as globals;
import 'package:syncfusion_flutter_core/theme.dart';


class Tipo3 extends StatefulWidget{
  final String idPreg;
  final String idTrat;
  Tipo3({required this.idPreg, required this.idTrat});

  State<StatefulWidget> createState() {
    return Tipo3State();
  }

}
class Tipo3State extends State<Tipo3>{
  double _value=0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: SfSliderTheme(
            data: SfSliderThemeData(
              activeLabelStyle: TextStyle(fontSize: 10.0, color: Colors.black),
              inactiveLabelStyle:TextStyle(fontSize: 10.0, color: Colors.black),
            ),
            child: getSlider(),

          ),
          padding: EdgeInsets.fromLTRB(0.0, 40.0, 10.0, 10.0),
        ),
        OutlinedButton(
          onPressed: () {
            print("ey");
          },
          child: Text("Enviar respuesta"),
        ),
      ]
    );
  }


  Widget getSlider(){
    return SfSlider(
      min: 0,
      max: 10,
      showLabels: true,
      showDividers: true,
      interval: 2,
      minorTicksPerInterval: 1,
      value: _value,
      showTicks: true,
      enableTooltip: true,
      shouldAlwaysShowTooltip: true, //a lo mejor quitar esto
      labelPlacement: LabelPlacement.onTicks,
      labelFormatterCallback:
          (dynamic actualValue, String formattedText) {
        switch (actualValue) {
          case 0:
            return 'Nada';
          case 2:
            return 'Poco';
          case 4:
            return 'Regular';
          case 6:
            return 'Bastante';
          case 8:
            return 'Mucho';
          case 10:
            return 'Inaguantable';
        }
        return "";
      },
      onChanged: (dynamic newValue) {
        setState(
              () {
            _value = newValue.round().toDouble();;
            print(newValue.round());
          },
        );
      },
    );
  }
}