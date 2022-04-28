import 'package:flutter/material.dart';
import '../blocs/ejerc_provider.dart';
import '../blocs/ejerc_bloc.dart';
import '../widgets/ejercicios_list_tile.dart';
import '../widgets/refresh.dart';
import 'package:http/http.dart';
import 'dart:convert';
import '../globals.dart' as globals;
import 'package:flutter_dotenv/flutter_dotenv.dart';
class MenuScreen extends StatelessWidget{

  Widget build(BuildContext context) {
    final ejercbloc = EjercProvider.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: miDrawer(),
      appBar: AppBar(
        title: Text("eTorax 2.0"),
      ),
      body: buildList(ejercbloc),
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

            },
          ),
          ListTile(
            title: const Text("Mis datos"),
            onTap: () async{
              Client client = Client();
              final respuesta = await client.post(
                Uri.parse('http://'+dotenv.env['local']!+'/paciente/getEjerciciosActuales'),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                  'access-token': globals.token,
                },
                body: jsonEncode(<String, String>{
                  'pacId': globals.usuario,
                }),
              );
              final ids = json.decode(respuesta.body);
              print(ids);
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
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildList(EjercBloc ejercBloc){
    return StreamBuilder(
      stream: ejercBloc.idsTE,
      builder: (context, AsyncSnapshot<List<int>> snapshot){
        print(snapshot);
        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(),
          );
        }else{
          return Refresh(child: ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (context, int index){
              ejercBloc.fetchItem(snapshot.data![index]);
              return NewsListTile(itemId: snapshot.data![index]);
            },
          ));
        }
      },

    );

  }


}