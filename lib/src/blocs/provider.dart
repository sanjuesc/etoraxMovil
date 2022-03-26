import 'package:flutter/material.dart';
import 'bloc.dart';

class Provider extends InheritedWidget{
  final bloc = Bloc();

  Provider({required Widget child}) : super(child: child);


  bool updateShouldNotify(_) => true;

  static Bloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<Provider>() as Provider).bloc;
  }
}
