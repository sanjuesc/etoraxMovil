import 'package:etorax/src/resources/enviar_resp_mixin.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'dart:convert';
import '../../globals.dart' as globals;
import 'package:syncfusion_flutter_core/theme.dart';
class Tipo4 extends StatefulWidget{
  final String idPreg;
  final String idTrat;
  Tipo4({required this.idPreg, required this.idTrat});

  State<StatefulWidget> createState() {
    return Tipo4State();
  }

}
class Tipo4State extends State<Tipo4> with Enviar{

  final valorController = TextEditingController();
  double _value=0;


  String resp = "No";
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
            onPressed: () async {
              int result = await obtenerOtros(resp, "", this.widget.idTrat, this.widget.idPreg);
              if(result==200){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar( //usamos el scaffold de app.dart para mostrar el mensaje
                  content: Text("La respuesta se ha guardado correctamente"),
                ));
              }else{
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Ha ocurrido un error al enviar la respuesta"),
                ));
              }
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
          Text("Del 0 al 10 en la escala disnea caunto?"),
          Container(
            child: SfSliderTheme(
              data: SfSliderThemeData(
                activeLabelStyle: TextStyle(fontSize: 10.0, color: Colors.black),
                inactiveLabelStyle:TextStyle(fontSize: 10.0, color: Colors.black),
              ),
              child: getSlider(),

            ),
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 10.0),
          ),
          OutlinedButton(
            onPressed: () async {
              int result = await obtenerOtros(resp, _value.toString(), this.widget.idTrat, this.widget.idPreg);
              if(result==200){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar( //usamos el scaffold de app.dart para mostrar el mensaje
                  content: Text("La respuesta se ha guardado correctamente"),
                ));
              }else{
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Ha ocurrido un error al enviar la respuesta"),
                ));
              }
            },
            child: Text("Enviar respuesta"),
          ),
        ],
      );
    }



  }

  Widget getSlider(){
    return SfSlider(
      min: 0,
      max: 10,
      showLabels: true,
      showDividers: true,
      interval: 1,
      value: _value,
      tooltipTextFormatterCallback: (dynamic value, String? palabro){
        switch (int.parse(palabro!)) {
          case 0:
            return 'Reposo';
          case 1:
            return "Muy muy suave";
          case 2:
            return 'Muy suave';
          case 3:
            return 'Suave';
          case 4:
            return 'Algo duro';
          case 5:
            return 'Duro';
          case 6:
            return 'Mas duro';
          case 7:
            return 'Muy duro';
          case 8:
            return 'Muy muy duro';
          case 9:
            return 'Máximo';
          case 10:
            return 'Extremadament máximo';
        }
        return "";
      },
      showTicks: true,
      enableTooltip: true,
      onChanged: (dynamic newValue) {
        setState(
              () {
            _value = newValue.round().toDouble();;
          },
        );
      },
    );
  }


}