import 'package:drive/library.dart';
import 'package:get/get.dart';
import 'package:notify/notify.dart';

class NotificationHandler {
  NotificationHandler._();
  static NotificationHandler instance = NotificationHandler._();

  Notifier? _notifier;

  void process(Notifier notifier) => _process(notifier);

  void _process(Notifier notifier) {
    _notifier = notifier;

    console.debug(notifier.action, from: "[NotificationHandler] Processor Action");
    console.log(notifier.type, from: "[NotificationHandler] Processor Type");

    _processOtherNotification(notifier);
  }

  void _processOtherNotification(Notifier notifier) {
    _navigate();
  }

  bool isInitialized() {
    try {
      Get.rootController;

      return true;
    } catch (_) {
      try {
        run(!MainConfiguration.data.isBackground.value, MainConfiguration.data.isBackground.value);
      } catch (e) {
        run(false, true);
      }

      return isInitialized();
    }
  }

  void _navigate() {
    if(isInitialized()) {
      _handleRouting();
    } else {
      Future.delayed(Duration(milliseconds: 900), _handleRouting);
    }
  }

  void _resetResources() {
    _notifier = null;
  }

  void _handleRouting() {
    if(_notifier != null) {
      remoteNotificationAction.dismissById(_notifier!.id);
      notifyController.removeCreated(foreign: _notifier!.foreign, id: _notifier!.id);

      if(_notifier!.isGoActivity) {
        GoActivityNotification notification = GoActivityNotification.fromJson(_notifier!.data);
        Navigate.all(ParentLayout.route);
        GoActivityViewerLayout.open(activityId: notification.id, onUpdated: (GoActivity activity) {});
      } else if(_notifier!.isGoBCap) {
        GoBCapNotification notification = GoBCapNotification.fromJson(_notifier!.data);
        Navigate.all(ParentLayout.route);
        GoBCapViewerLayout.open(capId: notification.id, onUpdated: (GoBCap activity) {});
      } else if(_notifier!.isGoTrend) {
        Navigate.all(ParentLayout.route);
      }
    } else {
      Navigate.all(ParentLayout.route);
    }

    _resetResources();
  }
}