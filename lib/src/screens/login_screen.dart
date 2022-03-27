import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../blocs/bloc.dart';
import '../blocs/provider.dart';
import '../globals.dart' as globals;

class LoginScreen extends StatefulWidget{
  State<StatefulWidget> createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen>{ //hay que cambiar a statefull widget para poder esperar al futuro

  Widget build(context){
    final bloc = Provider.of(context);
    return SafeArea(child: Container(
      margin: EdgeInsets.all(20.0),
      child: Column(
        children: [
          emailField(bloc),
          passwordField(bloc),
          Container(margin: EdgeInsets.only(top: 20.0),),
          submitButton(bloc),
        ],
      ),
    ));
  }
}


Widget emailField(Bloc bloc){
  return FutureBuilder(builder: (context, AsyncSnapshot<String?> nombreSnap){
    if(!nombreSnap.hasData){
      return StreamBuilder(
        stream: bloc.email,
        builder: (context, snapshot){
          return TextField(
            onChanged: bloc.changeEmail,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              hintText: '123456',
              labelText: 'Nombre de usuario',
              errorText: snapshot.hasError ? snapshot.error.toString() : null,
            ),
          );
        },
      );
    }else{
      bloc.changeEmail(nombreSnap.data!);
      bloc.quitarNombre();
      return StreamBuilder(
        stream: bloc.email,
        builder: (context, snapshot){
          return TextField(
            controller: TextEditingController(text: nombreSnap.data!),
            onChanged: bloc.changeEmail,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              hintText: '123456',
              labelText: 'Nombre de usuario',
              errorText: snapshot.hasError ? snapshot.error.toString() : null,
            ),
          );
        },
      );
    }
  },
    future: bloc.getNombre(),
  );
  

}

Widget passwordField(Bloc bloc){
  return StreamBuilder(
    stream: bloc.password,
    builder: (context, snapshot){
      return TextField(
        onChanged: bloc.changePassword,
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'Contraseña',
          labelText: 'Contraseña',
          errorText: snapshot.hasError ? snapshot.error.toString() : null,
        ),
      );
    },
  );
}

Widget submitButton(Bloc bloc){

  return StreamBuilder(
    stream: bloc.submitValid,
    builder: (context, snapshot){
      return ElevatedButton (
        child: Text('Login'),
        style: ElevatedButton.styleFrom(
          primary: Colors.amber,
          padding: EdgeInsets.symmetric(horizontal: 20.0),),
        onPressed: () async {
          FocusManager.instance.primaryFocus?.unfocus(); //no me gusta el 'hack' de poner esto aqui pero si no el teclado no se oculta al clicar
          bool res = false;
            if(snapshot.hasData){
              res = await bloc.submit();
              print(globals.token);
            }
            if(!res){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar( //usamos el scaffold de app.dart para mostrar el mensaje
                content: Text("Usuario y/o contraseña incorrectos"),
                action: SnackBarAction(
                  label: 'Ok',
                  onPressed: (){
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                ),
              ));
            }else{
              Navigator.pushNamed(context, "menu");
            }
        },
      );
    },
  );

}