import 'package:flutter/material.dart';
import 'package:drive/library.dart';
import 'package:google_fonts/google_fonts.dart';

class MainTheme {
  static final VisualDensity visualDensity = VisualDensity.adaptivePlatformDensity;

  static final TextTheme textTheme = PlatformEngine.instance.isWebWasm
      ? theme("Nunito")
      : GoogleFonts.nunitoTextTheme();

  static final TextTheme logoTheme = PlatformEngine.instance.isWebWasm
      ? theme("League Spartan")
      : GoogleFonts.leagueSpartanTextTheme();

  static final TextStyle mainFont = PlatformEngine.instance.isWebWasm
      ? TextStyle(fontFamily: "Nunito")
      : GoogleFonts.nunito();

  static ThemeData get light => LightTheme(
    logoTheme: logoTheme,
    textTheme: textTheme,
    visualDensity: visualDensity,
    mainFont: mainFont
  ).theme;

  static ThemeData get dark => DarkTheme(
    logoTheme: logoTheme,
    textTheme: textTheme,
    visualDensity: visualDensity,
    mainFont: mainFont
  ).theme;

  /// Returns a `TextStyle` for the given font family, weight, and style.
  static TextStyle style(String fontFamily, TextStyle? style) {
    style ??= TextStyle();
    return style.copyWith(fontFamily: fontFamily);
  }

  /// Returns a `TextTheme` based on the specified font family.
  static TextTheme theme(String fontFamily, [TextTheme? baseTheme]) {
    baseTheme ??= ThemeData.light().textTheme;

    return TextTheme(
      displayLarge: style(fontFamily, baseTheme.displayLarge),
      displayMedium: style(fontFamily, baseTheme.displayMedium),
      displaySmall: style(fontFamily, baseTheme.displaySmall),
      headlineLarge: style(fontFamily, baseTheme.headlineLarge),
      headlineMedium: style(fontFamily, baseTheme.headlineMedium),
      headlineSmall: style(fontFamily, baseTheme.headlineSmall),
      titleLarge: style(fontFamily, baseTheme.titleLarge),
      titleMedium: style(fontFamily, baseTheme.titleMedium),
      titleSmall: style(fontFamily, baseTheme.titleSmall),
      bodyLarge: style(fontFamily, baseTheme.bodyLarge),
      bodyMedium: style(fontFamily, baseTheme.bodyMedium),
      bodySmall: style(fontFamily, baseTheme.bodySmall),
      labelLarge: style(fontFamily, baseTheme.labelLarge),
      labelMedium: style(fontFamily, baseTheme.labelMedium),
      labelSmall: style(fontFamily, baseTheme.labelSmall),
    );
  }
}