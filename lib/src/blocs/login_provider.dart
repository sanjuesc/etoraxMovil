import 'package:flutter/material.dart';
import 'login_bloc.dart';

class LoginProvider extends InheritedWidget{
  final bloc = LoginBloc();

  LoginProvider({required Widget child}) : super(child: child);


  bool updateShouldNotify(_) => true;

  static LoginBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<LoginProvider>() as LoginProvider).bloc;
  }
}
