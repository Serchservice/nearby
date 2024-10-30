import 'package:connectify_flutter/connectify_flutter.dart';
import 'package:flutter/foundation.dart';

class Logger {
  static String build({String? from, required dynamic text}) {
    if(from != null) {
      return "$from _______________________________ ${text.toString()}";
    } else {
      return text.toString();
    }
  }

  static void log(text, {String? from, bool needHeader = true}){
    if(kDebugMode){
      Debug.log(
        needHeader ? build(text: text, from: from) : text.toString(),
        mode: DebugMode.TRACE,
        prefix: "Serch"
      );
    }
  }
}

String build({String? from, required dynamic text}) {
  if(from != null) {
    return "$from _______________________________ ${text.toString()}";
  } else {
    return text.toString();
  }
}

void log(text, {String? from, bool needHeader = true}){
  if(kDebugMode){
    Debug.log(
      needHeader ? build(text: text, from: from) : text.toString(),
      mode: DebugMode.INFO,
      prefix: "Serch"
    );
  }
}