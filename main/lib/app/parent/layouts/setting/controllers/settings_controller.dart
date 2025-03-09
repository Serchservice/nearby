import 'package:drive/library.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:smart/smart.dart';

class SettingsController extends GetxController {
  SettingsController();
  static SettingsController get data {
    try {
      return Get.find<SettingsController>();
    } catch (_) {
      Get.put(SettingsController());
      return Get.find<SettingsController>();
    }
  }

  final state = SettingsState();

  final InAppReview inAppReview = InAppReview.instance;

  @override
  void onInit() {
    _fetchPackageDetails();

    super.onInit();
  }

  void _fetchPackageDetails() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    state.appName.value = packageInfo.appName;
    state.appPackage.value = packageInfo.packageName;
    state.appVersion.value = packageInfo.version;
    state.appBuildNumber.value = packageInfo.buildNumber;
  }

  void updateTheme(ThemeType theme) {
    if(theme == ThemeType.light) {
      Get.changeThemeMode(ThemeMode.light);
    } else {
      Get.changeThemeMode(ThemeMode.dark);
    }

    Preference preference = Database.instance.preference.copyWith(theme: theme);
    state.theme.value = theme;
    Database.instance.savePreference(preference);
  }

  void appStoreReview() async {
    bool isAvailable = await inAppReview.isAvailable();
    if(isAvailable) {
      await inAppReview.requestReview();
    } else {
      notify.tip(message: "Unable to use in-app rating at the moment. Try again later");
    }
  }

  List<ButtonView> appInformation = [
    ButtonView(header: "Visit Serchservice", index: 0, icon: CupertinoIcons.sidebar_left, path: LinkUtils.instance.baseUrl),
    // ButtonView(header: "Acknowledgement", index: 1, icon: CupertinoIcons.gift_fill),
    ButtonView(header: "Legal", index: 2, icon: CupertinoIcons.person_crop_circle_badge_checkmark)
  ];

  void handleAppInformation(ButtonView view, BuildContext context) {
    if(view.index.equals(0)) {
      RouteNavigator.openWeb(header: "Serchservice", url: view.path);
    } else if(view.index.equals(1)) {
      showLicensePage(
        context: context,
        applicationName: state.appName.value,
        applicationVersion: state.appVersion.value,
        applicationLegalese: "Your nearby search, refined"
      );
    } else {
      _openLegal();
    }
  }

  void _openLegal() {
    Navigate.bottomSheet(
      sheet: AppInformationSheet(
        options: LinkUtils.instance.legalLinks,
        header: "Legal | Serch",
        onTap: (view) {
          RouteNavigator.openWeb(header: view.header, url: view.path);
        }
      ),
      route: "/centre/app/legal",
      background: Colors.transparent
    );
  }

  void handleHelpAndSupport(ButtonView view) {
    if(view.index.equals(0)) {
      RouteNavigator.mail(view.path);
    } else if(view.index.equals(1)) {
      RouteNavigator.callNumber(view.path);
    } else if(view.index.equals(3)) {
      RouteNavigator.openWeb(header: view.header, url: view.path);
    }
  }

  void handleMore(DomainAppLink link) {
    if(PlatformEngine.instance.isWeb) {
      RouteNavigator.openLink(url: link.web);
    } else if(PlatformEngine.instance.isAndroid) {
      RouteNavigator.openLink(url: link.android);
    }
  }
}