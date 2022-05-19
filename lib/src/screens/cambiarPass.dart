import 'package:flutter/material.dart';



class CambiarPass extends StatefulWidget{
  State<StatefulWidget> createState() {
    return CambiarPassState();
  }
}

class CambiarPassState extends State<CambiarPass>{ //hay que cambiar a statefull widget para poder esperar al futuro

  final controllerVieja = TextEditingController();
  final controllerNueva = TextEditingController();
  final controllerConfirmacion = TextEditingController();

  @override
  void initState() {
    super.initState();

  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("eTorax 2.0"),
      ),
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(bottom: 10.0), child: Text("Antigua contraseña", style: TextStyle(fontSize: 20)),),
            vieja(),
            Container(margin: EdgeInsets.only(top: 20.0),),
            Padding(padding: EdgeInsets.only(bottom: 10.0), child: Text("Nueva contraseña", style: TextStyle(fontSize: 20)),),
            nueva(),
            Container(margin: EdgeInsets.only(top: 20.0),),
            Padding(padding: EdgeInsets.only(bottom: 10.0), child: Text("Confirmar nueva contraseña", style: TextStyle(fontSize: 20)),),
            confirmar(),
            Container(margin: EdgeInsets.only(top: 20.0),),
            enviar(),
          ],
        ),
      )
    );
  }

  Widget vieja() {
    return Padding(
      padding: EdgeInsets.only(left: 40.0, right: 40.0),
      child: TextField(
        controller: controllerVieja,
        obscureText: true,
        onChanged: (value){
          //nada en este caso
        },
      ),
    );
  }

  Widget nueva() {
    return Padding(
      padding: EdgeInsets.only(left: 40.0, right: 40.0),
      child: TextField(
        controller: controllerNueva,
        obscureText: true,
        onChanged: (value){
          //nada en este caso
        },
      ),
    );
  }


  Widget confirmar() {
    return Padding(
      padding: EdgeInsets.only(left: 40.0, right: 40.0),
      child: TextField(
        controller: controllerConfirmacion,
        obscureText: true,
        onChanged: (value){
          //nada en este caso
        },
      ),
    );
  }

  Widget enviar(){
    return Padding(
      padding: EdgeInsets.only(right: 50.0, left: 50.0),
      child: ElevatedButton(
        onPressed: () {
          print("ey");
        },
        child: Text("Cambiar contraseña"),
      ),
    );
  }

}