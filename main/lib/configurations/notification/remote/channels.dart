import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:drive/library.dart';

class Channel {
  static const otherKey = "Other";
  static const otherName = "Other Notification";
  static const otherDescription = "Notification for other information";
}

class ChannelGroup {
  static const otherKey = "others";
  static const otherName = "Others";
}

class LocalNotificationChannel {
  static List<NotificationChannel> channels = [
    /// [OTHER CHANNEL]
    NotificationChannel(
      channelGroupKey: ChannelGroup.otherKey,
      channelKey: Channel.otherKey,
      channelName: Channel.otherName,
      channelDescription: Channel.otherDescription,
      importance: NotificationImportance.High,
      channelShowBadge: true,
      playSound: true,
      ledColor: darkBackgroundColor,
      defaultColor: darkBackgroundColor,
      soundSource: "resource://raw/res_notify",
      defaultPrivacy: NotificationPrivacy.Public,
    ),
  ];

  /// This contains the different channel groups
  static List<NotificationChannelGroup> groups = [
    /// [OTHER CHANNEL GROUP]
    NotificationChannelGroup(
        channelGroupKey: ChannelGroup.otherKey,
        channelGroupName: ChannelGroup.otherName
    ),
  ];
}