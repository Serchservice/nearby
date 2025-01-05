import 'package:drive/library.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsController extends GetxController {
  SettingsController();
  static SettingsController get data => Get.find<SettingsController>();

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

  List<ButtonView> appInformation = [
    ButtonView(header: "Visit Serchservice", index: 0, icon: CupertinoIcons.sidebar_left, path: Constants.baseWeb),
    ButtonView(header: "Acknowledgement", index: 1, icon: CupertinoIcons.gift_fill),
    ButtonView(header: "Legal", index: 2, icon: CupertinoIcons.person_crop_circle_badge_checkmark)
  ];

  void handleAppInformation(ButtonView view, BuildContext context) {
    if(view.index == 0) {
      RouteNavigator.openWeb(header: "Serchservice", url: view.path);
    } else if(view.index == 1) {
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
          RouteNavigator.openWeb(header: view.header, url: view.path);
        }
      ),
      route: "/centre/app/legal",
      background: Colors.transparent
    );
  }

  List<ButtonView> helpAndSupport = [
    ButtonView(
      header: "Mail",
      body: "Send us an email when it is your best option.",
      icon: CupertinoIcons.bubble_left_bubble_right_fill,
      path: "account@serchservice.com",
      index: 0
    ),
    ButtonView(
      header: "Call us",
      body: "Get all the help you need with a live assistant.",
      icon: CupertinoIcons.phone_circle,
      path: "+18445871030",
      index: 1
    ),
  ];

  void handleHelpAndSupport(ButtonView view) {
    if(view.index == 0) {
      RouteNavigator.mail(view.path);
    } else if(view.index == 1) {
      RouteNavigator.callNumber(view.path);
    }
  }

  List<ButtonView> more = [
    ButtonView(
      header: "Serch",
      body: "Find service providers that can fix the issues you're having easily.",
      image: Assets.appUser,
      index: 0
    ),
    ButtonView(
      header: "Serch Provider",
      body: "Earn, grow and get certified with your skill as a service provider.",
      image: Assets.appProvider,
      index: 1
    ),
    ButtonView(
      header: "Serch Business",
      body: "Increase your revenue by moving your organization to our business platform.",
      image: Assets.appBusiness,
      index: 2
    ),
  ];

  void handleMore(ButtonView view) {
    if(view.index == 0) {
      if(PlatformEngine.instance.isWeb) {
        RouteNavigator.openLink(url: "https://user.serchservice.com");
      } else if(PlatformEngine.instance.isAndroid) {
        RouteNavigator.openLink(url: "https://play.google.com/store/apps/details?id=com.serchservice.user");
      }
    } else if(view.index == 1) {
      if(PlatformEngine.instance.isWeb) {
        RouteNavigator.openLink(url: "https://provider.serchservice.com");
      } else if(PlatformEngine.instance.isAndroid) {
        RouteNavigator.openLink(url: "https://play.google.com/store/apps/details?id=com.serchservice.artisan");
      }
    } else {
      if(PlatformEngine.instance.isWeb) {
        RouteNavigator.openLink(url: "https://business.serchservice.com");
      } else if(PlatformEngine.instance.isAndroid) {
        RouteNavigator.openLink(url: "https://play.google.com/store/apps/details?id=com.serchservice.enterprise");
      }
    }
  }

  void onAppDownload() => RouteNavigator.openLink(url: "https://www.serchservice.com/platform");
}