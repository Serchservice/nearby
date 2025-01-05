import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Color darkPrimaryColor = const Color(0xff14181b);
Color darkSecondaryColor = const Color(0xfff1f1f1);
Color darkAlternateColor = const Color(0xff212836);
Color darkPrimaryTextColor = const Color(0xffffffff);
Color darkSecondaryTextColor = const Color(0xFF3A3F43);
Color darkBackgroundColor = const Color(0xff050404);
Color darkSelectionColor = const Color(0xff0e1218);

class DarkTheme {
  VisualDensity visualDensity;
  TextTheme textTheme;
  TextTheme logoTheme;
  TextStyle mainFont;

  DarkTheme({
    required this.logoTheme,
    required this.textTheme,
    required this.visualDensity,
    required this.mainFont
  });

  ThemeData get theme => ThemeData(
    useMaterial3: true,
    visualDensity: visualDensity,
    textTheme: textTheme.apply(bodyColor: darkPrimaryColor),
    scaffoldBackgroundColor: darkBackgroundColor,
    iconTheme: IconThemeData(color: darkPrimaryColor),
    appBarTheme: AppBarTheme(
      color: darkAlternateColor,
      surfaceTintColor: darkAlternateColor,
      titleTextStyle: TextStyle(
        color: darkPrimaryColor,
        fontFamily: mainFont.fontFamily,
        fontSize: 16
      ),
      iconTheme: IconThemeData(color: darkPrimaryTextColor),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark, // IOS
        systemNavigationBarColor: darkAlternateColor,
        statusBarColor: darkAlternateColor,
        statusBarIconBrightness: Brightness.light, // Android
        systemNavigationBarIconBrightness: Brightness.light, // Android
      )
    ),
    primaryColor: darkPrimaryTextColor,
    primaryColorLight: darkSecondaryColor,
    primaryColorDark: darkPrimaryTextColor,
    // focusColor: darkPrimaryColor,
    splashColor: darkAlternateColor,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: darkPrimaryColor, // Change the cursor color
      selectionColor: darkSelectionColor, // Change the highlight color
      selectionHandleColor: darkPrimaryColor, // Change the cursor head color
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: darkPrimaryColor),
    bottomAppBarTheme: BottomAppBarTheme(color: darkAlternateColor),
    colorScheme: const ColorScheme.dark().copyWith(
      surface: darkSelectionColor,
      brightness: Brightness.dark,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: darkAlternateColor,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if(states.contains(WidgetState.selected)) {
          return TextStyle(color: darkPrimaryTextColor, fontSize: 12);
        } else {
          return TextStyle(color: darkSecondaryColor, fontSize: 12);
        }
      }),
    )
  );
}