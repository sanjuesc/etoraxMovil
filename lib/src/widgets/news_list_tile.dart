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
      return Column(
        children: [
          ListTile(
            onTap: (){
            },
            title: Text(item!.nombre),
            subtitle: Text(item.descri),
          ),
          Divider(
            height: 2.0,
          ),
        ],
      );
  }

}