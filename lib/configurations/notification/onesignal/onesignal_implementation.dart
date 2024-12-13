import 'package:drive/library.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalImplementation implements OneSignalService {
  final FirebaseRemoteConfigService _configService = FirebaseRemoteConfigImplementation();

  @override
  void initialize() {
    OneSignal.initialize(_configService.getOneSignalId());
    OneSignal.Notifications.clearAll();
    OneSignal.LiveActivities.setupDefault();

    if(Database.address.state.isNotEmpty) {
      addLocationTag(Database.address);
    } else if(Database.address.country.isNotEmpty) {
      addLocationTag(Database.address);
    }
  }

  @override
  void addLocationTag(Address location) {
    OneSignal.User.addTags(location.toJson());
  }

  @override
  void addSearchTag(CategorySection tag) {
    OneSignal.User.addTags(tag.toJson());
  }
}