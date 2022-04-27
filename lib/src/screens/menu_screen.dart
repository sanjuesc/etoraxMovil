import 'package:flutter/material.dart';


class MenuScreen extends StatefulWidget{
  State<StatefulWidget> createState() {
    return MenuScreenState();
  }
}

class MenuScreenState extends State<MenuScreen> {
  //hay que cambiar a statefull widget para poder esperar al futuro

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: Drawer(),
      appBar: AppBar(
        title: Text("eTorax 2.0"),
      ),
      body: const Center(
        child: Text(
          "Pagina estandar",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }

}