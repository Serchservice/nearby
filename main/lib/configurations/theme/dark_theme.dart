import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart/styles.dart';

class DarkTheme extends ThemeDataFactory {
  DarkTheme(super.settings);

  @override
  ThemeData get theme => ThemeData(
    useMaterial3: true,
    visualDensity: settings.density,
    textTheme: settings.text.apply(bodyColor: primaryColor),
    scaffoldBackgroundColor: backgroundColor,
    iconTheme: IconThemeData(color: primaryColor),
    appBarTheme: AppBarTheme(
      color: alternateColor,
      surfaceTintColor: alternateColor,
      titleTextStyle: TextStyle(
        color: primaryColor,
        fontFamily: settings.style.fontFamily,
        fontSize: 16
      ),
      iconTheme: IconThemeData(color: primaryTextColor),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark, // IOS
        systemNavigationBarColor: alternateColor,
        statusBarColor: alternateColor,
        statusBarIconBrightness: Brightness.light, // Android
        systemNavigationBarIconBrightness: Brightness.light, // Android
      )
    ),
    primaryColor: primaryTextColor,
    primaryColorLight: secondaryColor,
    primaryColorDark: primaryTextColor,
    // focusColor: primaryColor,
    splashColor: alternateColor,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: primaryColor, // Change the cursor color
      selectionColor: selectionColor, // Change the highlight color
      selectionHandleColor: primaryColor, // Change the cursor head color
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: primaryColor),
    bottomAppBarTheme: BottomAppBarTheme(color: alternateColor),
    colorScheme: const ColorScheme.dark().copyWith(
      surface: selectionColor,
      brightness: Brightness.dark,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: alternateColor,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if(states.contains(WidgetState.selected)) {
          return TextStyle(color: primaryTextColor, fontSize: 12);
        } else {
          return TextStyle(color: secondaryColor, fontSize: 12);
        }
      }),
    )
  );

  @override
  Color get alternateColor => Color(0xff212836);

  @override
  Color get backgroundColor => Color(0xff050404);

  @override
  Color get primaryColor => Color(0xff14181b);

  @override
  Color get primaryTextColor => Color(0xffffffff);

  @override
  Color get secondaryColor => Color(0xfff1f1f1);

  @override
  Color get secondaryTextColor => Color(0xFF3A3F43);

  @override
  Color get selectionColor => Color(0xff0e1218);
}