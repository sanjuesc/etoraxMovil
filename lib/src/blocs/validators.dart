import 'dart:async';
import '../globals.dart' as globals;
class Validators{
  final validateEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink){
      if (email.length>1){
        sink.add(email);
      }else{
        sink.addError('El usuario debe un mínimo de 4 caracteres');
      }
    },
  );

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink){
      if (password.length>1){
        sink.add(password);
      }else{
        sink.addError('La contraseña debe un mínimo de 4 caracteres');
      }
    },
  );

  bool validarRespuesta(dynamic respuesta, int statusCode){
    if (statusCode==200){
      globals.token=respuesta['token'];
    }
    return statusCode==200;

  }

}
