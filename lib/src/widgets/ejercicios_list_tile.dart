import 'package:flutter/material.dart';
import 'package:etorax/src/widgets/loading_container.dart';
import '../blocs/ejerc_provider.dart';
import '../models/ejercicio.dart';
import 'dart:async';
import 'loading_container.dart';
class NewsListTile extends StatelessWidget{
  final int itemId;

  NewsListTile({required this.itemId});


  Widget build(context) {
    final bloc = EjercProvider.of(context);

    return StreamBuilder(
      stream: bloc.items,
      builder: (context,AsyncSnapshot<Map<int, Future<Ejercicio?>>> snapshot){
        if(!snapshot.hasData){
          return LoadingContainer();
        }

        return FutureBuilder(
          future: snapshot.data![itemId],
          builder: (context, AsyncSnapshot<Ejercicio?> itemSnapshot){
            if (!itemSnapshot.hasData){
              return LoadingContainer();
            }else{
              return buildTile(context, itemSnapshot.data);
                //Text(itemSnapshot.data!.title);
            }
          },
        );
      }

    );
  }

  Widget buildTile(BuildContext buildContext, Ejercicio? item){
      return Card(
        elevation: 8.0,
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
            decoration: BoxDecoration(color: Colors.white60),
            child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            leading: Container(
              padding: EdgeInsets.only(right: 12.0),
              decoration: new BoxDecoration(
                  border: new Border(
                      right: new BorderSide(width: 1.0, color: Colors.grey))),
              child: Icon(Icons.directions_walk, color: Colors.grey),
            ),
            onTap: (){
            },
            title: Text(item!.nombre),
            subtitle: Row(
              children: <Widget>[
                Icon(Icons.linear_scale, color: Colors.grey),
                Text("Sin completar")
              ],
            ),
            trailing:    Icon(Icons.keyboard_arrow_right, color: Colors.grey, size: 30.0),
          )
        ),
      );

  }

}