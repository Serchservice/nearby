import 'package:drive/library.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:get/get.dart';

final InAppReview inAppReview = InAppReview.instance;

class AppDrawerController extends GetxController {
  AppDrawerController();
  final state = AppDrawerState();

  @override
  void onInit() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    state.appName.value = packageInfo.appName;
    state.appPackage.value = packageInfo.packageName;
    state.appVersion.value = packageInfo.version;
    state.appBuildNumber.value = packageInfo.buildNumber;

    super.onInit();
  }

  void updateTheme(ThemeType theme) {
    if(theme == ThemeType.light) {
      Get.changeThemeMode(ThemeMode.light);
    } else {
      Get.changeThemeMode(ThemeMode.dark);
    }

    Preference preference = Database.preference.copyWith(theme: theme);
    state.theme.value = theme;
    Database.savePreference(preference);
  }

  void appStoreReview() async {
    bool isAvailable = await inAppReview.isAvailable();
    if(isAvailable) {
      await inAppReview.requestReview();
    } else {
      notify.tip(message: "Unable to use in-app rating at the moment. Try again later");
    }
  }

  void openLegal() {
    List<ButtonView> options = [
      ButtonView(
        header: "Community Guidelines",
        icon: Icons.people_rounded,
        path: "${Constants.baseWeb}${Constants.communityGuidelines}",
      ),
      ButtonView(
        header: "Non-Discrimination Policy",
        icon: Icons.warning_rounded,
        path: "${Constants.baseWeb}${Constants.nonDiscriminationPolicy}",
      ),
      ButtonView(
        header: "Privacy Policy",
        icon: Icons.privacy_tip_rounded,
        path: "${Constants.baseWeb}${Constants.privacyPolicy}",
      ),
      ButtonView(
        header: "Terms and Condition",
        icon: Icons.confirmation_number_rounded,
        path: "${Constants.baseWeb}${Constants.termsAndConditions}",
      ),
      ButtonView(
        header: "Zero Tolerance Policy",
        icon: Icons.not_interested_rounded,
        path: "${Constants.baseWeb}${Constants.zeroTolerancePolicy}",
      ),
    ];

    Navigate.bottomSheet(
      sheet: AppInformationSheet(
        options: options,
        header: "Legal | Serch",
        onTap: (view) {
          RouteNavigator.openWeb(
            header: view.header,
            url: view.path
          );
        }
      ),
      route: "/centre/app/legal",
      background: Colors.transparent
    );
  }

  List<ButtonView> connect = [
    ButtonView(
      header: "Mail",
      body: "Send us an email when it is your best option.",
      icon: CupertinoIcons.mail_solid,
      path: "account@serchservice.com",
      index: 0
    ),
    ButtonView(
      header: "Call us",
      body: "Get all the help you need with a live assistant.",
      icon: Icons.phone,
      path: "+18445871030",
      index: 1
    ),
  ];
}