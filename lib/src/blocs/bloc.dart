import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'validators.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'dart:async';

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


  submit() async{
    final validEmail = _email.value;
    final validPassword = _password.value;
    final response = await createAlbum(validEmail, validPassword);
    final ids = json.decode(response.body);
    print("${ids['mensaje']}");
    print('email is $validEmail and password is $validPassword');
  }

  dispose(){
    _email.close();
    _password.close();
  }


  Future<Response> createAlbum(String nombre, String pass) {
    return post(
      Uri.parse('http://'+dotenv.env['local']!+'/login/medicoLogin'),
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