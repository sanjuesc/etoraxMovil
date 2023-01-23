import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import '../blocs/login_bloc.dart';
import '../blocs/login_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget{
  State<StatefulWidget> createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen>{ //hay que cambiar a statefull widget para poder esperar al futuro

  @override
  void initState() {
    super.initState();

  }


  bool valueCheck = false;
  Widget build(context){
    final bloc = LoginProvider.of(context);
    return SafeArea(
        child: Container(
          margin: EdgeInsets.all(20.0),
          child: Column(
            children: [
              Image.asset('assets/images/logo.png'),
              emailField(bloc),
              passwordField(bloc),
              Container(margin: EdgeInsets.only(top: 20.0),),
              //recordarDatos(),
              Container(margin: EdgeInsets.only(top: 20.0),),
              checkBox(),
              submitButton(bloc),
              Expanded(child:Container()),//pongo esto aqui para rellenar el espacio hasta el Text
              //faq()
            ],
          ),
        )
    );
  }

  checkBox() {
    return StatefulBuilder(
      builder: (context, setState) {
        return CheckboxListTile(
          title: const Text('Recordar mis detalles'),
          value: valueCheck,
          onChanged: (bool? value) {
            setState(() {
              valueCheck = value!;
            });
          },
          secondary: const Icon(Icons.remember_me),
        );
      },
    );
  }



  Widget emailField(LoginBloc bloc){
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

  Widget passwordField(LoginBloc bloc){
    return FutureBuilder(
      builder: (context, AsyncSnapshot<String?> passSnap){
        if(!passSnap.hasData){
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
        }else{
          bloc.changePassword(passSnap.data!);
          bloc.quitarPass();
          return StreamBuilder(
            stream: bloc.password,
            builder: (context, snapshot){
              return TextField(
                controller: TextEditingController(text: passSnap.data!),
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
      },
      future: bloc.getPass(),
    );
  }

  Widget submitButton(LoginBloc bloc){

    return StreamBuilder(
      stream: bloc.submitValid,
      builder: (context, snapshot){
        return ElevatedButton (
          child: Text('Login'),
          style: ElevatedButton.styleFrom(
            primary: Colors.blueAccent,
            padding: EdgeInsets.symmetric(horizontal: 20.0),),
          onPressed: () async {
            FocusManager.instance.primaryFocus?.unfocus(); //no me gusta el 'hack' de poner esto aqui pero si no el teclado no se oculta al clicar
            bool res = false;
            bool primeraConex = true;
            if(snapshot.hasData){ //intentamos hacer login
              res = await bloc.submit(valueCheck);
            }

            if(!res){ //si algo esta mal, sacamos error
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
              bloc.obtenerGenerales();
              primeraConex = await bloc.primeraConex();
              if(primeraConex){
                Navigator.pushReplacementNamed(context, "primeraConex");
              }else{
                Navigator.pushNamed(context, "menu");
                //si no, vamos al menu
              }

            }
          },
        );
      },
    );
  }

  Widget recordarDatos() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children:   [
        InkWell(
          child: Text('No recuerdo mis datos'),
          onTap: () {
            print("DATOS");
          }
        ),
      ],
    );
  }

  Widget faq() {
    return InkWell(
        child: Text('FAQ'),
        onTap: () {
          print("FAQ");
        }
    );
  }

}