import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'validators.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'dart:async';
import '../globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class Bloc extends Object with Validators{


  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();

  Stream<String> get email => _email.stream.transform(validateEmail);
  Stream<String> get password => _password.stream.transform(validatePassword);
  Stream<bool> get submitValid => CombineLatestStream.combine2(
      email,
      password,
          (e, p) => true
  );

  Function(String) get changeEmail => _email.sink.add;
  Function(String) get changePassword => _password.sink.add;


  Future<bool> submit(bool guardarUsuPass) async{
    final validEmail = _email.value;
    final validPassword = _password.value;
    final response = await intentarLogin(validEmail, validPassword);
    final ids = json.decode(response.body);
    if(guardarUsuPass){
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('nombre', validEmail);
      await prefs.setString('pass', validPassword);
    }else{
      quitarNombre();
      quitarPass();
    }
    return validarRespuesta(ids, response.statusCode);
  }

  Future<String?> getNombre() async{
    final prefs = await SharedPreferences.getInstance();
    String? algo = await prefs.getString("nombre");
    return algo;
  }

  Future<String?> getPass() async{
    final prefs = await SharedPreferences.getInstance();
    String? algo = await prefs.getString("pass");
    return algo;
  }

  void quitarNombre() async{
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("nombre");
  }

  void quitarPass() async{
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("pass");

  }

  dispose(){
    _email.close();
    _password.close();
  }


  Future<Response> intentarLogin(String nombre, String pass) {
    return post(
      Uri.parse('http://'+dotenv.env['local']!+'/login/pacienteLogin'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'usuario': nombre,
        'contraseña' : pass
      }),
    );
  }





}