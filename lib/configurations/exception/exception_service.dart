import 'dart:io';

abstract class ExceptionService {
  /// SOCKET EXCEPTION ~~
  void handleConnectionException(SocketException socketException);

  /// EXCEPTION ~~
  void handleException();
}