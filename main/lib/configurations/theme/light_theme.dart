import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Color lightPrimaryColor = const Color(0xff050404);
Color lightSecondaryColor = const Color(0xff222222);
Color lightAlternateColor = const Color(0xfff1f1f1);
Color lightPrimaryTextColor = const Color(0xff14181b);
Color lightSecondaryTextColor = const Color(0xff57636c);
Color lightBackgroundColor = const Color(0xffffffff);
Color lightSelectionColor = const Color(0xffe3e3e3);

class LightTheme {
  VisualDensity visualDensity;
  TextTheme textTheme;
  TextTheme logoTheme;
  TextStyle mainFont;

  LightTheme({
    required this.logoTheme,
    required this.textTheme,
    required this.visualDensity,
    required this.mainFont
  });

  ThemeData get theme => ThemeData(
    useMaterial3: true,
    visualDensity: visualDensity,
    textTheme: textTheme.apply(bodyColor: lightPrimaryColor),
    iconTheme: IconThemeData(color: lightPrimaryColor),
    appBarTheme: AppBarTheme(
      color: lightAlternateColor,
      surfaceTintColor: lightAlternateColor,
      titleTextStyle: TextStyle(
        color: lightPrimaryColor,
        fontFamily: mainFont.fontFamily,
        fontSize: 16
      ),
      iconTheme: IconThemeData(color: lightPrimaryTextColor),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light, // IOS
        systemNavigationBarColor: lightAlternateColor,
        statusBarColor: lightAlternateColor,
        statusBarIconBrightness: Brightness.dark, // Android
        systemNavigationBarIconBrightness: Brightness.dark, // Android
      )
    ),
    scaffoldBackgroundColor: lightBackgroundColor,
    primaryColor: lightPrimaryColor,
    primaryColorLight: lightSecondaryTextColor,
    primaryColorDark: lightSecondaryColor,
    // focusColor: SColors.darkTheme,
    splashColor: lightAlternateColor,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: lightPrimaryColor, // Change the cursor color
      selectionColor: lightSelectionColor, // Change the highlight color
      selectionHandleColor: lightPrimaryColor, // Change the cursor head color
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: lightPrimaryColor),
    bottomAppBarTheme: BottomAppBarTheme(color: lightAlternateColor,),
    colorScheme: const ColorScheme.light().copyWith(
      surface: lightSelectionColor,
      brightness: Brightness.light,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: lightAlternateColor,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if(states.contains(WidgetState.selected)) {
          return TextStyle(color: lightPrimaryTextColor, fontSize: 12);
        } else {
          return TextStyle(color: lightSecondaryColor, fontSize: 12);
        }
      }),
    )
  );
}