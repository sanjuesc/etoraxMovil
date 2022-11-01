
import 'package:http/http.dart';
import 'dart:convert';
import '../globals.dart' as globals;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import '../screens/menu_screen.dart';
import '../screens/mis_detalles.dart';
import '../screens/login_screen.dart';
class MiDrawer extends StatelessWidget{
  Widget build(BuildContext context) {
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
            title: const Text("Ejercicios"),
            onTap: (){
              Navigator.pushReplacementNamed(context, "menu");
              },
          ),
          ListTile(
            title: const Text("Preguntas diarias"),
            onTap: () {
              Navigator.pushNamed(context, "preguntasDiarias");
              },
          ),
          ListTile(
            title: const Text("Mis datos"),
            onTap: () {
              Navigator.pushNamed(context, "misDatos");
            },
          ),
          ListTile(
            title: const Text("Preguntas frecuentes"),
            onTap: () {
              Navigator.pushNamed(context, "faq");
            },
          ),
          ListTile(
            title: const Text("Videos generales"),
            onTap: () {
              Navigator.pushNamed(context, "videosGenerales");
            },
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 100,
                color: Colors.blue,// Give height of banner
                child: ListTile(
                  title: const Text("Cerrar sesión"),
                  onTap: (){
                    Navigator.pushAndRemoveUntil(
                      context,
                        MaterialPageRoute(
                            builder: (context) {
                              return Scaffold(
                                resizeToAvoidBottomInset: false,
                                body: LoginScreen(),
                              );
                            }
                        ),
                          (route) => false,
                    );
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