import 'dart:ui';

import 'package:auto_start_flutter/auto_start_flutter.dart';
import 'package:etorax/src/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AutoStartScreen extends StatelessWidget {


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("eTorax 2.0"),),
      body: texto(context),
    );
  }



  Future<void> initAutoStart() async {
    try {
      //check auto-start availability.
      var test = await isAutoStartAvailable;
      print(test);
      //if available then navigate to auto-start setting page.
      if (test!) await getAutoStartPermission();
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Widget texto(BuildContext context){
    return Card(
      elevation: 8.0,
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
          height: 230,
          decoration: BoxDecoration(color: Colors.white60),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            leading: Container(
              padding: EdgeInsets.only(right: 12.0),
              decoration: BoxDecoration(
                  border: Border(
                      right: BorderSide(width: 2.0, color: Colors.grey))),
              child: Icon(Icons.notifications_active_outlined, color: Colors.grey),
            ),
            title: Text("Para poder recibir notificaciones cuando la aplicación no está abierta, es necesario activar permisos adicionales"),
            subtitle: Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: ListView.builder(
                    itemCount: 2,
                    itemBuilder: (context, index){
                      if(index==0){
                        return Row(
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                initAutoStart();
                              },
                              child: Text("Activar"),
                            ),
                            SizedBox(width: 70,), // give it width
                            OutlinedButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(context, "menu");
                              },
                              child: Text("Continuar"),
                            ),
                          ],
                        );
                      }else{
                        return Padding(child: Text("Puedes continuar sin activarlo, pero entonces no podrás recibir notificaciones a menos que la aplicación se encuentre abierta en segundo plano"),padding: EdgeInsets.only(top: 5.0),);
                      }
                    }
                )
            ),
          )
      ),
    );
  }

}