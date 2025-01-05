import 'package:firebase_messaging/firebase_messaging.dart';

/// Abstract service for managing remote notifications using Firebase Cloud Messaging (FCM).
abstract class FirebaseMessagingService {

  /// Retrieves the FCM (Firebase Cloud Messaging) token for the device.
  ///
  /// @return A [Future] that completes with the device's FCM token as a [String].
  Future<String> getFcmToken();

  /// Handles notifications when the app is in the foreground.
  ///
  /// This method should be used to display notifications or perform actions
  /// when a message is received while the app is in the foreground.
  void foreground();

  /// Handles notifications when the app is in the background.
  ///
  /// @param message The [RemoteMessage] received from FCM.
  ///
  /// This method should be used to display notifications or perform actions
  /// when a message is received while the app is in the background.
  void background(RemoteMessage message);
}