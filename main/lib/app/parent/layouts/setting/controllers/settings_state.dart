import 'package:drive/library.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:smart/smart.dart';

class SettingsState {
  /// Current theme mode
  Rx<ThemeType> theme = Database.instance.theme.obs;

  /// App Version
  RxString appVersion = "".obs;

  /// App Name
  RxString appName = "".obs;

  /// App Build Number
  RxString appBuildNumber = "".obs;

  /// App Package
  RxString appPackage = "".obs;
}