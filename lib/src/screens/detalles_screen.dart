import 'package:flutter/material.dart';
import '../models/ejercicio.dart';
class DetallesScreen extends StatelessWidget{

  final Ejercicio ejer;
  const DetallesScreen({Key? key, required this.ejer}) : super (key : key);


  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(ejer.nombre),
      ),
      body: Text(ejer.descri),
    );
  }

}
