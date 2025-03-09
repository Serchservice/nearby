import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:drive/library.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:smart/smart.dart';

final GlobalKey<ScaffoldState> mainLayoutKey = GlobalKey<ScaffoldState>();
final carReverseImage = Database.instance.isLightTheme
    ? Assets.commonDriveCarBlackReverse
    : Assets.commonDriveCarWhiteReverse;
final carDriveReverseImage = Database.instance.isLightTheme
    ? Assets.commonDriveBlackReverse
    : Assets.commonDriveWhiteReverse;
final carDriveImage = Database.instance.isLightTheme
    ? Assets.commonDriveCarBlack
    : Assets.commonDriveCarWhite;

class LayoutWrapper extends StatelessWidget {
  final Key? layoutKey;
  final bool withActivity;
  final Widget child;
  final Widget? floatingButton;
  final PreferredSizeWidget? appbar;
  final Widget? bottomNavbar;
  final Widget? bottomSheet;
  final Widget? floater;
  final FloatingConfig floatConfig;
  final Color? backgroundColor;
  final Color? barColor;
  final Color? navigationColor;
  final bool needSafeArea;
  final FloatingActionButtonLocation? floatingLocation;
  final bool extendBody;
  final bool extendBehindAppbar;
  final bool goDark;
  final bool shouldOverride;
  final ThemeType? theme;
  final Widget? drawer;
  final Widget? endDrawer;
  final PopScreenInvoked? onWillPop;

  const LayoutWrapper({
    super.key,
    this.layoutKey,
    required this.child,
    this.floatingButton,
    this.appbar,
    this.bottomNavbar,
    this.bottomSheet,
    this.floater,
    this.needSafeArea = true,
    this.backgroundColor,
    this.floatingLocation,
    this.extendBody = false,
    this.extendBehindAppbar = false,
    this.goDark = false,
    this.onWillPop,
    this.theme,
    this.drawer,
    this.endDrawer,
    this.shouldOverride = false,
    this.barColor,
    this.withActivity = true,
    this.navigationColor,
    this.floatConfig = const FloatingConfig(bottom: 230.0),
  });

  @override
  Widget build(BuildContext context) {
    Color systemNavigationBarColor = navigationColor ?? Theme.of(context).scaffoldBackgroundColor;
    Color statusBarColor = barColor ?? Theme.of(context).scaffoldBackgroundColor;

    return Obx(() {
      return ViewLayout(
        appbar: appbar,
        drawer: drawer,
        floater: floater,
        onWillPop: onWillPop,
        endDrawer: endDrawer,
        extendBody: extendBody,
        bottomSheet: bottomSheet,
        bottomNavbar: bottomNavbar,
        withActivity: withActivity,
        needSafeArea: needSafeArea,
        floatingButton: floatingButton,
        // key: layoutKey ?? mainLayoutKey,
        floatConfig: floatConfig,
        backgroundColor: backgroundColor,
        floatingLocation: floatingLocation,
        useFloaterWidth: false,
        extendBehindAppbar: extendBehindAppbar,
        theme: theme ?? Database.instance.theme,
        isLoading: MainConfiguration.data.showLoading.value,
        darkBackgroundColor: MainTheme.instance.darkBackgroundColor,
        barColor: barColor ?? Theme.of(context).scaffoldBackgroundColor,
        navigationColor: navigationColor ?? Theme.of(context).scaffoldBackgroundColor,
        config: UiConfig(
          statusBarColor: statusBarColor,
          systemNavigationBarColor: systemNavigationBarColor,
          statusBarIconBrightness: statusBarColor.isWhiteRange() ? Brightness.dark : Brightness.light,
          systemNavigationBarIconBrightness: systemNavigationBarColor.isWhiteRange() ? Brightness.dark : Brightness.light,
        ),
        onInactivity: (PointerDownEvent? down, PointerMoveEvent? move, PointerUpEvent? up, PointerHoverEvent? hover) {
          InterstitialAdManager manager = InterstitialAdManager();
          manager.showAdIfAvailable();
        },
        child: child,
      );
    });
  }
}