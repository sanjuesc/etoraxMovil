

import 'models/ejercicio.dart';
import 'screens/menu_screen.dart';
import 'screens/cambiarPass.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/login_screen.dart';
import 'screens/detalles_screen.dart';
import 'blocs/login_provider.dart';
import 'blocs/ejerc_provider.dart';
import 'screens/mis_detalles.dart';
import 'screens/faq.dart';
import 'screens/preguntasDiarias.dart';
import 'screens/primera_conex.dart';
class App extends StatelessWidget{
  build(context){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);



    return EjercProvider(
      child: LoginProvider(
        child: GestureDetector(
          child : MaterialApp(
            title: "eTorax",
            onGenerateRoute: routes,
          ),
          onTap: (){
            FocusManager.instance.primaryFocus?.unfocus();
          },
        ),
      )
    );
  }

  Route routes(RouteSettings settings) {
    if (settings.name == '/') {
      return MaterialPageRoute(
          builder: (context) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: LoginScreen(),
            );
          }
      );
    } else {
      if (settings.name == 'menu') {
        return MaterialPageRoute(
            builder: (context) {
              final storiesBloc = EjercProvider.of(context);
              storiesBloc.clearCache();
              storiesBloc.fetchEjercicios();
              return MenuScreen();
            }
        );
      } else {
        if (settings.name == 'misDatos') {
          return MaterialPageRoute(
              builder: (context) {
                return MisDetalles();
              }
          );
        } else {
          if (settings.name == 'faq') {
            print("faq");
            return MaterialPageRoute(
                builder: (context) {
                  return Faq();
                }
            );
          } if (settings.name == 'primeraConex') {
            print("primeraConex");
            return MaterialPageRoute(
                builder: (context) {
                  return PrimeraConex();
                }
            );
          } else {
            if (settings.name == "cambiarPass") {
              return MaterialPageRoute(
                  builder: (context) {
                    return CambiarPass();
                  }
              );
            } else {
              if (settings.name == "preguntasDiarias") {
                return MaterialPageRoute(
                    builder: (context) {
                      return PreguntasDiarias();
                    }
                );
              } else {
                final args = settings.arguments as Ejercicio;
                return MaterialPageRoute(
                    builder: (context) {
                      return DetallesScreen(key: null, ejer: args);
                    }
                );
              }
            }
          }
        }
      }
    }
  }
}
