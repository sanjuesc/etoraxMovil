import 'package:flutter/material.dart';
import '../blocs/ejerc_provider.dart';
import '../blocs/ejerc_bloc.dart';
import '../widgets/ejercicios_list_tile.dart';
import '../widgets/refresh.dart';
import 'package:http/http.dart';
import 'dart:convert';
import '../globals.dart' as globals;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../widgets/drawer.dart';
class MenuScreen extends StatelessWidget{

  Widget build(BuildContext context) {
    final ejercbloc = EjercProvider.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: MiDrawer(),
      appBar: AppBar(
        title: Text("eTorax 2.0"),
      ),
      body: buildList(ejercbloc),
    );
  }

  Widget buildList(EjercBloc ejercBloc){
    return StreamBuilder(
      stream: ejercBloc.idsTE,
      builder: (context, AsyncSnapshot<List<int>> snapshot){
        print(snapshot);
        if(!snapshot.hasData){
          return Center(
            child: SinEjercicios(context),
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

  Widget SinEjercicios(BuildContext miContext) {
    return FutureBuilder(
      builder: (context, AsyncSnapshot<String> esperado){
        if(!esperado.hasData){
          return CircularProgressIndicator();
        }else{
          return Align(
            child: Card(
              elevation: 8.0,
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: Container(
                  decoration: BoxDecoration(color: Colors.white60),
                  child: ListTile(
                    onTap: (){
                      final bloc = EjercProvider.of(context);
                      bloc.clearCache();
                      bloc.fetchEjercicios();
                    },
                    leading: Container(              padding: EdgeInsets.only(right: 12.0),
                      decoration: BoxDecoration(
                          border: Border(
                              right: BorderSide(width: 1.0, color: Colors.grey))),
                      child: Icon(Icons.directions_walk, color: Colors.grey),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    title: Text("No tienes ejercicios para el día de hoy"),
                    subtitle: Text("Crees que puede ser un error? Recargar la aplicación"),
                    trailing:    Icon(Icons.update, color: Colors.grey, size: 30.0),
                  )
              ),
            ),
            alignment: Alignment.topCenter,
          );
        }
      },
      future: esperar(),

    );
  }

  Future<String> esperar() async{
    await Future.delayed(Duration(seconds: 10));
    return Future<String>.value('Back to the future!');;
  }


}