import 'package:flutter/material.dart';
import '../blocs/bloc.dart';
import '../blocs/provider.dart';

class LoginScreen extends StatelessWidget{
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
  return StreamBuilder(
    stream: bloc.email,
    builder: (context, snapshot){
      return TextField(
        onChanged: bloc.changeEmail,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'you@domain.com',
          labelText: 'Email addrress',
          errorText: snapshot.hasError ? snapshot.error.toString() : null,
        ),
      );
    },
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
          hintText: 'Password',
          labelText: 'Password',
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
        onPressed: () => snapshot.hasData ? bloc.submit() : null,
      );
    },
  );

}