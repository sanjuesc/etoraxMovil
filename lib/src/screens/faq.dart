import 'dart:ui';

import 'package:flutter/material.dart';
import '../widgets/drawer.dart';
class Faq extends StatelessWidget{
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MiDrawer(),
      appBar: AppBar(title: Text("eTorax 2.0"),),
      body:ListView(
        padding: EdgeInsets.all(8.0),
        children: <Widget>[
          ListTile(title: Text("¿Puedo salir a la calle?", style: TextStyle(fontSize: 20)),subtitle: Text("Sí, y de hecho debe hacerlo. Debe salir a caminar 2 o incluso 3 veces al día. Comience con distancias cortas y vaya aumentando el recorrido progresivamente.", style: TextStyle(fontSize: 16))),
          ListTile(title: Text("¿Puedo hacer esfuerzos?", style: TextStyle(fontSize: 20)),subtitle: Text("No debe levantar pesos durante al menos 4-8 semanas. Cuando comience a realizar esfuerzos hágalo de forma progresiva. Puede realizar tareas de baja intensidad.", style: TextStyle(fontSize: 16))),
          ListTile(title: Text("¿Cuándo puedo conducir?", style: TextStyle(fontSize: 20)),subtitle: Text("Debe esperar hasta que el olor esté completamente controlado y que sus brazos estén completamente funcionales, ya que un acceso de dolor puede hacer perder el control del vehículo. Ésto suele llevar entre 2 y 4 semanas.", style: TextStyle(fontSize: 16))),
          ListTile(title: Text("¿Puedo nadar?", style: TextStyle(fontSize: 20)),subtitle: Text("Debe evitar acudir a piscinas, jacuzzis, saunas, baños en el mar hasta que las heridas estén completamente cicatrizadas, por el riesgo de infección que puede aparecer.", style: TextStyle(fontSize: 16))),
          ListTile(title: Text("¿Si tengo dolor?", style: TextStyle(fontSize: 20)),subtitle: Text("Póngase en contacto con su médico de referencia para que aumente su tratamiento para el dolor.", style: TextStyle(fontSize: 16))),
          ListTile(title: Text("¿Si me cuesta respirar de forma repentina o tengo fiebre?", style: TextStyle(fontSize: 20)),subtitle: Text("Debe acudir a su servicio de Urgencias de referencia.", style: TextStyle(fontSize: 16))),
        ],
      )
    );
  }
}
