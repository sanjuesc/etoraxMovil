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
      drawer: miDrawer(),
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

  Widget miDrawer() {
    return Drawer(
      child: Column(
        children: [
          const SizedBox(
            height: 120,
            child: DrawerHeader(
              decoration: BoxDecoration(
                  color: Colors.blue,
                  image: DecorationImage(
                      image: AssetImage("assets/images/logo.png"),
                      fit: BoxFit.fitWidth
                  )
              ), child: null,
            ),
          ),

          ListTile(
            title: const Text("Responder preguntas"),
            onTap: (){
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text("Mis datos"),
            onTap: (){
              Navigator.pop(context);
            },
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 100,
                color: Colors.blue,// Give height of banner
                child: ListTile(
                  title: const Text("Preguntas frecuentes"),
                  onTap: (){
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}