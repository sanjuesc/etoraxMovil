import 'package:etorax/src/screens/menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/login_screen.dart';
import 'blocs/login_provider.dart';
import 'blocs/ejerc_provider.dart';
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

  Route routes(RouteSettings settings){
    if (settings.name=='/'){
      return MaterialPageRoute(
          builder: (context){
            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: LoginScreen(),
            );
          }
      );
    }else{

      MaterialPageRoute ruta = MaterialPageRoute(
          builder: (context){
            final storiesBloc = EjercProvider.of(context);
            storiesBloc.fetchEjercicios();
            return MenuScreen();
          }
      );
      return ruta;
    }


  }


}
