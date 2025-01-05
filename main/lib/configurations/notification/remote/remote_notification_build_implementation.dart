import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:drive/library.dart';

const String notifyKey = "snt";

class RemoteNotificationBuildImplementation implements RemoteNotificationBuildService {
  int createUniqueId() => DateTime.now().millisecondsSinceEpoch.remainder(100000);

  @override
  void build({required RemoteMessage message, bool isBackground = false, bool shouldNavigate = false}) {
    buildOthers(message: message, isBackground: isBackground);
  }
  @override
  void buildOthers({required RemoteMessage message, bool isBackground = false}) async {
    int id = createUniqueId();

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: Channel.otherKey,
        title: message.notification?.title,
        body: message.notification?.body,
        showWhen: true,
        wakeUpScreen: true,
        category: NotificationCategory.Message,
        payload: message.data.cast(),
        roundedLargeIcon: true,
        color: lightAlternateColor,
        notificationLayout: NotificationLayout.Messaging,
      ),
    );
  }
}