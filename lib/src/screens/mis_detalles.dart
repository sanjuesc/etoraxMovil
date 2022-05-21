import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
            body: Text('Cargando información'),
          );
        }else{
          Map<String, dynamic> datos = datosSnap.data!['mensaje'][0];
          var fechaNac = DateTime.parse(datos['fechaNac']);
          var formatter = DateFormat('dd-MM-yyyy');
          String formatedNac = formatter.format(fechaNac);
          var fechFinPre = DateTime.parse(datos['fechFinPre']);
          String formatedfechFinPre = formatter.format(fechFinPre);
          var fechFinPost = DateTime.parse(datos['fechFinPost']);
          String formatedfechFinPost = formatter.format(fechFinPost);
          var milista = <Widget>[
            ListTile(title: Padding(padding: EdgeInsets.only(bottom: 10.0), child: Text("Nombre", style: TextStyle(fontSize: 20)),),subtitle: Text(datos['nombre'], style: TextStyle(fontSize: 16))),
            ListTile(title: Padding(padding: EdgeInsets.only(bottom: 10.0), child:Text("Apellido", style: TextStyle(fontSize: 20)),),subtitle: Text(datos['apellido'], style: TextStyle(fontSize: 16))),
            ListTile(title: Padding(padding: EdgeInsets.only(bottom: 10.0), child:Text("Fecha de nacimiento", style: TextStyle(fontSize: 20)),),subtitle: Text(formatedNac, style: TextStyle(fontSize: 16))),
            ListTile(title: Padding(padding: EdgeInsets.only(bottom: 10.0), child:Text("Numero de historial medico", style: TextStyle(fontSize: 20)),),subtitle: Text(datos['numHist'].toString(), style: TextStyle(fontSize: 16))),
            ListTile(title: Padding(padding: EdgeInsets.only(bottom: 10.0), child:Text("Nombre de usuario", style: TextStyle(fontSize: 20)),),subtitle: Text(globals.usuario, style: TextStyle(fontSize: 16))),
            ListTile(title: Padding(padding: EdgeInsets.only(bottom: 10.0), child:Text("Fecha fin preoperatorio", style: TextStyle(fontSize: 20)),),subtitle: Text(formatedfechFinPre, style: TextStyle(fontSize: 16))),
            ListTile(title: Padding(padding: EdgeInsets.only(bottom: 10.0), child:Text("Fecha fin postoperatorio", style: TextStyle(fontSize: 20)),),subtitle: Text(formatedfechFinPost, style: TextStyle(fontSize: 16))),
          ];

          return Scaffold(
            drawer: MiDrawer(),
            appBar: AppBar(title: Text("eTorax 2.0"),),
            body: ListView.builder(
              itemCount: milista.length+1,
              itemBuilder: (context, index) {
                  if (index == milista.length){
                    return Padding(
                      padding: EdgeInsets.only(right: 50.0, left: 50.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "cambiarPass");
                        },
                        child: Text("Cambiar contraseña"),
                      ),
                    );
                  }
                  else{
                    return Padding(
                      child: milista[index],
                      padding: EdgeInsets.only(bottom: 10.0, left: 10.0),
                    );
                  }
              },
            )
          );
        }
      },
      future: completar(context),
    );
  }



  Future<Map<String, dynamic>> completar(BuildContext context) async {
    Client client = Client();
    final respuesta = await client.post(
      Uri.parse('https://'+dotenv.env['server']!+'/paciente/detalles'),
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