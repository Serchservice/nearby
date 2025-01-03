import 'package:flutter/foundation.dart';
import 'package:logger_flutter/logger_flutter.dart';

class Logger {
  static void log(text, {String? from, bool needHeader = true}){
    LogManagerService logger = LogManager();

    if(kDebugMode){
      logger.log(text, from: from, mode: LogMode.TRACE, prefix: "Serch");
    }
  }
}

void log(text, {String? from, bool needHeader = true}){
  LogManagerService logger = LogManager();

  if(kDebugMode){
    logger.log(text, from: from, mode: LogMode.INFO, prefix: "Serch");
  }
}