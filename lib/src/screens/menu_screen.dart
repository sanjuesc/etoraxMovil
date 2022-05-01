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