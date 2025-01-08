import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:drive/library.dart';
import 'package:notify_flutter/notify_flutter.dart';

class FirebaseMessagingImplementation implements FirebaseMessagingService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final ConnectService _connect = Connect();

  @override
  void background(RemoteMessage message) async {
    remoteNotificationBuilder.build(RemoteNotificationConfig.fromData(
      data: message.data,
      title: message.notification?.title ?? "",
      body: message.notification?.body ?? "",
      platform: AppPlatform.nearby,
      isBackground: true
    ));
  }

  @override
  void foreground() async {
    _messaging.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);

    /// BACKGROUND TERMINATED GETTER
    _messaging.getInitialMessage().then((message) {
      if(message != null) {
        remoteNotificationBuilder.build(RemoteNotificationConfig.fromData(
          data: message.data,
          title: message.notification?.title ?? "",
          body: message.notification?.body ?? "",
          platform: AppPlatform.nearby,
        ));
      }
    }, onError: (error) {
      log(error, from: "FIREBASE MESSAGING LISTENER - B");
    });

    /// FOREGROUND LISTENER
    FirebaseMessaging.onMessage.listen((message) {
      remoteNotificationBuilder.build(RemoteNotificationConfig.fromData(
        data: message.data,
        title: message.notification?.title ?? "",
        body: message.notification?.body ?? "",
        platform: AppPlatform.nearby,
      ));
    }, onError: (error) {
      log(error, from: "FIREBASE MESSAGING LISTENER - F");
    });

    /// BACKGROUND NOT TERMINATED LISTENER
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      remoteNotificationBuilder.build(RemoteNotificationConfig.fromData(
        data: message.data,
        title: message.notification?.title ?? "",
        body: message.notification?.body ?? "",
        platform: AppPlatform.nearby,
      ));
    }, onError: (error) {
      log(error, from: "FIREBASE MESSAGING LISTENER - F");
    });

    /// TOKEN LISTENER
    _messaging.onTokenRefresh.listen((token) async {
      await _connect.patch(endpoint: "/account/fcm/update?token=$token", body: {});
    }, onError: (error) {
      log(error, from: "FIREBASE MESSAGING LISTENER - F");
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