import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:drive/library.dart';

const ResponsiveScreenSettings screenSettings = ResponsiveScreenSettings(
  desktopChangePoint: 800,
  tabletChangePoint: 700,
  watchChangePoint: 600
);

final GlobalKey<ScaffoldState> mainLayoutKey = GlobalKey<ScaffoldState>();
final carReverseImage = Database.preference.isLightTheme
    ? Assets.commonDriveCarBlackReverse
    : Assets.commonDriveCarWhiteReverse;
final carDriveReverseImage = Database.preference.isLightTheme
    ? Assets.commonDriveBlackReverse
    : Assets.commonDriveWhiteReverse;
final carDriveImage = Database.preference.isLightTheme
    ? Assets.commonDriveCarBlack
    : Assets.commonDriveCarWhite;

class MainLayout extends StatelessWidget {
  const MainLayout({
    super.key,
    this.layoutKey,
    required this.child,
    this.floatingButton,
    this.appbar,
    this.bottomNavbar,
    this.bottomSheet,
    this.floater,
    this.floaterPosition = 230.0,
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
    this.barColor
  });

  final Key? layoutKey;
  final Widget child;
  final Widget? floatingButton;
  final PreferredSizeWidget? appbar;
  final Widget? bottomNavbar;
  final Widget? bottomSheet;
  final Widget? floater;
  final double floaterPosition;
  final Color? backgroundColor;
  final Color? barColor;
  final bool needSafeArea;
  final FloatingActionButtonLocation? floatingLocation;
  final bool extendBody;
  final bool extendBehindAppbar;
  final bool goDark;
  final bool shouldOverride;
  final ThemeType? theme;
  final Widget? drawer;
  final Widget? endDrawer;
  final Function(bool, dynamic)? onWillPop;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: shouldOverride
          ? backgroundColor
          : goDark
          ? darkBackgroundColor
          : barColor ?? Theme.of(context).scaffoldBackgroundColor,
        systemNavigationBarColor: shouldOverride
          ? backgroundColor
          : goDark
          ? darkBackgroundColor
          : Theme.of(context).scaffoldBackgroundColor,
        statusBarIconBrightness: goDark
          ? Brightness.light
          : (theme != null && theme == ThemeType.light) || Database.preference.isLightTheme
            ? Brightness.dark
            : Brightness.light,
        systemNavigationBarIconBrightness: goDark
          ? Brightness.light
          : (theme != null && theme == ThemeType.light) || Database.preference.isLightTheme
            ? Brightness.dark
            : Brightness.light,
      ),
      child: PopScope(
        onPopInvokedWithResult: (value, result) {
          Logger.log(value);
          Navigate.back();
        },
        child: Scaffold(
          key: layoutKey ?? mainLayoutKey,
          appBar: appbar,
          extendBody: extendBody,
          drawer: drawer,
          endDrawer: endDrawer,
          extendBodyBehindAppBar: extendBehindAppbar,
          backgroundColor: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
          body: _buildBody(context),
          floatingActionButton: floatingButton,
          floatingActionButtonLocation: floatingLocation,
          bottomNavigationBar: bottomNavbar,
          bottomSheet: bottomSheet,
        ),
      )
    );
  }

  Widget _buildBody(BuildContext context) {
    if(floater != null && needSafeArea) {
      return SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).width,
              child: child
            ),
            Positioned(
              bottom: floaterPosition,
              child: SizedBox(
                width: Get.width,
                child: floater!
              )
            )
          ],
        )
      );
    }

    if(floater != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
            child: child
          ),
          Positioned(
            bottom: floaterPosition,
            child: SizedBox(
              width: Get.width,
              child: floater!
            )
          )
        ],
      );
    }

    if(needSafeArea) {
      return SafeArea(child: child);
    }

    return child;
  }
}