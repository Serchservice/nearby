/// Handles rerouting within the app when an error occurs
class SerchException implements Exception {
  String message;
  int? code;
  bool isLocked;
  bool isSessionExpired;
  bool isPlatformNotSupported;

  SerchException(this.message, {
    this.code,
    this.isLocked = false,
    this.isSessionExpired = false,
    this.isPlatformNotSupported = false
  });

  @override
  String toString() {
    if(code != null) {
      return "Main Exception: $message. Code: $code";
    }
    return "Main Exception: $message";
  }
}