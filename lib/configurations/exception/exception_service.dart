import 'package:universal_io/io.dart';

abstract class ExceptionService {
  /// SOCKET EXCEPTION ~~
  void handleConnectionException(SocketException socketException);

  /// EXCEPTION ~~
  void handleException();
}