import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseConfig {
  static FirebaseOptions? get platformOptions {
      log("Analytics Dart-only initializer doesn't work on Android, please make sure to add the config file.");
      return null;
  }
}