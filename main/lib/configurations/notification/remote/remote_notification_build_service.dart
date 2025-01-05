import 'package:firebase_messaging/firebase_messaging.dart';

/// Abstract service for building various types of notifications.
///
/// This service checks user preferences to determine if the notifications
/// should be in-app, phone, or both, and constructs notifications based on
/// the payload received from the server.
abstract class RemoteNotificationBuildService {
  /// Builds other notification types.
  ///
  /// Checks user [Preference] for in-app or phone or both.
  /// The data for the notification comes from the payload sent from the server.
  ///
  /// @param message The [RemoteMessage] payload data from the server.
  /// @param isBackground Indicates if the notification is being built in the background.
  void buildOthers({required RemoteMessage message, bool isBackground = false});

  /// Builds a generic notification.
  ///
  /// Constructs the notification data based on the payload received.
  ///
  /// @param message The payload message from the server.
  /// @param isBackground Indicates if the notification is being built in the background.
  void build({required RemoteMessage message, bool isBackground = false, bool shouldNavigate = false});
}