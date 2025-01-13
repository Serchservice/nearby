import 'package:notify_flutter/notify_flutter.dart';

final notify = Notify.inApp().service;

final remoteNotificationAction = Notify.action().service;

final remoteNotificationBuilder = Notify.remote().service;

final remoteNotification = Notify.access().service;

final notificationController = notifyController;