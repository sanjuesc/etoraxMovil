import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'blocs/provider.dart';
import 'globals.dart' as globals;
class App extends StatelessWidget{
  build(context){
    return Provider(
      child: GestureDetector(
        child : MaterialApp(
          title: "eTorax",
          onGenerateRoute: routes,
        ),
        onTap: (){
          FocusManager.instance.primaryFocus?.unfocus();
        },
      ),
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
            return Scaffold(
                resizeToAvoidBottomInset: false,
                body: AppBar(
                  title: Text("ey"),
                )
            );
          }
      );
      return ruta;
    }


  }


}
