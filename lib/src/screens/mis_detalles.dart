import 'package:flutter/material.dart';
import '../widgets/drawer.dart';


class MisDetalles extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MiDrawer(),
      appBar: AppBar(title: Text("eTorax 2.0"),),
      body: Text('Mis datos'),
    );
  }


}