import 'dart:isolate';
import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/widgets.dart';
import 'package:drive/library.dart';

class RemoteNotificationImplementation implements RemoteNotificationService {
  static final MainConfiguration config = MainConfiguration.data;

  ReceivedAction? initialAction;
  static ReceivePort? receivePort;

  @override
  void init() async {
    initPort();

    AwesomeNotifications().initialize(
      "resource://raw/res_favicon_dark",
      LocalNotificationChannel.channels,
      channelGroups: LocalNotificationChannel.groups,
      debug: true
    );

    AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod
    );

    initialAction = await AwesomeNotifications().getInitialNotificationAction();
  }

  @override
  void initPort() {
    try {
      receivePort = ReceivePort('Notification action port in main isolate')
        ..listen((silentData) => onActionReceivedImplementationMethod(silentData));
      receivePort!.listen((serializedData) {
        final receivedAction = ReceivedAction().fromMap(serializedData);
        onActionReceivedImplementationMethod(receivedAction);
      });

      // This initialization only happens on main isolate
      IsolateNameServer.registerPortWithName(receivePort!.sendPort, 'notification_action_port');
    } catch (_) { }
  }

  @pragma("vm:entry-point")
  static Future <void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
    log(receivedNotification.toMap(), from: "Notification Created");
  }

  @pragma("vm:entry-point")
  static Future <void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
    log(receivedNotification.toMap(), from: "Notification Displayed");
  }

  @pragma("vm:entry-point")
  static Future <void> onDismissActionReceivedMethod(ReceivedAction action) async {
    if (PlatformEngine.instance.isIOS) {
      AwesomeNotifications().getGlobalBadgeCounter()
          .then((value) => AwesomeNotifications().setGlobalBadgeCounter(value - 1),
      );
    }
    log(action.toMap(), from: "Action Dismissed");

    switch(action.channelKey) {
    }
  }

  @pragma("vm:entry-point")
  static Future <void> onActionReceivedMethod(ReceivedAction action) async {
    log(action.toMap(), from: "Action Received");

    if (receivePort == null) {
      SendPort? sendPort = IsolateNameServer.lookupPortByName('notification_action_port');

      if (sendPort != null) {
        sendPort.send(action);
        return;
      }
    }

    return onActionReceivedImplementationMethod(action);
  }

  static Future<void> onActionReceivedImplementationMethod(ReceivedAction action) async {
    WidgetsFlutterBinding.ensureInitialized();

    // if(action.payload != null && action.payload!.containsKey(notifyKey) && action.payload![notifyKey] == scheduleSNT) {
    //   Schedule schedule = Schedule.fromStringedJson(action.payload!);
    //   Navigate.to(HomeLayout.route,arguments: schedule.toJson());
    // } else if(action.payload != null && action.payload!.containsKey(notifyKey) && action.payload![notifyKey] == tripSNT) {
    //   TripNotification trip = TripNotification.fromStringJson(action.payload!);
    //   Navigate.to(HomeLayout.route, arguments: trip.toJson());
    // }
  }
}