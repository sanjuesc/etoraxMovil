

import 'src/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'src/app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_config.dart';



Future main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseConfig.platformOptions,
  );

  String? token = await FirebaseMessaging.instance.getToken();
  print("Token = $token");
  globals.firebaseToken=token!;

  await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();

  runApp(App());

}



