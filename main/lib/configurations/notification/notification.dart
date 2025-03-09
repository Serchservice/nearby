import 'dart:isolate';
import 'dart:ui';

import 'package:notify/notify.dart';
import 'package:drive/library.dart';

final notify = Notify.instance.inApp();

final remoteNotificationAction = Notify.instance.manager();

final remoteNotificationBuilder = Notify.instance.builder();

final remoteNotification = Notify.instance.remote();

class NotificationController {
  NotificationController._();
  static NotificationController instance = NotificationController._();

  bool _isRegistered = false;
  ReceivePort? receivePort;

  String notificationIsolateName = 'notification_action_port';

  void initialize() {
    if(!PlatformEngine.instance.isWeb) {
      try {
        receivePort = ReceivePort('Notification action port in main isolate')
          ..listen((data) {
            console.trace(data, from: "Notification Port Listening");
            NotificationHandler.instance.process(Notifier.fromJson(data));
          });

        IsolateNameServer.registerPortWithName(receivePort!.sendPort, notificationIsolateName);
        console.info("Isolate is initialized", from: "NotificationController initialization");
      } catch (e) {
        console.error(e, from: "NotificationController initialization");
      }
    }
  }

  void sendToPort(Notifier notifier) {
    SendPort? sendPort;

    if (receivePort == null) {
      sendPort = IsolateNameServer.lookupPortByName(notificationIsolateName);
    } else {
      sendPort = receivePort!.sendPort;
    }

    if (sendPort != null) {
      sendPort.send(notifier.toJson());
      return;
    }
  }

  void onLaunchedByNotification(Notifier activity) {
    console.log("Launched notification: ${activity.id} | ${activity.type.value}");
    NotificationHandler.instance.process(activity);
  }

  void register() {
    if(!_isRegistered) {
      _onReceivedActivity();
      _onCreatedActivity();
      _onTappedActivity();

      _isRegistered = true;

      console.log("Notification Controller is now registered for activities");
    }

    notifyController.flushPendingTappedNotifications();
  }

  void _onTappedActivity() {
    notifyController.tappedController.stream.listen((activity) {
      console.log("Tapped notification: ${activity.id} | ${activity.type.value} with data = ${activity.toJson()}");
      // sendToPort(activity);
    });
  }

  void _onReceivedActivity() {
    notifyController.receivedController.stream.listen((activity) {
      console.log("Received notification: ${activity.id} | ${activity.type.value} with data = ${activity.toJson()}");
    });
  }

  void _onCreatedActivity() {
    notifyController.createdController.stream.listen((activity) {
      console.log("Created notification: ${activity.id} | ${activity.type.value} with data = ${activity.toJson()}");
    });
  }
}