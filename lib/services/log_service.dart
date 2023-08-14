import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

class Logger {
  static void log(Object? object) {
    if(!kDebugMode) return;
    if(object is String ) {
       print(object);
       return;
    };
    developer.inspect(object);
  } 
}