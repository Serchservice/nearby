import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:drive/library.dart';
import 'package:notify/notify.dart';

class FirebaseMessagingImplementation implements FirebaseMessagingService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final ConnectService _connect = Connect();

  RemoteNotificationConfig _getConfig(RemoteMessage message, bool isBackground) {
    return RemoteNotificationConfig.fromData(
      data: message.data,
      title: message.notification?.title ?? "",
      body: message.notification?.body ?? "",
      platform: PlatformEngine.instance.notifyPlatform,
      app: PlatformEngine.instance.notifyApp,
      isBackground: isBackground,
      showLogs: PlatformEngine.instance.debug,
      sound: "nearby"
    );
  }

  @override
  void background(RemoteMessage message) async {
    NotificationController.instance.register();
    _handle(message, true);
  }

  void _handle(RemoteMessage message, bool isBackground) {
    remoteNotificationBuilder.build(_getConfig(message, isBackground));

    try {
      MainConfiguration.data.isBackground.value = isBackground;
    } catch (_) {}
  }

  @override
  void foreground() async {
    _messaging.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);

    /// BACKGROUND TERMINATED GETTER
    _messaging.getInitialMessage().then((message) {
      if(message != null) {
        _handle(message, false);
      }
    }, onError: (error) {
      console.error(error, from: "FIREBASE MESSAGING LISTENER - B");
    });

    /// FOREGROUND LISTENER
    FirebaseMessaging.onMessage.listen((message) {
      _handle(message, false);
    }, onError: (error) {
      console.error(error, from: "FIREBASE MESSAGING LISTENER - F");
    });

    /// BACKGROUND NOT TERMINATED LISTENER
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handle(message, false);
    }, onError: (error) {
      console.error(error, from: "FIREBASE MESSAGING LISTENER - F");
    });

    /// TOKEN LISTENER
    _messaging.onTokenRefresh.listen((token) async {
      await _connect.patch(endpoint: "/account/fcm/update?token=$token", body: {});
    }, onError: (error) {
      console.error(error, from: "FIREBASE MESSAGING LISTENER - F");
    });
  }

  @override
  Future<String> getFcmToken() async {
    try {
      final result = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      do {
        final deviceToken = await _messaging.getToken();
        while (deviceToken != null && deviceToken.isNotEmpty) {
          return deviceToken;
        }
      } while (result.authorizationStatus == AuthorizationStatus.authorized);
      return "";
    } catch (e) {
      return "";
    }
  }
}