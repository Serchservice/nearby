/// Abstract service for managing local notifications for foreground operations.
abstract class RemoteNotificationService {

  /// Initializes the local notification system for foreground operations.
  void init();

  /// Initialize main isolate
  void initPort();
}