import 'package:flutter/material.dart';
import 'ejerc_bloc.dart';


class EjercProvider extends InheritedWidget {
  final EjercBloc bloc;

  EjercProvider({required Widget child})
      : bloc = EjercBloc(),
        super(child: child);

  bool updateShouldNotify(_) => true;

  static EjercBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<EjercProvider>()
    as EjercProvider)
        .bloc;
  }
}
